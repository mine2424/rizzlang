import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.21.0'
import { verifyAuth } from '../_shared/auth.ts'

// ============================================================
// 型定義
// ============================================================
interface WritingError {
  original: string
  corrected: string
  explanation: string
}

interface WritingCheckResult {
  corrected: string
  errors: WritingError[]
  score: number
  praise: string
  tip: string
}

// ============================================================
// メインハンドラー
// ============================================================
serve(async (req: Request) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ── 初期化 ──
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const geminiKey = Deno.env.get('GEMINI_API_KEY')!

    const supabase = createClient(supabaseUrl, supabaseKey)

    // ── 認証（共通ミドルウェア）──
    const { user, error: authError } = await verifyAuth(req, supabase)
    if (authError || !user) {
      const errRes = authError!
      return new Response(await errRes.text(), {
        status: errRes.status,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const userId = user.id

    // ── リクエストボディ ──
    const { userText, language, contextMessage, characterId } = await req.json()

    if (!userText || !language) {
      return new Response(
        JSON.stringify({ error: 'MISSING_PARAMS', message: 'userText and language are required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // ── 言語名マッピング ──
    const languageNames: Record<string, string> = {
      ko: '韓国語',
      en: '英語',
      tr: 'トルコ語',
      vi: 'ベトナム語',
      ar: 'アラビア語',
    }
    const languageName = languageNames[language] ?? language

    // ── System Prompt 構築 ──
    const systemPrompt = `あなたは${languageName}の語学コーチです。
ユーザーが${languageName}で書いたメッセージを添削してください。

ユーザーの文: "${userText}"
${contextMessage ? `会話の文脈: "${contextMessage}"` : ''}

以下のJSONのみを返す（余分なテキスト・マークダウン禁止）:
{
  "corrected": "（自然な${languageName}表現）",
  "errors": [
    {"original": "間違いの部分", "corrected": "正しい形", "explanation": "日本語で理由20文字以内"}
  ],
  "score": 85,
  "praise": "（良かった点・日本語で励ます）",
  "tip": "（一言アドバイス・日本語20文字以内）"
}

注意:
- errors は空配列でもOK（完璧な場合）
- score は 0-100 の整数
- corrected は自然なネイティブ表現に修正したもの
- praise は必ず存在する（何かポジティブな点を見つける）
- tip は短く実用的なアドバイス`

    // ── Gemini API 呼び出し ──
    const genAI = new GoogleGenerativeAI(geminiKey)
    const model = genAI.getGenerativeModel({
      model: 'gemini-1.5-flash',
      systemInstruction: systemPrompt,
    })

    let result: WritingCheckResult | null = null
    let lastError: Error | null = null

    for (let attempt = 0; attempt < 3; attempt++) {
      try {
        const chat = model.startChat({ history: [] })
        const response = await chat.sendMessage(
          `次の${languageName}の文を添削してください: "${userText}"`
        )
        const rawText = response.response.text().trim()

        // JSONブロックを抽出
        const jsonMatch = rawText.match(/\{[\s\S]*\}/)
        if (!jsonMatch) throw new Error('Invalid JSON response from Gemini')

        result = JSON.parse(jsonMatch[0]) as WritingCheckResult
        break
      } catch (e) {
        lastError = e as Error
        if (attempt < 2) {
          await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, attempt)))
        }
      }
    }

    // フォールバック
    if (!result) {
      console.error('Gemini error after retries:', lastError)
      result = {
        corrected: userText,
        errors: [],
        score: 70,
        praise: '挑戦することが大切です！',
        tip: '引き続き練習しましょう',
      }
    }

    const { corrected, errors, score, praise, tip } = result

    // ── 1-1: 添削履歴を conversations テーブルに保存 ──
    const defaultCharacterId = 'c1da0000-0000-0000-0000-000000000001'
    try {
      await supabase.from('conversations').insert([
        {
          user_id: userId,
          character_id: characterId ?? defaultCharacterId,
          role: 'user',
          content: userText,
          message_type: 'writing_check',
          metadata: { score, errors: errors.length },
        },
        {
          user_id: userId,
          character_id: characterId ?? defaultCharacterId,
          role: 'assistant',
          content: corrected,
          message_type: 'writing_check_result',
          metadata: { score, praise, tip },
        },
      ])
    } catch (saveErr) {
      // 保存失敗はログのみ（レスポンスには影響させない）
      console.error('Failed to save writing check history:', saveErr)
    }

    // ── 1-2: 添削エラー語彙を user_vocabulary に upsert ──
    if (errors.length > 0 && characterId) {
      try {
        const nextReviewAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
        const vocabItems = errors.map((e) => ({
          user_id: userId,
          character_id: characterId,
          word: e.corrected,
          meaning: e.explanation,
          source: 'writing_check',
          ease_factor: 2.5,
          repetitions: 0,
          interval_days: 1,
          next_review_at: nextReviewAt,
        }))

        await supabase.from('user_vocabulary').upsert(vocabItems, {
          onConflict: 'user_id,character_id,word',
          ignoreDuplicates: true,
        })
      } catch (vocabErr) {
        console.error('Failed to upsert vocabulary:', vocabErr)
      }
    }

    return new Response(
      JSON.stringify(result),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(
      JSON.stringify({ error: 'INTERNAL_ERROR', message: String(error) }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

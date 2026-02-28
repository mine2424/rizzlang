import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.21.0'
import { verifyAuth } from '../_shared/auth.ts'

// ============================================================
// 型定義
// ============================================================
interface GrammarExample {
  foreign: string
  japanese: string
}

interface GrammarExplanationResult {
  title: string
  level: string        // 'beginner' | 'intermediate' | 'advanced'
  pattern: string
  explanation: string
  examples: GrammarExample[]
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
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const geminiKey = Deno.env.get('GEMINI_API_KEY')!

    const supabase = createClient(supabaseUrl, supabaseKey)

    const { user, error: authError } = await verifyAuth(req, supabase)
    if (authError || !user) {
      const errRes = authError!
      return new Response(await errRes.text(), {
        status: errRes.status,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { phrase, why, language } = await req.json()

    if (!phrase || !language) {
      return new Response(
        JSON.stringify({ error: 'MISSING_PARAMS', message: 'phrase and language are required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const languageNames: Record<string, string> = {
      ko: '韓国語',
      en: '英語',
      tr: 'トルコ語',
      vi: 'ベトナム語',
      ar: 'アラビア語',
    }
    const languageName = languageNames[language] ?? language

    const systemPrompt = `あなたは${languageName}の文法解説の専門家です。
以下のフレーズ "${phrase}" について、なぜそういう文法になるのかを解説してください。
${why ? `補足: ${why}` : ''}

以下のJSONのみを返す（余分なテキスト・マークダウン禁止）:
{
  "title": "文法タイトル（日本語・20文字以内）",
  "level": "beginner|intermediate|advanced",
  "pattern": "${languageName}のパターン（例: 動詞+아/어서）",
  "explanation": "文法の説明（日本語・100文字以内）",
  "examples": [
    {"foreign": "${languageName}の例文", "japanese": "日本語訳"},
    {"foreign": "${languageName}の例文2", "japanese": "日本語訳2"}
  ]
}`

    const genAI = new GoogleGenerativeAI(geminiKey)
    const model = genAI.getGenerativeModel({
      model: 'gemini-1.5-flash',
      systemInstruction: systemPrompt,
    })

    let result: GrammarExplanationResult | null = null

    for (let attempt = 0; attempt < 3; attempt++) {
      try {
        const chat = model.startChat({ history: [] })
        const response = await chat.sendMessage(`「${phrase}」の文法を解説してください`)
        const rawText = response.response.text().trim()
        const jsonMatch = rawText.match(/\{[\s\S]*\}/)
        if (!jsonMatch) throw new Error('Invalid JSON response')
        result = JSON.parse(jsonMatch[0]) as GrammarExplanationResult
        break
      } catch (e) {
        if (attempt < 2) {
          await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, attempt)))
        }
      }
    }

    if (!result) {
      result = {
        title: '文法解説',
        level: 'beginner',
        pattern: phrase,
        explanation: 'この表現はネイティブがよく使う自然な表現です。',
        examples: [{ foreign: phrase, japanese: '（フレーズ）' }],
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

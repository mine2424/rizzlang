import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.7.0'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// 地우 キャラクタープロンプト
const buildSystemPrompt = (userLevel: number, userCallName: string, timeOfDay: string) => `
あなたは지우（ジウ）、ソウル出身25歳の韓国人女性です。
現在、${userCallName}と付き合っています。

難易度レベル: ${userLevel}
  Lv1 = ひらがな感覚の短文・基本語彙のみ
  Lv2 = スラング入門（ㅋㅋ, ㅠㅠ, 헐, 대박）
  Lv3 = 複合表現（〜겠다, 〜잖아, 〜네）
  Lv4 = ネイティブ感性・慣用句・詩的表現

時間帯: ${timeOfDay}

性格と口調:
- 明るく感情豊か、少し甘えん坊
- スラングと絵文字を自然に使う（🥺💙😭ㅋ）
- K-drama的な口調
- 日本語は一切使わない

会話ルール:
- 1メッセージ2〜3文が最大
- 感情をリアルに表現
- 前の会話の文脈を必ず引き継ぐ
- 難易度レベルに応じた語彙・文型を使用

レスポンスは必ず以下のJSONのみを返す（他のテキスト不可）:
{"reply":"...","why":"...（30文字以内・日本語）","slang":[{"word":"...","meaning":"..."}],"nextMessage":"..."}
`

function getTimeOfDay(): string {
  const hour = new Date().getUTCHours() + 9 // JST
  if (hour >= 5 && hour < 11) return 'morning'
  if (hour >= 11 && hour < 17) return 'afternoon'
  if (hour >= 17 && hour < 21) return 'evening'
  return 'night'
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 認証チェック
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    // JWTからユーザー取得
    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', '')
    )
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // 使用量チェック（無料ユーザー: 1日3往復まで）
    const { data: userData } = await supabase
      .from('users')
      .select('plan, current_level, user_call_name')
      .eq('id', user.id)
      .single()

    if (userData?.plan === 'free') {
      const today = new Date().toISOString().split('T')[0]
      const { data: usageLog } = await supabase
        .from('usage_logs')
        .select('turns_used')
        .eq('user_id', user.id)
        .eq('date', today)
        .single()

      if ((usageLog?.turns_used ?? 0) >= 3) {
        return new Response(JSON.stringify({ error: 'LIMIT_EXCEEDED' }), {
          status: 429,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
      }
    }

    // リクエストボディ解析
    const { userText, conversationId, history, userLevel, userCallName } = await req.json()

    // Gemini 1.5 Flash でAI生成
    const genAI = new GoogleGenerativeAI(Deno.env.get('GEMINI_API_KEY')!)
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

    const systemPrompt = buildSystemPrompt(
      userLevel ?? userData?.current_level ?? 1,
      userCallName ?? userData?.user_call_name ?? 'オッパ',
      getTimeOfDay()
    )

    // 会話履歴を Gemini のフォーマットに変換（直近10往復）
    const recentHistory = (history ?? []).slice(-20)
    const chatHistory = recentHistory.map((m: any) => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }],
    }))

    const chat = model.startChat({
      history: chatHistory,
      systemInstruction: systemPrompt,
    })

    let retries = 0
    let result
    while (retries < 3) {
      try {
        result = await chat.sendMessage(
          `ユーザーが言いたいこと（日本語）: ${userText}`
        )
        break
      } catch (e) {
        retries++
        if (retries === 3) throw e
        await new Promise(r => setTimeout(r, retries * 1000))
      }
    }

    const responseText = result!.response.text().trim()
    const jsonMatch = responseText.match(/\{[\s\S]*\}/)
    if (!jsonMatch) throw new Error('Invalid AI response format')

    const generatedReply = JSON.parse(jsonMatch[0])

    // 使用量・語彙を保存
    const today = new Date().toISOString().split('T')[0]
    await supabase.rpc('increment_usage', { p_user_id: user.id, p_date: today })

    // 語彙を upsert
    if (generatedReply.slang?.length > 0) {
      const vocabItems = generatedReply.slang.map((s: any) => ({
        user_id: user.id,
        word: s.word,
        meaning: s.meaning,
        language: 'ko',
        learned_at: new Date().toISOString(),
        next_review: new Date(Date.now() + 86400000).toISOString(), // +1日
      }))
      await supabase.from('vocabulary').upsert(vocabItems, {
        onConflict: 'user_id,word,language',
      })
    }

    return new Response(JSON.stringify(generatedReply), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  } catch (error) {
    console.error('generate-reply error:', error)
    return new Response(
      JSON.stringify({ error: 'Internal Server Error', message: String(error) }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})

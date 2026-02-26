import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.7.0'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// デモ用固定メッセージ（オンボーディング）
const DEMO_JIU_MESSAGE = "오빠, 오늘 뭐 했어? 🥺 나 보고 싶었어~"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { userText } = await req.json()

    const genAI = new GoogleGenerativeAI(Deno.env.get('GEMINI_API_KEY')!)
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

    const prompt = `
あなたは韓国語学習アプリのデモアシスタントです。
地우（韓国人女性）からのメッセージ: "${DEMO_JIU_MESSAGE}"
ユーザーが返したいこと（日本語）: "${userText}"

以下のJSONのみを返す:
{"reply":"...（自然な韓国語返信）","why":"...（30文字以内・なぜその表現か・日本語）","slang":[{"word":"...","meaning":"..."}],"nextMessage":"...（地우の次のセリフ・韓国語）"}
`

    const result = await model.generateContent(prompt)
    const responseText = result.response.text().trim()
    const jsonMatch = responseText.match(/\{[\s\S]*\}/)
    if (!jsonMatch) throw new Error('Invalid response')

    return new Response(jsonMatch[0], {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(
      JSON.stringify({ error: 'Demo generation failed' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})

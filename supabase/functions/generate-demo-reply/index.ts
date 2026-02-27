import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.7.0'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// デフォルトキャラクター（지우）
const DEFAULT_CHARACTER_ID = 'c1da0000-0000-0000-0000-000000000001'

// キャラクター別デモメッセージ
const DEMO_MESSAGES: Record<string, string> = {
  'c1da0000-0000-0000-0000-000000000001': '오빠, 오늘 뭐 했어? 🥺 나 보고 싶었어~',          // 지우
  'a1da0000-0000-0000-0000-000000000002': 'Hey babe 🥺 I missed you today, what did you do?', // Emma
  'b1da0000-0000-0000-0000-000000000003': 'Canım, bugün nasıldı? 🥺 Seni çok özledim~',       // Elif
  'c2da0000-0000-0000-0000-000000000004': 'Anh ơi, hôm nay anh làm gì vậy? 🥺 Em nhớ anh lắm~', // Linh
  'd1da0000-0000-0000-0000-000000000005': 'Habibi, how was your day? 🥺 I missed you so much~', // Yasmin
}

// キャラクター別言語マップ
const LANGUAGE_MAP: Record<string, string> = {
  'c1da0000-0000-0000-0000-000000000001': 'Korean (한국어)',
  'a1da0000-0000-0000-0000-000000000002': 'English',
  'b1da0000-0000-0000-0000-000000000003': 'Turkish (Türkçe)',
  'c2da0000-0000-0000-0000-000000000004': 'Vietnamese (Tiếng Việt)',
  'd1da0000-0000-0000-0000-000000000005': 'Arabic (Egyptian dialect, LTR)',
}

// キャラクター別学習説明
const LEARNING_DESCRIPTION_MAP: Record<string, string> = {
  'c1da0000-0000-0000-0000-000000000001': '韓国語学習アプリのデモ。지우（韓国人女性）と自然な韓国語で会話する。',
  'a1da0000-0000-0000-0000-000000000002': '英語学習アプリのデモ。Emma（アメリカ人女性）と自然な英語で会話する。',
  'b1da0000-0000-0000-0000-000000000003': 'トルコ語学習アプリのデモ。Elif（トルコ人女性）と自然なトルコ語で会話する。',
  'c2da0000-0000-0000-0000-000000000004': 'ベトナム語学習アプリのデモ。Linh（ベトナム人女性）と自然なベトナム語で会話する。',
  'd1da0000-0000-0000-0000-000000000005': 'アラビア語学習アプリのデモ。Yasmin（エジプト出身女性）とアラビア語・英語ミックスで会話する。',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { userText, characterId: rawCharacterId } = await req.json()

    // characterId の解決（省略時は地우がデフォルト）
    const characterId =
      rawCharacterId && DEMO_MESSAGES[rawCharacterId]
        ? rawCharacterId
        : DEFAULT_CHARACTER_ID

    const demoMessage = DEMO_MESSAGES[characterId]
    const language = LANGUAGE_MAP[characterId]
    const learningDesc = LEARNING_DESCRIPTION_MAP[characterId]

    const genAI = new GoogleGenerativeAI(Deno.env.get('GEMINI_API_KEY')!)
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

    const prompt = `
あなたは${learningDesc}
キャラクターからのメッセージ (${language}): "${demoMessage}"
ユーザーが返したいこと（日本語）: "${userText}"

以下のJSONのみを返す（返信は${language}で書くこと）:
{"reply":"...（自然な${language}返信）","why":"...（30文字以内・なぜその表現か・日本語）","slang":[{"word":"...","meaning":"..."}],"nextMessage":"...（キャラクターの次のセリフ・${language}）"}
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

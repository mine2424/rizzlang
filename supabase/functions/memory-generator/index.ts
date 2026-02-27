import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.7.0'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const genAI = new GoogleGenerativeAI(Deno.env.get('GEMINI_API_KEY')!)
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const now = new Date()
  const weekEnd = new Date(now)
  weekEnd.setDate(now.getDate() - 1)
  const weekStart = new Date(weekEnd)
  weekStart.setDate(weekEnd.getDate() - 6)

  // アクティブユーザー取得（過去7日に会話があったユーザー）
  const { data: activeConvos } = await supabase
    .from('conversations')
    .select('user_id, character_id')
    .gte('created_at', weekStart.toISOString())

  if (!activeConvos?.length) {
    return new Response(JSON.stringify({ processed: 0 }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }

  // user_id + character_id の重複排除
  const pairs = [...new Map(activeConvos.map(c => [`${c.user_id}:${c.character_id}`, c])).values()]

  let processed = 0
  for (const { user_id, character_id } of pairs) {
    try {
      // 過去7日間の会話を取得
      const { data: messages } = await supabase
        .from('conversations')
        .select('role, content, tension_phase, created_at')
        .eq('user_id', user_id)
        .eq('character_id', character_id)
        .gte('created_at', weekStart.toISOString())
        .order('created_at', { ascending: true })
        .limit(50)

      if (!messages?.length) continue

      // キャラクター名を取得
      const { data: character } = await supabase
        .from('characters')
        .select('name, language')
        .eq('id', character_id)
        .single()

      const charName = character?.name?.split('(')[0]?.trim() ?? 'キャラクター'
      const conversationText = messages
        .map(m => `${m.role === 'user' ? 'ユーザー' : charName}: ${m.content}`)
        .join('\n')

      const hasTension = messages.some(m => m.tension_phase)

      const prompt = `
以下は${charName}とユーザーの過去1週間の会話です。
${charName}の視点で、感情的に重要な出来事を日本語で100文字以内で要約してください。
${hasTension ? '⚠ この週に喧嘩や仲直りのシーンがありました。必ず言及してください。' : ''}
一人称は「私」、ユーザーへの呼びかけはキャラクターの callName を使ってください。

会話:
${conversationText.substring(0, 3000)}

以下のJSONのみを返す（他のテキスト不要）:
{"summary":"（100文字以内）","emotional_weight":${hasTension ? '8' : '5'}}
`

      const result = await model.generateContent(prompt)
      const text = result.response.text().trim()
      const json = JSON.parse(text.match(/\{[\s\S]*\}/)![0])

      // week_number: ユーザーの最初の会話からの週数
      const { data: firstConvo } = await supabase
        .from('conversations')
        .select('created_at')
        .eq('user_id', user_id)
        .order('created_at', { ascending: true })
        .limit(1)
        .single()

      const firstDate = firstConvo ? new Date(firstConvo.created_at) : weekStart
      const weekNumber = Math.floor((weekStart.getTime() - firstDate.getTime()) / (7 * 24 * 60 * 60 * 1000)) + 1

      await supabase.from('relationship_memories').upsert({
        user_id,
        character_id,
        week_number: weekNumber,
        week_start: weekStart.toISOString().split('T')[0],
        week_end: weekEnd.toISOString().split('T')[0],
        summary: json.summary,
        emotional_weight: json.emotional_weight ?? 5,
      }, { onConflict: 'user_id,character_id,week_number' })

      processed++
    } catch (e) {
      console.error('memory-generator error for user', user_id, e)
    }
  }

  return new Response(
    JSON.stringify({ processed }),
    { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
})

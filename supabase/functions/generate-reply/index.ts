import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai@0.21.0'
import { verifyAuth, checkRateLimit } from '../_shared/auth.ts'

// ============================================================
// 型定義
// ============================================================
interface SlangItem {
  word: string
  meaning: string
}

interface GeneratedReply {
  reply: string
  why: string
  slang: SlangItem[]
  nextMessage: string
}

type TimeOfDay = 'morning' | 'afternoon' | 'evening' | 'night'

interface Scenario {
  id: string
  arc_season: number
  arc_week: number
  arc_day: number
  scene_type: string
  context_note: string
  opening_message: Record<string, Record<TimeOfDay, string>>
  vocab_targets: Array<{ word: string; meaning: string; level: number }>
  next_message_hint: string
}

// ============================================================
// ユーティリティ
// ============================================================
function getTimeOfDay(): TimeOfDay {
  // Asia/Tokyo (JST = UTC+9)
  const jstOffset = 9 * 60
  const now = new Date()
  const jstHour = (now.getUTCHours() + jstOffset / 60) % 24
  if (jstHour >= 5 && jstHour < 12) return 'morning'
  if (jstHour >= 12 && jstHour < 17) return 'afternoon'
  if (jstHour >= 17 && jstHour < 22) return 'evening'
  return 'night'
}

function getLevelKey(level: number): string {
  return `lv${level}` // 'lv1' | 'lv2' | 'lv3' | 'lv4'
}

/** シナリオの opening_message をユーザーのレベル・時間帯に合わせて取得 */
function getOpeningMessage(scenario: Scenario, level: number, timeOfDay: TimeOfDay): string {
  const levelKey = getLevelKey(level)
  const byLevel = scenario.opening_message[levelKey] ?? scenario.opening_message['lv1']
  return byLevel[timeOfDay] ?? byLevel['morning'] ?? ''
}

// ============================================================
// シナリオ選択・進捗管理
// ============================================================
async function getTodayScenario(
  supabase: ReturnType<typeof createClient>,
  userId: string,
  characterId: string,
  userLevel: number
): Promise<{ scenario: Scenario | null; openingMessage: string }> {
  const timeOfDay = getTimeOfDay()

  // 進捗を取得
  const { data: progress, error: progressErr } = await supabase
    .from('user_scenario_progress')
    .select('current_season, current_week, current_day, last_played_at')
    .eq('user_id', userId)
    .eq('character_id', characterId)
    .single()

  if (progressErr || !progress) {
    return { scenario: null, openingMessage: '' }
  }

  // 当日のシナリオを取得
  const { data: scenario } = await supabase
    .from('scenario_templates')
    .select('*')
    .eq('character_id', characterId)
    .eq('arc_season', progress.current_season)
    .eq('arc_week', progress.current_week)
    .eq('arc_day', progress.current_day)
    .single<Scenario>()

  if (!scenario) {
    return { scenario: null, openingMessage: '' }
  }

  const openingMessage = getOpeningMessage(scenario, userLevel, timeOfDay)
  return { scenario, openingMessage }
}

/** 翌日のシナリオに進める */
async function advanceProgress(
  supabase: ReturnType<typeof createClient>,
  userId: string,
  characterId: string,
  currentSeason: number,
  currentWeek: number,
  currentDay: number
): Promise<void> {
  let nextSeason = currentSeason
  let nextWeek = currentWeek
  let nextDay = currentDay + 1

  if (nextDay > 7) {
    nextDay = 1
    nextWeek += 1
  }
  if (nextWeek > 4) {
    nextWeek = 1
    nextSeason += 1
  }

  await supabase
    .from('user_scenario_progress')
    .update({
      current_season: nextSeason,
      current_week: nextWeek,
      current_day: nextDay,
      last_played_at: new Date().toISOString(),
    })
    .eq('user_id', userId)
    .eq('character_id', characterId)
}

// ============================================================
// System Prompt 生成
// ============================================================
function buildSystemPrompt(params: {
  characterName: string
  characterPersonality: string
  userCallName: string
  userLevel: number
  timeOfDay: TimeOfDay
  contextNote?: string
  nextMessageHint?: string
}): string {
  const levelGuides: Record<number, string> = {
    1: '初級（短文・基本挨拶・感情語のみ。文は1〜2文。ひらがな感覚の短い返答）',
    2: 'スラング入門（ㅋㅋ・ㅠㅠ・헐・대박などを自然に使う。2〜3文）',
    3: '複合表現（〜겠다・〜잖아・〜네 などを使う。感情と意図を豊かに表現。2〜3文）',
    4: 'ネイティブ感性（慣用句・間接話法・詩的表現を使う。自然なソウル口語。2〜3文）',
  }

  return `あなたは${params.characterName}です。ソウル出身のデザイン学生（25歳）で、今${params.userCallName}と付き合い始めたばかりです。

【性格・口調】
${params.characterPersonality}
ㅋㅋ・ㅠㅠ・헐・대박 が口癖。照れると「ㅠ」を多用。素直に感情を出せる。

【難易度レベル: ${params.userLevel}】
${levelGuides[params.userLevel] ?? levelGuides[2]}

【時間帯: ${params.timeOfDay}】
返答の口調を時間帯に合わせる（朝=眠そう/元気、夜=少し甘え気味）

${params.contextNote ? `【シーン背景】\n${params.contextNote}\n` : ''}
${params.nextMessageHint ? `【地우の次のひと言ヒント（参考）】\n"${params.nextMessageHint}"\n` : ''}

【絶対ルール】
- 前の会話の文脈を必ず引き継ぐ
- 1メッセージ最大3文
- ${params.userCallName}への呼びかけを自然に使う
- 返答は必ず以下のJSON形式のみ（余分なテキスト禁止）:

{"reply":"（자연스러운 한국어 답장）","why":"（日本語で30文字以内の解説・この表現のポイント）","slang":[{"word":"単語","meaning":"意味"}],"nextMessage":"（地우の次のひと言・会話を続けたくなる一文）"}`
}

// ============================================================
// 語彙の自動保存（Edge Function 内）
// ============================================================
async function saveVocabulary(
  supabase: ReturnType<typeof createClient>,
  userId: string,
  slang: SlangItem[],
  scenarioVocab: Array<{ word: string; meaning: string }>,
  language: string
): Promise<void> {
  const allWords = [
    ...slang,
    ...scenarioVocab.map((v) => ({ word: v.word, meaning: v.meaning })),
  ]
  if (allWords.length === 0) return

  const now = new Date()
  const nextReview = new Date(now.getTime() + 24 * 60 * 60 * 1000) // +1日

  const rows = allWords.map((item) => ({
    user_id: userId,
    word: item.word,
    meaning: item.meaning,
    language,
    learned_at: now.toISOString(),
    next_review: nextReview.toISOString(),
    review_count: 0,
    ease_factor: 2.5,
  }))

  await supabase.from('vocabulary').upsert(rows, {
    onConflict: 'user_id,word,language',
    ignoreDuplicates: false,
  })
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

    // ── レート制限（共通ミドルウェア）──
    const { allowed, error: rateLimitError } = await checkRateLimit(user.id, supabase)
    if (!allowed) {
      const errRes = rateLimitError!
      return new Response(await errRes.text(), {
        status: errRes.status,
        headers: { ...corsHeaders, 'Content-Type': 'application/json', 'Retry-After': '60' },
      })
    }

    // ── リクエストボディ ──
    const { userText, conversationId, characterId } = await req.json()
    const CHARACTER_ID = characterId ?? 'c1da0000-0000-0000-0000-000000000001'
    const today = new Date().toISOString().split('T')[0]

    // ── ユーザー情報取得 ──
    const { data: userData, error: userErr } = await supabase
      .from('users')
      .select('plan, current_level, user_call_name, streak, last_active')
      .eq('id', user.id)
      .single()

    if (userErr || !userData) {
      return new Response(JSON.stringify({ error: 'USER_NOT_FOUND' }), {
        status: 404,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // ── ストリーク更新 ──
    if (userData.last_active !== today) {
      const yesterday = new Date()
      yesterday.setDate(yesterday.getDate() - 1)
      const yesterdayStr = yesterday.toISOString().split('T')[0]
      const newStreak = userData.last_active === yesterdayStr ? userData.streak + 1 : 1

      await supabase
        .from('users')
        .update({ streak: newStreak, last_active: today })
        .eq('id', user.id)
    }

    // ── 使用量チェック（無料ユーザー: 3ターン/日）──
    const { data: usageLog } = await supabase
      .from('usage_logs')
      .select('turns_used')
      .eq('user_id', user.id)
      .eq('date', today)
      .single()

    const turnsUsed = usageLog?.turns_used ?? 0
    const FREE_LIMIT = 3

    if (userData.plan === 'free' && turnsUsed >= FREE_LIMIT) {
      return new Response(JSON.stringify({ error: 'LIMIT_EXCEEDED' }), {
        status: 429,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // ── 会話履歴取得（直近10往復）──
    let conversationDate = today
    let messages: Array<{ role: string; content: string }> = []

    if (conversationId) {
      const { data: conv } = await supabase
        .from('conversations')
        .select('messages, date')
        .eq('id', conversationId)
        .single()

      if (conv) {
        messages = (conv.messages as Array<{ role: string; content: string }>).slice(-20)
        conversationDate = conv.date
      }
    } else {
      // 当日のセッションを取得 or 新規作成
      const { data: existingConv } = await supabase
        .from('conversations')
        .select('id, messages')
        .eq('user_id', user.id)
        .eq('character_id', CHARACTER_ID)
        .eq('date', today)
        .single()

      messages = existingConv
        ? (existingConv.messages as Array<{ role: string; content: string }>).slice(-20)
        : []
    }

    // ── シナリオ取得 ──
    const { scenario, openingMessage } = await getTodayScenario(
      supabase,
      user.id,
      CHARACTER_ID,
      userData.current_level
    )

    // ── Gemini System Prompt 構築 ──
    const timeOfDay = getTimeOfDay()
    const systemPrompt = buildSystemPrompt({
      characterName: 'ジウ (지우)',
      characterPersonality: '明るくて天然。K-drama大好き。素直に感情を出せる。照れるとよく「ㅠㅠ」を使う。',
      userCallName: userData.user_call_name ?? 'オッパ',
      userLevel: userData.current_level,
      timeOfDay,
      contextNote: scenario?.context_note,
      nextMessageHint: scenario?.next_message_hint,
    })

    // ── Gemini API 呼び出し（3回リトライ）──
    const genAI = new GoogleGenerativeAI(geminiKey)
    const model = genAI.getGenerativeModel({
      model: 'gemini-1.5-flash',
      systemInstruction: systemPrompt,
    })

    // 会話履歴をGemini形式に変換
    const history = messages.map((m) => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }],
    }))

    let generatedReply: GeneratedReply | null = null
    let lastError: Error | null = null

    for (let attempt = 0; attempt < 3; attempt++) {
      try {
        const chat = model.startChat({ history })
        const result = await chat.sendMessage(userText)
        const rawText = result.response.text().trim()

        // JSONブロックを抽出
        const jsonMatch = rawText.match(/\{[\s\S]*\}/)
        if (!jsonMatch) throw new Error('Invalid JSON response')

        generatedReply = JSON.parse(jsonMatch[0]) as GeneratedReply
        break
      } catch (e) {
        lastError = e as Error
        if (attempt < 2) {
          await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, attempt))) // exponential backoff
        }
      }
    }

    // フォールバック
    if (!generatedReply) {
      console.error('Gemini error after retries:', lastError)
      generatedReply = {
        reply: '잠깐만... 다시 말해줄 수 있어? ㅠ',
        why: 'AIが一時的に応答できませんでした',
        slang: [],
        nextMessage: openingMessage || '어떻게 됐어? ㅎ',
      }
    }

    // ── DB 保存 ──
    // 会話履歴に追記
    const newMessages = [
      ...messages,
      { role: 'user', content: userText, timestamp: new Date().toISOString() },
      { role: 'assistant', content: generatedReply.reply, timestamp: new Date().toISOString() },
    ]

    // 当日セッションを upsert
    await supabase.from('conversations').upsert(
      {
        user_id: user.id,
        character_id: CHARACTER_ID,
        date: today,
        messages: newMessages,
        turns_used: turnsUsed + 1,
      },
      { onConflict: 'user_id,character_id,date' }
    )

    // usage_logs を upsert
    await supabase.from('usage_logs').upsert(
      {
        user_id: user.id,
        date: today,
        turns_used: turnsUsed + 1,
        character_id: CHARACTER_ID,
      },
      { onConflict: 'user_id,date' }
    )

    // 語彙保存
    await saveVocabulary(
      supabase,
      user.id,
      generatedReply.slang ?? [],
      scenario?.vocab_targets ?? [],
      'ko'
    )

    // 初回ターンの場合、シナリオ進捗を翌日へ進める
    if (turnsUsed === 0 && scenario) {
      const { data: prog } = await supabase
        .from('user_scenario_progress')
        .select('current_season, current_week, current_day')
        .eq('user_id', user.id)
        .eq('character_id', CHARACTER_ID)
        .single()

      if (prog) {
        await advanceProgress(supabase, user.id, CHARACTER_ID, prog.current_season, prog.current_week, prog.current_day)
      }
    }

    // ── レスポンス ──
    return new Response(
      JSON.stringify({
        ...generatedReply,
        openingMessage,
        scenarioDay: scenario ? `S${scenario.arc_season}W${scenario.arc_week}D${scenario.arc_day}` : null,
        turnsRemaining: userData.plan === 'free' ? FREE_LIMIT - (turnsUsed + 1) : -1,
        streakUpdated: userData.last_active !== today,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(JSON.stringify({ error: 'INTERNAL_ERROR' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

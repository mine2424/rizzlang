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
  phaseTransition?: string   // 'reconciliation' | null
  phaseComplete?: boolean    // reconciliation 完了時 true
}

type TimeOfDay = 'morning' | 'afternoon' | 'evening' | 'night'
type TensionPhase = 'friction' | 'reconciliation' | 'resolved' | null

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

interface Character {
  id: string
  name: string
  language: string   // 'ko' | 'en' | 'tr' | 'vi' | 'ar'
  persona: Record<string, unknown>
}

interface CharacterLevelGuide {
  guide_text: string
  slang_examples: SlangItem[]
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

/** 言語コードを人間が読める言語名に変換 */
function languageCodeToName(lang: string): string {
  const map: Record<string, string> = {
    ko: 'Korean (한국어)',
    en: 'English',
    tr: 'Turkish (Türkçe)',
    vi: 'Vietnamese (Tiếng Việt)',
    ar: 'Arabic (العربية)',
  }
  return map[lang] ?? lang
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
// System Prompt 生成（多言語対応）
// ============================================================
function buildSystemPrompt(params: {
  characterName: string
  characterPersonality: string
  targetLanguage: string      // 'ko' | 'en' | 'tr' | 'vi' | 'ar'
  userCallName: string
  userLevel: number
  timeOfDay: TimeOfDay
  levelGuide: string          // DB から取得した難易度ガイド
  contextNote?: string
  nextMessageHint?: string
  tensionPhase?: TensionPhase
}): string {
  const targetLangName = languageCodeToName(params.targetLanguage)

  // 言語別特別ルール
  const langSpecificRules = params.targetLanguage === 'ar'
    ? '- Arabic は LTR (left-to-right) で出力すること。RTL マークは使わない。'
    : ''

  // Tension フェーズ別の特別指示
  let tensionInstruction = ''
  if (params.tensionPhase === 'friction') {
    tensionInstruction = `
【⚠️ TENSION シーン - 摩擦フェーズ】
今、${params.characterName}とユーザーの間に小さなすれ違いが起きています。
- ${params.characterName}は少し拗ねている・傷ついている状態です
- 返答は短め、やや素っ気なく、でも突き放しすぎない
- ユーザーが謝ったり優しい言葉をかければ柔らかくなる余地を残す
- nextMessage はユーザーが仲直りしたくなるような少し寂しそうな一言`
  } else if (params.tensionPhase === 'reconciliation') {
    tensionInstruction = `
【💕 TENSION シーン - 仲直りフェーズ】
ユーザーが優しい言葉をかけてくれたので、${params.characterName}は心を開き始めています。
- 最初は少し照れくさそうだが、だんだん甘えてくる
- 和解の表現を自然に使う
- 普段より少し甘えた口調に戻す
- nextMessage は仲直り後の温かい一言・関係が深まった感を出す`
  }

  return `You are ${params.characterName}. You are having a romantic chat conversation in ${targetLangName} with the user, who calls you by your character name. The user's display name for you is "${params.userCallName}".

【性格・口調】
${params.characterPersonality}

【学習言語: ${targetLangName}】
あなたの返信は必ず ${targetLangName} で書くこと。

【難易度レベル: ${params.userLevel}】
${params.levelGuide}

【時間帯: ${params.timeOfDay}】
返答の口調を時間帯に合わせる（朝=眠そう/元気、夜=少し甘え気味）

${params.contextNote ? `【シーン背景】\n${params.contextNote}\n` : ''}
${params.nextMessageHint ? `【${params.characterName}の次のひと言ヒント（参考）】\n"${params.nextMessageHint}"\n` : ''}
${tensionInstruction}

【絶対ルール】
- 前の会話の文脈を必ず引き継ぐ
- 1メッセージ最大3文
- "${params.userCallName}"への呼びかけを自然に使う
- reply フィールドは必ず ${targetLangName} で書く
${langSpecificRules}
- 返答は必ず以下のJSON形式のみ（余分なテキスト禁止）:

{"reply":"（${targetLangName} の自然な返答）","why":"（日本語で30文字以内の解説・この表現のポイント）","slang":[{"word":"単語","meaning":"意味"}],"nextMessage":"（${params.characterName}の次のひと言・会話を続けたくなる一文）"}`
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
    const {
      userText,
      conversationId,
      characterId,
      editCount = 0,    // Flutter側で追跡した編集回数
      retryCount = 0,   // Flutter側で追跡したリトライ回数
    } = await req.json()
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

    // ── キャラクター情報取得（動的）──
    const { data: characterData, error: charErr } = await supabase
      .from('characters')
      .select('id, name, language, persona')
      .eq('id', CHARACTER_ID)
      .single<Character>()

    if (charErr || !characterData) {
      return new Response(JSON.stringify({ error: 'CHARACTER_NOT_FOUND' }), {
        status: 404,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // ── キャラクターレベルガイド取得 ──
    const { data: levelGuideData } = await supabase
      .from('character_level_guides')
      .select('guide_text, slang_examples')
      .eq('character_id', CHARACTER_ID)
      .eq('level', userData.current_level)
      .single<CharacterLevelGuide>()

    // DB にガイドがなければフォールバック（지우の旧ガイド）
    const levelGuideText = levelGuideData?.guide_text ?? (() => {
      const fallbackGuides: Record<number, string> = {
        1: '初級（短文・基本挨拶・感情語のみ。文は1〜2文。）',
        2: 'スラング入門（日常的なスラングを自然に使う。2〜3文）',
        3: '複合表現（慣用表現・感情と意図を豊かに表現。2〜3文）',
        4: 'ネイティブ感性（慣用句・詩的表現を使う。自然な口語。2〜3文）',
      }
      return fallbackGuides[userData.current_level] ?? fallbackGuides[2]
    })()

    // persona から情報を取り出す
    const persona = characterData.persona as Record<string, string>
    const characterPersonality = persona.speechStyle ?? persona.personality ?? ''

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

    // ── Tension フェーズ管理 ──
    let currentTensionPhase: TensionPhase = null
    let phaseTransition: string | null = null
    let phaseComplete = false

    if (scenario?.scene_type === 'tension') {
      const { data: prog } = await supabase
        .from('user_scenario_progress')
        .select('tension_phase, tension_turn_count')
        .eq('user_id', user.id)
        .eq('character_id', CHARACTER_ID)
        .single()

      const storedPhase = (prog?.tension_phase ?? null) as TensionPhase
      const turnCount = (prog?.tension_turn_count ?? 0) as number

      if (storedPhase === null || storedPhase === 'friction') {
        if (storedPhase === null) {
          await supabase
            .from('user_scenario_progress')
            .update({ tension_phase: 'friction', tension_turn_count: 1 })
            .eq('user_id', user.id)
            .eq('character_id', CHARACTER_ID)
          currentTensionPhase = 'friction'
        } else if (turnCount >= 2) {
          await supabase
            .from('user_scenario_progress')
            .update({ tension_phase: 'reconciliation', tension_turn_count: 0 })
            .eq('user_id', user.id)
            .eq('character_id', CHARACTER_ID)
          currentTensionPhase = 'reconciliation'
          phaseTransition = 'reconciliation'
        } else {
          await supabase
            .from('user_scenario_progress')
            .update({ tension_turn_count: turnCount + 1 })
            .eq('user_id', user.id)
            .eq('character_id', CHARACTER_ID)
          currentTensionPhase = 'friction'
        }
      } else if (storedPhase === 'reconciliation') {
        await supabase
          .from('user_scenario_progress')
          .update({ tension_phase: 'resolved', tension_turn_count: 0 })
          .eq('user_id', user.id)
          .eq('character_id', CHARACTER_ID)
        currentTensionPhase = 'reconciliation'
        phaseComplete = true
      } else {
        currentTensionPhase = null
      }
    }

    // ── Gemini System Prompt 構築（多言語対応）──
    const timeOfDay = getTimeOfDay()
    const systemPrompt = buildSystemPrompt({
      characterName: characterData.name,
      characterPersonality,
      targetLanguage: characterData.language,
      userCallName: userData.user_call_name ?? 'オッパ',
      userLevel: userData.current_level,
      timeOfDay,
      levelGuide: levelGuideText,
      contextNote: scenario?.context_note,
      nextMessageHint: scenario?.next_message_hint,
      tensionPhase: currentTensionPhase,
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
        reply: '...',
        why: 'AIが一時的に応答できませんでした',
        slang: [],
        nextMessage: openingMessage || '...',
      }
    }

    // ── DB 保存 ──
    const newMessages = [
      ...messages,
      { role: 'user', content: userText, timestamp: new Date().toISOString() },
      { role: 'assistant', content: generatedReply.reply, timestamp: new Date().toISOString() },
    ]

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

    const { data: existingLog } = await supabase
      .from('usage_logs')
      .select('edit_count, retry_count')
      .eq('user_id', user.id)
      .eq('date', today)
      .maybeSingle()

    await supabase.from('usage_logs').upsert(
      {
        user_id: user.id,
        date: today,
        turns_used: turnsUsed + 1,
        character_id: CHARACTER_ID,
        edit_count: (existingLog?.edit_count ?? 0) + editCount,
        retry_count: (existingLog?.retry_count ?? 0) + retryCount,
      },
      { onConflict: 'user_id,date' }
    )

    // 語彙保存（キャラクターの言語コードを使用）
    await saveVocabulary(
      supabase,
      user.id,
      generatedReply.slang ?? [],
      scenario?.vocab_targets ?? [],
      characterData.language
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
        language: characterData.language,   // クライアントがキャラクターを識別できるよう
        openingMessage,
        scenarioDay: scenario ? `S${scenario.arc_season}W${scenario.arc_week}D${scenario.arc_day}` : null,
        turnsRemaining: userData.plan === 'free' ? FREE_LIMIT - (turnsUsed + 1) : -1,
        streakUpdated: userData.last_active !== today,
        // Tension フェーズ情報
        tensionPhase: currentTensionPhase,
        phaseTransition,
        phaseComplete,
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

# Design — AI 関係値メモリ（Relationship Memory）

## Overview

週次バッチ処理で会話サマリーを生成 → `relationship_memories` テーブルに保存
→ `generate-reply` 呼び出し時にサマリーをシステムプロンプトに注入する2ステップ設計。

---

## Architecture

```
[Supabase Cron — 毎週月曜 0:00 JST]
  └── memory-generator Edge Function
        ├── 各ユーザーの過去7日間の conversations を取得
        ├── Gemini でサマリー生成（100文字以内・キャラ視点）
        └── relationship_memories テーブルに保存

[generate-reply Edge Function]
  ├── relationship_memories から直近2週分を取得
  ├── buildSystemPrompt() にメモリを注入
  └── Gemini が0〜30%の確率で過去を言及
```

---

## DB スキーマ

```sql
CREATE TABLE relationship_memories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  character_id UUID REFERENCES characters(id),
  week_number INT NOT NULL,          -- 1, 2, 3, ...
  week_start  DATE NOT NULL,
  week_end    DATE NOT NULL,
  summary     TEXT NOT NULL,         -- 100文字以内・キャラ視点
  emotional_weight INT DEFAULT 5,    -- 1〜10（Tension/仲直りは高め）
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- RLS
ALTER TABLE relationship_memories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users own memories" ON relationship_memories
  FOR ALL USING (auth.uid() = user_id);

-- Index
CREATE INDEX ON relationship_memories(user_id, character_id, week_number DESC);
```

---

## Edge Function: `memory-generator`

**ファイル:** `supabase/functions/memory-generator/index.ts`

```typescript
// Cron payload: { trigger: 'weekly' }

// 1. アクティブユーザー一覧を取得（過去7日に会話があったユーザー）
const activeUsers = await supabase
  .from('conversations')
  .select('user_id, character_id')
  .gte('created_at', oneWeekAgo)
  .then(dedup)

// 2. ユーザーごとに会話を取得してサマリー生成
for (const { userId, characterId } of activeUsers) {
  const messages = await getWeekConversations(userId, characterId)

  const prompt = `
    以下は${characterName}とユーザーの過去1週間の会話です。
    ${characterName}の視点で、感情的に重要な出来事を100文字以内で要約してください。
    緊張シーン・仲直りシーンを優先して言及してください。
    ユーザーへの愛情・不満・期待などの感情を含めてください。

    会話: ${messages}

    要約（JSON）: {"summary": "...", "emotional_weight": 7}
  `

  const { summary, emotional_weight } = await gemini.generate(prompt)

  await supabase.from('relationship_memories').insert({
    user_id: userId,
    character_id: characterId,
    week_number: currentWeek,
    week_start: weekStart,
    week_end: weekEnd,
    summary,
    emotional_weight,
  })
}
```

---

## generate-reply への記憶注入

**ファイル:** `supabase/functions/generate-reply/index.ts`

```typescript
// 直近2週分の記憶を取得
const memories = await supabase
  .from('relationship_memories')
  .select('summary, week_number, emotional_weight')
  .eq('user_id', userId)
  .eq('character_id', characterId)
  .order('week_number', { ascending: false })
  .limit(2)

// System Prompt に追加するメモリブロック
const memoryBlock = memories.length > 0
  ? `
## あなたの記憶（過去の会話）
${memories.map(m => `[第${m.week_number}週]: ${m.summary}`).join('\n')}

記憶の使い方:
- 30%の確率でさりげなく過去を言及してください（毎回は不自然）
- emotional_weight が 7以上の記憶を優先
- 「そういえば先週さ...」「あの時のこと、まだ覚えてるよ」などの自然な形で
`
  : ''
```

---

## Flutter — 設定画面「キャラの記憶」

**新規ウィジェット:** `lib/features/settings/relationship_memories_screen.dart`

```
┌────────────────────────────────┐
│ 지우の記憶                       │
├────────────────────────────────┤
│ 第4週 (2/17〜2/23)              │
│ 先週、오빠が返信遅くて少し怒った    │
│ けど仲直りできてよかった。嬉しかっ  │
│ た！                            │  [削除]
├────────────────────────────────┤
│ 第3週 (2/10〜2/16)              │
│ 今週は毎日連絡してくれて幸せだった。 │
│ カフェの話が特に楽しかった。         │  [削除]
└────────────────────────────────┘
```

---

## 非機能要件

- バッチ処理時間: 全アクティブユーザー分で < 5分（100ユーザーあたり）
- サマリーコスト: 約 800 tokens / ユーザー / 週 = ¥0.00012 / 週
- プライバシー: RLS で自分の記憶のみアクセス可能

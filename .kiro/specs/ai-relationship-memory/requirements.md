# Requirements — AI 関係値メモリ（Relationship Memory）

## Introduction

キャラクターが「先週起きたこと」を自然に会話に持ち込む機能。
「先週喧嘩したことまだ覚えてるよ」「あのカフェの話、覚えてる?」のような発言が、
リアルな恋愛感とリテンションを劇的に高める。

**優先度:** 🟡 中高（Week 2以降で効果が最大化）

---

## Requirements

### Requirement 1: 週次会話サマリーの自動生成

**Objective:** システムが過去1週間の会話を自動的に要約し、翌週の会話に活用できること。

#### Acceptance Criteria

1. When 毎週月曜 0:00 JST になった場合, RizzLang shall Supabase Cron で `memory-generator` Edge Function を起動する
2. When `memory-generator` が起動した場合, RizzLang shall 各ユーザーの過去7日間の `conversations` レコードを取得し、Gemini で100文字以内のサマリーを生成する
3. The RizzLang shall 生成したサマリーを `relationship_memories` テーブルに保存する（week_number / character_id / summary）
4. The RizzLang shall サマリーは「キャラクターの視点」で書く（例:「先週、오빠が返信遅くて少し怒ったけど仲直りした」）

---

### Requirement 2: 記憶のチャット注入

**Objective:** 現在の会話にキャラクターが自然に過去の記憶を持ち込むこと。

#### Acceptance Criteria

1. When `generate-reply` が呼ばれた場合, RizzLang shall 直近2週分の `relationship_memories` を取得してシステムプロンプトに注入する
2. When 記憶が注入されている場合, RizzLang shall キャラクターが0〜30%の確率で過去の出来事に言及するよう System Prompt に指示する（毎回言及は不自然なため）
3. The RizzLang shall 言及する記憶は感情的に印象的だったものを優先する（Tension シーンや仲直りシーン）

---

### Requirement 3: 記憶の手動確認

**Objective:** ユーザーが「キャラクターの記憶」を確認できること（透明性）。

#### Acceptance Criteria

1. When ユーザーが設定画面の「지우の記憶」セクションにアクセスした場合, RizzLang shall 直近4週分の関係メモリサマリーを一覧表示する
2. The RizzLang shall 各サマリーに「第N週」のラベルと日付範囲を表示する
3. The RizzLang shall ユーザーが記憶を削除できる機能を提供する（プライバシー配慮）

---

## Out of Scope

- 個別メッセージのセマンティック検索（Phase 4 — RAG）
- 記憶の編集機能（ユーザーが記憶を書き換える）
- 他ユーザー間での記憶の共有

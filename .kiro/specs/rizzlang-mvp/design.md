# Design Document — RizzLang MVP

## Overview

RizzLang はAIが動かす疑似恋愛シナリオを通じて、日本語話者が韓国語を自然な文脈で習得するWebアプリである。ユーザーが日本語で「言いたいこと」を入力すると、Gemini 1.5 Flash がキャラクタープロンプト・会話履歴・難易度レベルを組み合わせて、自然な韓国語返信・解説・スラング情報・次の地우メッセージを1回のAPI呼び出しで生成する。

**ユーザー：** 韓国語を恋愛的な文脈で学びたい25-35歳の日本人（主にK-pop・K-dramaファン）

**影響：** 既存の語学学習アプリ（Duolingo等）と完全に異なるカテゴリを作る。感情的なリテンション構造により、DAU 40%・7日リテンション 50% を目指す。

### Goals
- AI生成（返信+解説）を3秒以内（P95）で返す
- 1日の利用コスト（AIトークン）を 0.015円/往復 以下に抑える（Gemini 1.5 Flash）
- Season 1（30日分）シナリオで学習継続率を担保する
- Stripe連携でフリーミアム収益化を実現する

### Non-Goals
- ネイティブアプリ（iOS/Android）— v2スコープ
- 英語・中国語等の他言語 — v1.1スコープ
- リアルタイム音声通話機能
- ユーザー間のソーシャル機能

---

## Architecture

### Architecture Pattern & Boundary Map

```mermaid
graph TB
    subgraph Client["クライアント (Next.js App Router)"]
        UI[Chat UI / Onboarding]
        SW[Service Worker\nWeb Push]
    end

    subgraph Server["サーバー (Supabase Edge Functions (Deno/TypeScript))"]
        SA[Server Actions\nchat.generate]
        WH[Webhook Handler\nStripe]
        PUSH[Push Scheduler\nCron Job]
    end

    subgraph External["外部サービス"]
        GEMINI[Gemini 1.5 Flash API]
        STRIPE[Stripe API]
        PUSH_SVC[Web Push Service]
    end

    subgraph Infra["インフラ (Supabase)"]
        AUTH[Auth\nGoogle / Apple]
        DB[(PostgreSQL\nRLS有効)]
        EDGE[Edge Functions]
    end

    UI -->|Server Action| SA
    SA -->|プロンプト + 履歴| GEMINI
    GEMINI -->|JSON| SA
    SA -->|語彙・履歴保存| DB
    WH -->|plan更新| DB
    STRIPE -->|webhook| WH
    AUTH -->|JWT| UI
    UI -->|認証| AUTH
    PUSH -->|通知送信| PUSH_SVC
    PUSH_SVC -->|Web Push| SW
```

**選択パターン：** Next.js App Router + Server Actions（BFF統合型）
- APIキー類をサーバーサイドに完全隔離
- Server ActionsによりREST APIエンドポイント数を最小化
- Supabase RLSでデータアクセス制御を宣言的に管理

### Technology Stack

| Layer | 選択 / Version | 役割 | 備考 |
|-------|---------------|------|------|
| Frontend | Flutter 3.19 (Dart) + Riverpod | SPA + SSR + Server Actions | Vercelへのデプロイ最適化 |
| Styling | Flutter Material 3 + flutter_animate | UIコンポーネント | Framer Motionでアニメーション |
| Auth | Supabase Auth (Google / Apple OAuth) | 認証 | JWTをServer Actionsで検証 |
| DB | Supabase PostgreSQL | 全永続データ | RLS必須 |
| AI | Google Gemini 1.5 Flash | チャット生成 | 無料枠: 1,500 req/day, 1M tokens/day |
| 決済 | Stripe Subscriptions | Pro課金 | Webhookでplan同期 |
| 通知 | Web Push API + Supabase Edge Functions | デイリーリマインダー | PWAに移行容易 |
| Deploy | App Store / Google Play + Supabase | ホスティング | GitHub連携でCI/CD |

---

## System Flows

### チャット生成フロー（コアフロー）

```mermaid
sequenceDiagram
    actor User
    participant UI as Chat UI
    participant SA as Server Action
    participant DB as Supabase DB
    participant AI as Gemini 1.5 Flash

    User->>UI: 日本語テキスト入力 + 「変換」
    UI->>SA: generateReply(userText, conversationId)
    SA->>DB: 認証検証 + 使用量チェック（free: 3往復/日）
    alt 上限超過
        SA-->>UI: {error: "LIMIT_EXCEEDED"}
        UI-->>User: ペイウォール表示
    end
    SA->>DB: 会話履歴取得（直近10往復）
    SA->>DB: ユーザーレベル・シナリオ取得
    SA->>AI: generateContent(systemPrompt + history + userText)
    AI-->>SA: {reply, why, slang[], nextMessage}
    SA->>DB: 会話履歴保存 + 語彙upsert + 使用量+1
    SA-->>UI: GeneratedReply オブジェクト
    UI-->>User: 返信・解説・スラングを表示
```

### シナリオ選択フロー

```mermaid
flowchart TD
    A[ユーザーアクセス] --> B{当日セッション存在？}
    B -- Yes --> C[既存チャット継続]
    B -- No --> D[user_scenario_progress取得]
    D --> E[scenario_templates検索\nseason + week + day + level]
    E --> F{時間帯判定}
    F -- morning --> G[opening_message.morning]
    F -- evening --> H[opening_message.evening]
    F -- night --> I[opening_message.night]
    G & H & I --> J[地우のメッセージ表示]
    J --> K[progressを翌日に更新]
```

### Stripe課金フロー

```mermaid
sequenceDiagram
    actor User
    participant UI
    participant SA as Server Action
    participant Stripe
    participant DB

    User->>UI: 「Proにアップグレード」クリック
    UI->>SA: createCheckoutSession(userId)
    SA->>Stripe: sessions.create(priceId, metadata.userId)
    Stripe-->>SA: {url: checkoutUrl}
    SA-->>UI: redirect to checkoutUrl
    User->>Stripe: 決済完了
    Stripe->>SA: webhook: checkout.session.completed
    SA->>DB: users.plan = 'pro'
    SA-->>User: 成功画面（リダイレクト）
```

---

## Requirements Traceability

| 要件 | 概要 | コンポーネント | インターフェース |
|------|------|---------------|----------------|
| 1.1-1.5 | 認証・RLS | AuthService, Supabase RLS | OAuth Flow |
| 2.1-2.5 | オンボーディング | OnboardingFlow, DemoChat | Server Action: generateDemoReply |
| 3.1-3.7 | AIチャット生成 | ChatGenerationService | Server Action: generateReply |
| 4.1-4.6 | シナリオシステム | ScenarioService | getScenario(), advanceProgress() |
| 5.1-5.5 | 難易度変動 | DifficultyEngine | calcLevel(), updateLevel() |
| 6.1-6.5 | 語彙帳 | VocabularyService | upsertVocab(), getVocabList() |
| 7.1-7.5 | ストリーク | StreakService | updateStreak(), checkMilestone() |
| 8.1-8.6 | 課金 | StripeService | createCheckoutSession(), handleWebhook() |
| 9.1-9.5 | Web Push通知 | PushNotificationService | subscribe(), sendDailyReminder() |
| 10.1-10.5 | セキュリティ | 全コンポーネント | RLS, Rate Limit |

---

## Components and Interfaces

### AI Layer

#### ChatGenerationService

| Field | Detail |
|-------|--------|
| Intent | Gemini APIへのリクエスト構築・送信・レスポンスパース |
| Requirements | 3.1, 3.2, 3.3, 3.4, 3.5, 3.6 |

**Responsibilities & Constraints**
- System Prompt にキャラクター定義・難易度・ユーザー呼称を組み込む
- 直近10往復の会話履歴をコンテキストとして付与
- レスポンスは必ず `{reply, why, slang, nextMessage}` のJSON形式で返す
- APIキーはサーバーサイド環境変数のみ（クライアント露出禁止）

**Contracts:** Service [x] / API [x]

##### Service Interface
```typescript
interface GeneratedReply {
  reply: string;           // 自然な韓国語返信
  why: string;             // 理由解説（30文字以内・日本語）
  slang: SlangItem[];      // スラング解説リスト
  nextMessage: string;     // 地우の次のセリフ
}

interface SlangItem {
  word: string;
  meaning: string;
}

interface ChatGenerationService {
  generateReply(params: {
    userText: string;
    conversationHistory: Message[];
    character: Character;
    userLevel: 1 | 2 | 3 | 4;
    userName: string;
  }): Promise<Result<GeneratedReply, AIError>>;

  generateDemoReply(userText: string): Promise<Result<GeneratedReply, AIError>>;
}
```

**System Prompt テンプレート:**
```
あなたは{characterName}、{characterProfile}です。
現在、{userName}（{userCallName}）と付き合っています。

難易度レベル: {level}（1=初級短文 / 2=スラング入門 / 3=複合表現 / 4=ネイティブ感性）
時間帯: {timeOfDay}

性格と口調:
{characterPersonality}

会話ルール:
- 前の会話の文脈を必ず引き継ぐ
- 1メッセージ2〜3文が最大
- 難易度レベルに応じた語彙・文型を使用

レスポンスは必ず以下のJSON形式で返す:
{"reply":"...","why":"...（30文字以内）","slang":[{"word":"...","meaning":"..."}],"nextMessage":"..."}
```

---

#### ScenarioService

| Field | Detail |
|-------|--------|
| Intent | シナリオDB管理・今日のシーン選択・進捗更新 |
| Requirements | 4.1, 4.2, 4.3, 4.4, 4.5, 4.6 |

##### Service Interface
```typescript
interface Scenario {
  id: string;
  arcSeason: number;
  arcWeek: number;
  arcDay: number;
  sceneType: 'daily' | 'emotional' | 'discovery' | 'event' | 'tension';
  openingMessage: Record<'lv1' | 'lv2' | 'lv3' | 'lv4', Record<TimeOfDay, string>>;
  vocabTargets: VocabTarget[];
  nextMessageHint: string;
}

type TimeOfDay = 'morning' | 'afternoon' | 'evening' | 'night';

interface ScenarioService {
  getTodayScenario(userId: string, characterId: string): Promise<Scenario>;
  advanceProgress(userId: string, characterId: string): Promise<void>;
  getProgress(userId: string, characterId: string): Promise<ScenarioProgress>;
}
```

---

#### DifficultyEngine

| Field | Detail |
|-------|--------|
| Intent | 7日間の学習データからレベルを自動計算・更新 |
| Requirements | 5.1, 5.2, 5.3, 5.4, 5.5 |

##### Service Interface
```typescript
interface DifficultyMetrics {
  noEditRate: number;    // 編集なし送信率（0-1）
  avgRetries: number;    // 平均リトライ数
}

interface DifficultyEngine {
  calcNextLevel(current: 1|2|3|4, metrics: DifficultyMetrics): 1|2|3|4;
  updateLevelIfNeeded(userId: string): Promise<void>;  // 7日ごとに実行
}

// ロジック
// noEditRate > 0.8 && avgRetries < 0.5 → level + 1
// noEditRate < 0.4 || avgRetries > 2   → level - 1
// otherwise                             → level 維持
```

---

### Data Layer

#### VocabularyService

| Field | Detail |
|-------|--------|
| Intent | 語彙の自動保存・SRSスケジュール計算・復習リスト提供 |
| Requirements | 6.1, 6.2, 6.3, 6.4, 6.5 |

##### Service Interface
```typescript
interface VocabEntry {
  id: string;
  userId: string;
  word: string;
  meaning: string;
  example?: string;
  language: string;
  learnedAt: Date;
  nextReview: Date;
  reviewCount: number;
  easeFactor: number;  // SM-2アルゴリズム
}

interface VocabularyService {
  upsertFromReply(userId: string, slang: SlangItem[], language: string): Promise<void>;
  getVocabList(userId: string, language: string): Promise<VocabEntry[]>;
  getDueForReview(userId: string): Promise<VocabEntry[]>;
  recordReview(vocabId: string, quality: 0|1|2|3|4|5): Promise<void>;
}
```

**SRSスケジュール（SM-2準拠）:**
```
reviewCount=0 → nextReview = +1日
reviewCount=1 → nextReview = +3日
reviewCount=2 → nextReview = +7日
reviewCount>=3 → nextReview = 前回間隔 × easeFactor
```

---

#### StreakService

| Field | Detail |
|-------|--------|
| Intent | 連続ログイン管理・マイルストーン検出 |
| Requirements | 7.1, 7.2, 7.3, 7.4 |

##### Service Interface
```typescript
interface StreakService {
  updateStreak(userId: string): Promise<{ streak: number; isNew: boolean }>;
  checkMilestone(streak: number): 7 | 30 | 100 | null;
}
```

---

### Billing Layer

#### StripeService

| Field | Detail |
|-------|--------|
| Intent | Checkout Sessionの生成・Webhook処理・plan同期 |
| Requirements | 8.3, 8.4, 8.5 |

##### API Contract

| Method | Endpoint | Request | Response | Errors |
|--------|----------|---------|----------|--------|
| POST | /api/stripe/checkout | `{userId}` | `{url: string}` | 400, 500 |
| POST | /api/stripe/webhook | Stripe Event | `{received: true}` | 400 |

##### Service Interface
```typescript
interface StripeService {
  createCheckoutSession(userId: string): Promise<{ url: string }>;
  handleWebhook(event: Stripe.Event): Promise<void>;
}
// handleWebhookが処理するイベント:
// - checkout.session.completed → plan = 'pro'
// - customer.subscription.deleted → plan = 'free'
```

---

## Data Models

### Physical Data Model

```sql
-- ユーザー
CREATE TABLE users (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email           text UNIQUE NOT NULL,
  plan            text NOT NULL DEFAULT 'free' CHECK (plan IN ('free', 'pro')),
  stripe_customer_id text,
  current_level   int NOT NULL DEFAULT 1 CHECK (current_level BETWEEN 1 AND 4),
  user_call_name  text NOT NULL DEFAULT 'オッパ',  -- 地우からの呼び方
  streak          int NOT NULL DEFAULT 0,
  last_active     date,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- キャラクター（シードデータ）
CREATE TABLE characters (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,        -- 'ジウ'
  language    text NOT NULL,        -- 'ko'
  persona     jsonb NOT NULL,       -- systemPrompt含む全人格設定
  avatar_url  text
);

-- 会話セッション（1日1レコード）
CREATE TABLE conversations (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  character_id  uuid NOT NULL REFERENCES characters(id),
  date          date NOT NULL DEFAULT CURRENT_DATE,
  messages      jsonb NOT NULL DEFAULT '[]',  -- Message[]
  turns_used    int NOT NULL DEFAULT 0,
  UNIQUE(user_id, character_id, date)
);

-- シナリオテンプレート
CREATE TABLE scenario_templates (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  character_id    uuid NOT NULL REFERENCES characters(id),
  arc_season      int NOT NULL,
  arc_week        int NOT NULL,
  arc_day         int NOT NULL,
  scene_type      text NOT NULL CHECK (scene_type IN ('daily','emotional','discovery','event','tension')),
  opening_message jsonb NOT NULL,  -- {lv1: {morning:.., evening:..}, lv2: ...}
  vocab_targets   jsonb NOT NULL DEFAULT '[]',
  next_message_hint text,
  UNIQUE(character_id, arc_season, arc_week, arc_day)
);

-- シナリオ進捗
CREATE TABLE user_scenario_progress (
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  character_id  uuid NOT NULL REFERENCES characters(id),
  current_season int NOT NULL DEFAULT 1,
  current_week   int NOT NULL DEFAULT 1,
  current_day    int NOT NULL DEFAULT 1,
  last_played_at timestamptz,
  PRIMARY KEY (user_id, character_id)
);

-- 語彙帳
CREATE TABLE vocabulary (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word          text NOT NULL,
  meaning       text NOT NULL,
  example       text,
  language      text NOT NULL,
  learned_at    timestamptz NOT NULL DEFAULT now(),
  next_review   timestamptz NOT NULL DEFAULT now() + interval '1 day',
  review_count  int NOT NULL DEFAULT 0,
  ease_factor   float NOT NULL DEFAULT 2.5,
  UNIQUE(user_id, word, language)
);

-- 使用量ログ（難易度計算・制限管理用）
CREATE TABLE usage_logs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  date          date NOT NULL DEFAULT CURRENT_DATE,
  turns_used    int NOT NULL DEFAULT 0,
  edit_count    int NOT NULL DEFAULT 0,    -- 難易度計算用
  retry_count   int NOT NULL DEFAULT 0,   -- 難易度計算用
  character_id  uuid REFERENCES characters(id),
  UNIQUE(user_id, date)
);

-- Web Push サブスクリプション
CREATE TABLE push_subscriptions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subscription  jsonb NOT NULL,  -- PushSubscription オブジェクト
  enabled       boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- RLSポリシー（全テーブル共通）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage_logs ENABLE ROW LEVEL SECURITY;
-- 各テーブルに: USING (auth.uid() = user_id)
```

---

## Error Handling

### Error Strategy

| カテゴリ | 原因 | ハンドリング |
|---------|------|------------|
| AIエラー (5xx) | Gemini APIタイムアウト / レート制限 | 3回リトライ（exponential backoff）→ ユーザーへの日本語エラーメッセージ |
| 制限超過 (429) | 無料ユーザーの往復上限 | `LIMIT_EXCEEDED`を返しUI側でペイウォール表示 |
| 認証エラー (401) | JWTの期限切れ | Supabaseが自動リフレッシュ、失敗時はログインページへ |
| JSONパースエラー | Gemini の不正レスポンス | フォールバック: `{reply: "もう一度試してください", why: "", slang: [], nextMessage: "..."}` |
| Stripe Webhook重複 | 同一イベントの複数配信 | idempotency key（イベントID）でDB側で重複排除 |

### Monitoring
- Vercel Analytics でレスポンスタイム監視
- Supabase Dashboard でDB接続・クエリ監視
- Sentry（エラートラッキング、将来追加）

---

## Testing Strategy

### Unit Tests
- `DifficultyEngine.calcNextLevel()` — 境界値（0.8/0.4の閾値）
- `VocabularyService` SRSスケジュール計算（SM-2アルゴリズム）
- `ChatGenerationService` System Prompt構築ロジック
- `StreakService.updateStreak()` — 連続/断絶の両ケース

### Integration Tests
- `generateReply` Server Action — Gemini APIモックでE2Eフロー
- Stripe Webhook Handler — `checkout.session.completed` イベントでplan更新確認
- シナリオ選択 — season/week/day の境界条件（week=7→次のweek移行）

### E2E Tests（Playwright）
- オンボーディング → デモ → サインアップ → 初回チャット の完全フロー
- 無料上限到達 → ペイウォール表示 の確認
- Proアップグレード → チャット無制限化 の確認

---

## Security Considerations

- **APIキー管理：** GEMINI_API_KEY / STRIPE_SECRET_KEY / SUPABASE_SERVICE_ROLE_KEY は `.env.local` のみ。Vercel環境変数で設定。
- **RLS：** 全テーブルに `auth.uid() = user_id` ポリシー。Service Role Keyはサーバーサイドのみ使用。
- **レート制限：** ユーザーごとに1分10リクエスト上限。`usage_logs`の1分間ウィンドウで検証。
- **Webhook検証：** Stripe Signature を `stripe.webhooks.constructEvent()` で必ず検証。

## Performance & Scalability

- **AI応答：** Gemini 1.5 Flash の平均レスポンス 1-2秒。Server Actions のStreaming Responseで体感速度を改善（`streaming: true`）。
- **DB：** `conversations.date` + `user_id` に複合インデックス。`vocabulary.next_review` にインデックス（SRS復習クエリ最適化）。
- **スケール：** 無料枠（1,500 req/day）を超えた場合、Gemini 1.5 Flash 有料プランへ移行（$0.075/1M tokens）。

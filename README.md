# RizzLang 🌸

> AI外国人パートナーと毎日LINEして言語を身につけるモバイルアプリ

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green?logo=supabase)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🎯 コンセプト

韓国語・英語などを「感情が動く文脈」で学ぶ。教科書じゃなく、AIキャラとの疑似恋愛LINEで。

**Gotcha モーメント:**

```
지우: "오빠, 오늘 뭐 했어? 🥺 나 보고 싶었어~"

「仕事だったよ、俺も会いたかった」と日本語で入力するだけで

✦ 일 했어 😊 나도 보고 싶었어~ 빨리 보고 싶다
+ なぜその表現か・スラング解説まで即出力
```

---

## 🌍 対応言語 & キャラクター

| キャラクター | 言語 | プロフィール | プラン |
|---|---|---|---|
| 지우 (ジウ) 🇰🇷 | Korean | Seoul 25F · K-pop大好き | Free / Pro |
| Emma 🇺🇸 | English | NYU 23F · Gen Z American | Pro |
| Elif 🇹🇷 | Turkish | İstanbul 23F · 情熱的 | Pro |
| Linh 🇻🇳 | Vietnamese | Hà Nội 24F · 詩が好き | Pro |
| Yasmin 🇸🇦 | Arabic | Dubai 25F · Modern Arab | Pro |

---

## 🏗 技術スタック

| Layer | 技術 |
|---|---|
| Mobile | Flutter 3.19 (iOS / Android) |
| State | Riverpod 2.x + Freezed 3.0 |
| Navigation | GoRouter |
| Backend | Supabase (PostgreSQL + Edge Functions) |
| AI | Gemini 1.5 Flash (無料枠) |
| 課金 | RevenueCat (IAP) |
| Push | Firebase Cloud Messaging |
| TTS | flutter_tts (デバイス側・コスト0) |

---

## ✨ 主要機能

### 💬 AIチャット
- シナリオ連動の System Prompt (Season × Week × Day × 時間帯)
- 返信 + 解説(why) + スラング + 次のセリフを1回のAPI呼び出しで生成
- 難易度自動変動 (Level 1-4、週次 SM-2 ベース)
- Tension 2フェーズシステム (friction → reconciliation → 関係値+1)

### 📝 AI添削モード（Writing Check）
- 外国語で直接書いてAIがスコア付き添削
- エラー箇所・修正・理由を日本語で解説
- Free: 5回/日、Pro: 無制限

### 🧠 AI文法詳細解説
- ReplyPanelの「詳しく解説→」から文法を深掘り
- 文法名・パターン・例文3つ・レベルバッジ
- メモリキャッシュで同一フレーズは再API呼び出し不要

### 🔊 キャラクター TTS
- メッセージ長押し → ネイティブ発音再生
- デバイスOSのTTSエンジン使用（サーバーコスト0）
- 速度3段階設定 (ゆっくり/標準/速い)

### 🧩 AI関係値メモリ
- 週次で会話をAIサマリー化 → 翌週の会話に「記憶」として注入
- キャラが「先週のこと、覚えてるよ」と自然に言及

### 🎯 AI弱点フォーカス復習
- SM-2スケジュールの「今日の復習対象語彙」を会話に自然に埋め込む
- 会話で出てきた語彙を自動SM-2更新

### 📖 語彙帳 + SRS
- 会話から自動収集
- SM-2アルゴリズムで復習タイミングを最適化
- 「全て / 今日の復習 / 習得済み」3タブ

### 🔥 ストリーク & XP
- 7日連続表示 + XPプログレスバー
- マイルストーン通知 (7/30/100日)

### 🌸 発音ガイド
- メッセージ長押し → ローマ字読み + カタカナ近似
- 韓国語: Revised Romanization (RR方式)
- ベトナム語: 6声調ガイド付き

---

## 🗂 プロジェクト構造

```
rizzlang/
├── lib/
│   ├── core/
│   │   ├── models/          # Freezed モデル
│   │   ├── providers/       # Riverpod プロバイダー
│   │   ├── services/        # AI / TTS / RevenueCat / FCM
│   │   ├── theme/           # AppTheme (Emotional Dark)
│   │   └── utils/           # KoreanRomanizer / VietnameseToneGuide
│   ├── features/
│   │   ├── auth/            # Login / Onboarding (言語選択付き)
│   │   ├── chat/            # Chat / ReplyPanel / WritingCheck / GrammarExplain
│   │   ├── language/        # Language Select Screen
│   │   ├── paywall/         # Paywall Sheet
│   │   ├── settings/        # Settings / RelationshipMemories
│   │   └── vocabulary/      # Vocabulary + SRS
│   └── app.dart             # GoRouter 定義
├── supabase/
│   ├── functions/           # 9本のEdge Functions
│   ├── migrations/          # 8本のマイグレーション
│   └── seeds/               # 7本のシードファイル
├── test/                    # Unit / Widget / Golden / E2E
├── docs/
│   ├── DESIGN_RATIONALE.md  # 設計根拠ドキュメント
│   ├── TESTING.md           # テスト戦略
│   └── design-preview/      # UIプレビュー (HTML)
├── .kiro/specs/             # 7本の設計スペック
├── SETUP.md                 # 環境構築手順
└── Makefile
```

---

## 🚀 Supabase Edge Functions

| Function | 用途 |
|---|---|
| `generate-reply` | メインのAI返信生成（メモリ注入 + 弱点語彙注入） |
| `generate-demo-reply` | 未認証オンボーディング用デモ（5言語対応） |
| `check-writing` | AI添削（スコア + エラー + 語彙保存） |
| `explain-grammar` | 文法詳細解説（タイトル/パターン/例文3つ） |
| `memory-generator` | 週次会話サマリー生成（Cron: 月曜 15:00 UTC） |
| `difficulty-updater` | 難易度自動変動（Cron: 月曜 0:00 UTC） |
| `fcm-scheduler` | Push通知スケジューラ（Cron: 毎日 0:00 UTC） |
| `revenuecat-webhook` | 購入イベント処理 |

---

## 🗄 DB マイグレーション順序

```bash
supabase db push  # 以下を順番に適用

20260226_init.sql              # テーブル初期定義
20260226_user_trigger.sql      # 新規ユーザートリガー
20260226_tension_phase.sql     # Tensionカラム追加
20260226_indexes.sql           # パフォーマンスインデックス
20260227_multilang.sql         # 多言語対応 (user_characters等)
20260228_relationship_memories.sql  # 関係値メモリテーブル
20260228_vocabulary_index.sql  # 弱点語彙クエリ最適化
20260228_conversations_type.sql     # 添削履歴用カラム追加
```

## 🌱 シード適用順序

```bash
psql $DATABASE_URL -f supabase/seeds/season1_week1.sql          # Korean S1W1
psql $DATABASE_URL -f supabase/seeds/season1_week2_ko.sql       # Korean S1W2
psql $DATABASE_URL -f supabase/seeds/season1_week3_ko.sql       # Korean S1W3
psql $DATABASE_URL -f supabase/seeds/season1_week4_ko.sql       # Korean S1W4
psql $DATABASE_URL -f supabase/seeds/characters_multilang.sql   # 4キャラ追加
psql $DATABASE_URL -f supabase/seeds/season1_week1_multilang.sql # EN/TR/VI/AR S1W1
psql $DATABASE_URL -f supabase/seeds/season1_week2_multilang.sql # EN/TR/VI/AR S1W2
```

---

## 💰 料金プラン

| | Free | Pro |
|---|---|---|
| 会話 | 3ターン/日 | 無制限 |
| 対応言語 | Korean (지우) のみ | 全5言語 |
| AI添削 | 5回/日 | 無制限 |
| 語彙帳 | 全機能 | 全機能 |
| 料金 | 無料 | ¥1,480 / 月 |

---

## 🎨 デザインシステム

**Emotional Dark** テーマ。「夜、こっそり好きな人とLINEしている感覚」を設計原則に。

| トークン | 値 | 用途 |
|---|---|---|
| Background | `#09090F` | 深夜インディゴ |
| Surface | `#13131F` | カード背景 |
| Primary | `#FF4E8B` | CTA / ユーザーバブル |
| Tension | `#FF6B6B` | 喧嘩シーン |
| Success | `#4ECDC4` | 添削正解 / 達成 |
| Gold | `#FFD166` | ストリーク / XP |

→ 詳細: [`docs/DESIGN_RATIONALE.md`](docs/DESIGN_RATIONALE.md)
→ プレビュー: [`docs/design-preview/index.html`](docs/design-preview/index.html)

---

## 🧪 テスト

```bash
make test          # ユニット + Widgetテスト
make test-golden-update  # Golden baseline 生成 ← 初回必須
make analyze       # dart analyze
```

→ 詳細: [`docs/TESTING.md`](docs/TESTING.md)

---

## 📋 環境構築

→ [`SETUP.md`](SETUP.md) を参照（Supabase / Firebase / RevenueCat / App Store）

---

## 🗺 ロードマップ

| フェーズ | 言語 | 状態 |
|---|---|---|
| Phase 1 (BETA) | 🇰🇷 Korean | ✅ 実装完了 |
| Phase 2 | 🇺🇸 English + 🇹🇷 Turkish | ✅ 実装完了 |
| Phase 3 | 🇻🇳 Vietnamese + 🇸🇦 Arabic | ✅ 実装完了 |
| Phase 4 | 🇨🇳 Chinese + 🇫🇷 French + 🇪🇸 Spanish | 🔮 予定 |

# RizzLang 🌸

> AI外国人パートナーと毎日LINEして言語を身につけるモバイルアプリ

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green?logo=supabase)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🎯 コンセプト

韓国語・英語などを「感情が動く文脈」で学ぶ。教科書じゃなく、AIキャラとの疑似恋愛LINEで。

**Gotchaモーメント：**
```
지우: "오빠, 오늘 뭐 했어? 🥺 나 보고 싶었어~"

「仕事だったよ、俺も会いたかった」と日本語で入力するだけで

✦ 일 했어 😊 나도 보고 싶었어~ 빨리 보고 싶다
+ なぜその表現か・スラング解説まで即出力
```

---

## 🏗 技術スタック

| Layer | 技術 |
|---|---|
| モバイルアプリ | Flutter 3.19 (Dart) |
| 状態管理 | Riverpod 2 |
| ナビゲーション | GoRouter |
| バックエンド/DB | Supabase (PostgreSQL + RLS) |
| 認証 | Supabase Auth (Google / Apple) |
| AI生成 | Gemini 1.5 Flash（Supabase Edge Functions経由）|
| 課金 | Stripe |
| 通知 | Firebase Cloud Messaging (FCM) |

---

## 📁 プロジェクト構成

```
lib/
├── main.dart                    # エントリーポイント
├── app.dart                     # MaterialApp + GoRouter
├── core/
│   ├── models/                  # Freezed イミュータブルモデル
│   │   ├── user_model.dart
│   │   ├── message_model.dart
│   │   ├── scenario_model.dart
│   │   └── vocabulary_model.dart
│   ├── services/
│   │   ├── ai_service.dart      # Gemini API (Edge Function経由)
│   │   └── env.dart             # 環境変数
│   ├── providers/
│   │   └── auth_provider.dart   # Supabase Auth
│   └── theme/
│       └── app_theme.dart       # ダークテーマ
└── features/
    ├── auth/screens/            # Login / Onboarding
    ├── chat/
    │   ├── screens/chat_screen.dart   # メインチャット画面
    │   ├── providers/chat_provider.dart
    │   └── widgets/             # MessageBubble / ReplyPanel / StreakBar
    ├── vocabulary/screens/      # 語彙帳
    ├── home/                    # BottomNav ShellRoute
    └── settings/

supabase/
├── migrations/
│   └── 20260226_init.sql        # 完全なDBスキーマ + RLS
└── functions/
    ├── generate-reply/          # Gemini 1.5 Flash 本番用
    └── generate-demo-reply/     # オンボーディング用（認証不要）
```

---

## 🚀 開発セットアップ

### 前提
- Flutter 3.19+
- Supabase CLI
- Dart 3.3+

### 1. リポジトリのクローン

```bash
git clone https://github.com/mine2424/rizzlang.git
cd rizzlang
flutter pub get
```

### 2. Supabase セットアップ

```bash
# Supabase CLI インストール
brew install supabase/tap/supabase

# ローカル起動
supabase start

# マイグレーション実行
supabase db push

# Edge Functions デプロイ（本番）
supabase functions deploy generate-reply
supabase functions deploy generate-demo-reply
```

### 3. 環境変数の設定

Edge Functions に秘密鍵を設定：

```bash
supabase secrets set GEMINI_API_KEY=your_key
supabase secrets set STRIPE_SECRET_KEY=your_key
```

### 4. アプリの起動

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key
```

---

## 📖 仕様書

詳細な要件定義・設計書・タスクリストは `.kiro/specs/rizzlang-mvp/` を参照。

- [requirements.md](.kiro/specs/rizzlang-mvp/requirements.md) — EARS形式の要件定義
- [design.md](.kiro/specs/rizzlang-mvp/design.md) — 技術設計書
- [tasks.md](.kiro/specs/rizzlang-mvp/tasks.md) — 実装タスク一覧

---

## 📊 ビジネスモデル

| プラン | 価格 | 内容 |
|---|---|---|
| 無料 | ¥0 | 1日3往復・1キャラ |
| Pro | ¥1,480/月 | 無制限・全キャラ・語彙SRS |

---

## 🗺 ロードマップ

- [x] 仕様書・設計書完成
- [ ] Week 1: プロジェクト基盤 + Supabase スキーマ
- [ ] Week 2: AIチャット生成コアフロー
- [ ] Week 3: シナリオシステム + 語彙帳
- [ ] Week 4: 課金 + 磨き込み
- [ ] Beta: クローズドBETA（50人）

---

MIT License · Made with ❤️ in Tokyo

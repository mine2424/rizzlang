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
| 課金 | RevenueCat (App Store / Google Play IAP) |
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
- Supabase CLI (`brew install supabase/tap/supabase`)
- Docker Desktop（Supabase エミュレータに必要）
- Dart 3.3+

---

### ⚡ 即起動（推奨）

```bash
git clone https://github.com/mine2424/rizzlang.git
cd rizzlang
./scripts/setup-local.sh   # または: make setup
```

これだけで以下が全部完了：
1. Flutter 依存インストール
2. Supabase ローカルエミュレータ起動
3. DB マイグレーション適用
4. シードデータ投入（テストユーザー + シナリオ Week 1 + 語彙帳サンプル）

---

### 🖥 シミュレータ / エミュレータで確認

```bash
make run
```

ログイン画面に **「⚡ テストユーザーでログイン」** ボタンが表示される（デバッグビルドのみ）。
タップするだけで即 `test@rizzlang.local / test1234` でログインできる。

---

### 📱 物理デバイスで確認（iOS/Android 実機）

```bash
make local-ip          # Mac の LAN IP を確認
make run-device        # 自動検出した IP で起動
# または
make run-device LOCAL_HOST=192.168.x.x
```

> 物理デバイスと Mac が同じ Wi-Fi に接続している必要があります。

---

### 🛠 便利コマンド

| コマンド | 説明 |
|---------|------|
| `make local-start` | エミュレータ起動 + DB リセット |
| `make local-stop` | エミュレータ停止 |
| `make local-reset` | DB リセット（シード再適用） |
| `make functions-serve` | Edge Functions をローカルで起動 |
| `make run` | Flutter 起動（シミュレータ） |
| `make run-device` | Flutter 起動（物理デバイス） |
| `make test` | テスト全実行 |
| `make build-ios` | iOS リリースビルド |
| `make build-android` | Android リリースビルド |

---

### 🌐 ローカル環境 URL

| サービス | URL |
|---------|-----|
| Supabase Studio | http://127.0.0.1:54323 |
| API Endpoint | http://127.0.0.1:54321 |
| メール確認（Auth） | http://127.0.0.1:54324 |

---

### ⚙️ VS Code デバッグ設定

`.vscode/launch.json` に4種類の設定を用意済み：

| 設定 | 説明 |
|------|------|
| 🏠 Local (Emulator) | ローカルエミュレータ接続 |
| 📱 Physical Device (Local) | 物理デバイス + ローカル |
| 🚀 Production (Debug) | 本番デバッグ |
| 📦 Production (Release) | リリースビルド確認 |

`LOCAL_HOST` を自分の Mac の LAN IP に変更してください。

---

### 🔑 Edge Functions ローカル設定

`supabase/.env.local` に API キーを設定：

```bash
# GEMINI_API_KEY を取得して設定
# https://aistudio.google.com/app/apikey
vi supabase/.env.local  # GEMINI_API_KEY=your_key_here

# Edge Functions をローカルで起動
make functions-serve
```

---

### 📦 本番デプロイ

```bash
# Supabase 本番に Edge Functions をデプロイ
supabase functions deploy generate-reply
supabase functions deploy generate-demo-reply
supabase functions deploy difficulty-updater
supabase functions deploy fcm-scheduler
supabase functions deploy revenuecat-webhook

# Secrets を設定
supabase secrets set GEMINI_API_KEY=your_key
supabase secrets set REVENUECAT_WEBHOOK_SECRET=your_secret
supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON='{"type":"service_account",...}'

# iOS
make build-ios SUPABASE_URL=https://xxx.supabase.co SUPABASE_ANON_KEY=eyJ... RC_IOS_KEY=appl_xxx

# Android
make build-android SUPABASE_URL=https://xxx.supabase.co SUPABASE_ANON_KEY=eyJ... RC_ANDROID_KEY=goog_xxx
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

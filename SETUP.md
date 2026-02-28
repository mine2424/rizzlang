# RizzLang — セットアップガイド

このドキュメントはリリースに向けて必要な**外部サービスの初期設定**を網羅します。  
ローカル開発の起動方法は [README.md](README.md) を参照してください。

---

## 目次

1. [Supabase プロジェクト作成](#1-supabase-プロジェクト作成)
2. [Google Gemini API キー](#2-google-gemini-api-キー)
3. [Firebase / FCM セットアップ](#3-firebase--fcm-セットアップ)
4. [RevenueCat セットアップ](#4-revenuecat-セットアップ)
5. [App Store Connect (iOS)](#5-app-store-connect-ios)
6. [Google Play Console (Android)](#6-google-play-console-android)
7. [Supabase Edge Function Secrets 一覧](#7-supabase-edge-function-secrets-一覧)
8. [Supabase Cron ジョブ設定](#8-supabase-cron-ジョブ設定)
9. [環境変数まとめ](#9-環境変数まとめ)
10. [本番ビルドコマンド](#10-本番ビルドコマンド)
11. [チェックリスト](#11-チェックリスト)

---

## 1. Supabase プロジェクト作成

### 1-1. プロジェクト作成

1. [supabase.com](https://supabase.com) にアクセス → **New Project**
2. 設定値：
   - **Name**: `rizzlang`
   - **Database Password**: 安全なパスワードをメモしておく
   - **Region**: `Northeast Asia (Tokyo)` 推奨
3. 作成後、**Project Settings → API** から以下を取得：
   - `SUPABASE_URL` (`https://xxxx.supabase.co`)
   - `SUPABASE_ANON_KEY` (公開可・クライアント用)
   - `SUPABASE_SERVICE_ROLE_KEY` (非公開・Secrets のみ)

### 1-2. マイグレーション + シードデータ適用

```bash
# Supabase CLI でプロジェクトにリンク
supabase link --project-ref <project-ref>

# マイグレーション適用
supabase db push

# シードデータ投入（Season 1 Week 1 シナリオ + 지우キャラ）
supabase db execute --file supabase/seeds/season1_week1.sql

# Korean Season 1 Week 2〜4
supabase db execute --file supabase/seeds/season1_week2_ko.sql
supabase db execute --file supabase/seeds/season1_week3_ko.sql
supabase db execute --file supabase/seeds/season1_week4_ko.sql

# 多言語キャラクターシード（Emma / Elif / Linh / Yasmin）
supabase db execute --file supabase/seeds/characters_multilang.sql

# 多言語シナリオシード（EN / TR / VI / AR — Season 1 Week 1〜2）
supabase db execute --file supabase/seeds/season1_week1_multilang.sql
supabase db execute --file supabase/seeds/season1_week2_multilang.sql
```

> `<project-ref>` は Supabase Dashboard URL の `https://supabase.com/dashboard/project/<project-ref>` 部分

### 1-3. Edge Functions デプロイ

```bash
supabase functions deploy generate-reply
supabase functions deploy generate-demo-reply
supabase functions deploy check-writing
supabase functions deploy explain-grammar
supabase functions deploy memory-generator
supabase functions deploy difficulty-updater
supabase functions deploy fcm-scheduler
supabase functions deploy revenuecat-webhook
```

---

## 2. Google Gemini API キー

1. [Google AI Studio](https://aistudio.google.com/app/apikey) にアクセス
2. **Create API key** → プロジェクト選択（または新規作成）
3. 取得したキーを後述の [Secrets](#7-supabase-edge-function-secrets-一覧) に設定

> 無料枠: 15 RPM / 1,500 req/day / 1M tokens/day  
> β版100ユーザーまでは無料枠で賄える

---

## 3. Firebase / FCM セットアップ

### 3-1. Firebase プロジェクト作成

1. [Firebase Console](https://console.firebase.google.com) → **プロジェクトを追加**
2. **名前**: `rizzlang`
3. Google Analytics: 有効化推奨

### 3-2. iOS アプリ登録

1. Firebase Console → **プロジェクト設定 → アプリを追加 → iOS**
2. **Bundle ID**: `com.rizzlang.app`
3. `GoogleService-Info.plist` をダウンロード → `ios/Runner/` に配置

### 3-3. Android アプリ登録

1. Firebase Console → **アプリを追加 → Android**
2. **パッケージ名**: `com.rizzlang.app`
3. `google-services.json` をダウンロード → `android/app/` に配置

### 3-4. APNs 設定 (iOS プッシュ通知)

1. [Apple Developer](https://developer.apple.com) → **Certificates → Keys → + (新規)**
2. **Apple Push Notifications service (APNs)** にチェック → ダウンロード (`.p8`)
3. Firebase Console → **プロジェクト設定 → Cloud Messaging → APNs 認証キー**
   - アップロードした `.p8` ファイルを設定
   - **Key ID** と **Team ID** (Apple Developer Account) を入力

### 3-5. Service Account JSON 取得 (Edge Function 用)

FCM HTTP v1 API に必要なサービスアカウントキー：

1. Firebase Console → **プロジェクト設定 → サービスアカウント**
2. **新しい秘密鍵を生成** → JSON ダウンロード
3. JSON の中身を後述の `FIREBASE_SERVICE_ACCOUNT_JSON` Secrets に設定

---

## 4. RevenueCat セットアップ

### 4-1. RevenueCat アカウント作成

1. [app.revenuecat.com](https://app.revenuecat.com) にアクセス → **Get Started**
2. **New Project** → 名前: `RizzLang`

### 4-2. iOS アプリ設定

1. RevenueCat Dashboard → **+ New App → iOS**
2. **App Name**: `RizzLang`
3. **Bundle ID**: `com.rizzlang.app`
4. **App Store Connect API Key**: 
   - [App Store Connect](https://appstoreconnect.apple.com) → **ユーザーとアクセス → 統合 → App Store Connect API**
   - キーを生成して RevenueCat に設定

### 4-3. Android アプリ設定

1. RevenueCat Dashboard → **+ New App → Android**
2. **Package Name**: `com.rizzlang.app`
3. **Google Play Service Account**: 
   - [Google Play Console](https://play.google.com/console) → **セットアップ → APIアクセス**
   - サービスアカウントを作成し、JSON キーをRevenueCatに設定

### 4-4. 商品 (Product) 作成

App Store Connect と Google Play Console で商品を作成後、RevenueCat に登録。

| 設定項目 | 値 |
|---------|---|
| Product ID (iOS) | `com.rizzlang.pro.monthly` |
| Product ID (Android) | `com.rizzlang.pro.monthly` |
| 価格 | ¥1,480/月 |
| 種別 | 自動更新サブスクリプション |

### 4-5. Entitlement + Offering 設定

1. RevenueCat Dashboard → **Entitlements → + New**
   - **Identifier**: `pro`
   - 上記 Product を関連付け
2. **Offerings → + New**
   - **Identifier**: `default`
   - Package を追加 → `$rc_monthly` にProduct をセット

### 4-6. Webhook 設定

1. RevenueCat Dashboard → **Project Settings → Webhooks → + Add**
2. **Endpoint URL**: `https://<project-ref>.supabase.co/functions/v1/revenuecat-webhook`
3. 生成された **Webhook Secret** を `REVENUECAT_WEBHOOK_SECRET` Secrets に設定

### 4-7. API キー確認

RevenueCat Dashboard → **Project Settings → API Keys**:
- **iOS Public Key** (`appl_xxx`) → Flutter ビルド時に渡す
- **Android Public Key** (`goog_xxx`) → Flutter ビルド時に渡す

---

## 5. App Store Connect (iOS)

### 5-1. App ID 作成

1. [Apple Developer](https://developer.apple.com) → **Identifiers → +**
2. **Bundle ID**: `com.rizzlang.app`
3. **Capabilities**: `Push Notifications` にチェック

### 5-2. App 登録

1. [App Store Connect](https://appstoreconnect.apple.com) → **マイ App → +**
2. **Bundle ID**: `com.rizzlang.app`
3. **SKU**: `rizzlang`

### 5-3. サブスクリプション商品作成

1. App Store Connect → **機能 → サブスクリプション → +**
2. **参照名**: `RizzLang Pro Monthly`
3. **Product ID**: `com.rizzlang.pro.monthly`
4. **価格**: ¥1,480/月 (Tier 7 相当)
5. 各言語でのローカライズ説明文を追加

### 5-4. Small Business Program 登録（推奨）

Apple の Small Business Program に登録すると手数料が **30% → 15%** に下がる。  
→ [申請ページ](https://developer.apple.com/app-store/small-business-program/)

---

## 6. Google Play Console (Android)

### 6-1. アプリ作成

1. [Google Play Console](https://play.google.com/console) → **アプリを作成**
2. **パッケージ名**: `com.rizzlang.app`

### 6-2. サブスクリプション商品作成

1. **収益化 → 定期購入 → 定期購入を作成**
2. **商品 ID**: `com.rizzlang.pro.monthly`
3. **価格**: ¥1,480/月
4. 特典 (Benefits) を入力

---

## 7. Supabase Edge Function Secrets 一覧

以下のコマンドで一括設定できます（値は各自の実際のキーに差し替え）：

```bash
# Gemini API キー（Google AI Studio から取得）
supabase secrets set GEMINI_API_KEY=AIzaSy...

# RevenueCat Webhook 検証用シークレット（RC Dashboard から取得）
supabase secrets set REVENUECAT_WEBHOOK_SECRET=whsk_...

# Firebase Service Account JSON（Firebase Console から取得した JSON を一行に）
supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON='{"type":"service_account","project_id":"rizzlang","private_key_id":"...","private_key":"-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n","client_email":"firebase-adminsdk-xxx@rizzlang.iam.gserviceaccount.com",...}'
```

確認コマンド：

```bash
supabase secrets list
```

---

## 8. Supabase Cron ジョブ設定

Supabase Dashboard → **Database → Extensions → pg_cron を有効化** 後、以下を実行：

```sql
-- difficulty-updater: 毎週月曜 9:00 JST (= UTC 0:00)
SELECT cron.schedule(
  'difficulty-updater',
  '0 0 * * 1',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/difficulty-updater',
    headers := '{"Authorization": "Bearer ' || current_setting('app.service_role_key') || '"}'::jsonb
  );
  $$
);

-- fcm-scheduler: 毎日 9:00 JST (= UTC 0:00)
SELECT cron.schedule(
  'fcm-daily-reminder',
  '0 0 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/fcm-scheduler',
    headers := '{"Authorization": "Bearer ' || current_setting('app.service_role_key') || '"}'::jsonb
  );
  $$
);

-- memory-generator: 毎週月曜 0:00 JST (= UTC 15:00 日曜)
-- 先週の会話を AI サマリー化して relationship_memories に保存
SELECT cron.schedule(
  'memory-generator-weekly',
  '0 15 * * 0',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/memory-generator',
    headers := '{"Authorization": "Bearer ' || current_setting('app.service_role_key') || '"}'::jsonb
  );
  $$
);
```

> **注意**: Supabase の Cron は UTC 基準。JST 9:00 = UTC 0:00。

---

## 9. 環境変数まとめ

### Flutter アプリ側（`--dart-define` で渡す）

| 変数名 | 値の取得元 | 必須 |
|-------|-----------|------|
| `SUPABASE_URL` | Supabase Dashboard → API | ✅ |
| `SUPABASE_ANON_KEY` | Supabase Dashboard → API | ✅ |
| `RC_IOS_KEY` | RevenueCat Dashboard → API Keys | iOS |
| `RC_ANDROID_KEY` | RevenueCat Dashboard → API Keys | Android |

### Supabase Edge Functions 側（`supabase secrets set`）

| 変数名 | 値の取得元 | 使用 Function |
|-------|-----------|--------------|
| `GEMINI_API_KEY` | Google AI Studio | `generate-reply`, `generate-demo-reply` |
| `REVENUECAT_WEBHOOK_SECRET` | RevenueCat Dashboard | `revenuecat-webhook` |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Firebase Console → Service Account | `fcm-scheduler` |

---

## 10. 本番ビルドコマンド

```bash
# iOS
make build-ios \
  SUPABASE_URL=https://xxxx.supabase.co \
  SUPABASE_ANON_KEY=eyJhbGci... \
  RC_IOS_KEY=appl_xxxxx

# Android
make build-android \
  SUPABASE_URL=https://xxxx.supabase.co \
  SUPABASE_ANON_KEY=eyJhbGci... \
  RC_ANDROID_KEY=goog_xxxxx

# または直接 flutter コマンド
flutter build ipa \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci... \
  --dart-define=RC_IOS_KEY=appl_xxxxx

flutter build appbundle \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci... \
  --dart-define=RC_ANDROID_KEY=goog_xxxxx
```

---

## 11. チェックリスト

初回セットアップ完了確認用。順番通りに進めることを推奨。

### Supabase
- [ ] Supabase プロジェクト作成
- [ ] `supabase link` でローカルと紐付け
- [ ] `supabase db push` でマイグレーション 8本適用
- [ ] シードデータ 7本投入（season1_week1〜4_ko / characters_multilang / season1_week1〜2_multilang）
- [ ] Edge Functions **8本**デプロイ完了（generate-reply / generate-demo-reply / check-writing / explain-grammar / memory-generator / difficulty-updater / fcm-scheduler / revenuecat-webhook）
- [ ] Secrets 3種設定完了 (`GEMINI_API_KEY` / `REVENUECAT_WEBHOOK_SECRET` / `FIREBASE_SERVICE_ACCOUNT_JSON`)
- [ ] pg_cron 有効化 + Cron **3本**設定（difficulty-updater / fcm-daily-reminder / memory-generator-weekly）

### Firebase
- [ ] Firebase プロジェクト作成
- [ ] iOS: `GoogleService-Info.plist` を `ios/Runner/` に配置
- [ ] Android: `google-services.json` を `android/app/` に配置
- [ ] APNs 認証キー (.p8) を Firebase に設定
- [ ] Service Account JSON を取得して Supabase Secrets に設定

### RevenueCat
- [ ] RevenueCat プロジェクト作成
- [ ] iOS / Android アプリ登録
- [ ] Entitlement `pro` 作成
- [ ] Offering `default` 作成
- [ ] Webhook URL 設定 + Secret を Supabase Secrets に設定

### App Store Connect (iOS)
- [ ] App ID 作成 (`com.rizzlang.app`) + Push Notifications 有効化
- [ ] App Store Connect にアプリ登録
- [ ] サブスクリプション商品 `com.rizzlang.pro.monthly` 作成 (¥1,480/月)
- [ ] Small Business Program 申請（手数料 30% → 15%）

### Google Play Console (Android)
- [ ] アプリ作成
- [ ] 定期購入商品 `com.rizzlang.pro.monthly` 作成 (¥1,480/月)

### ビルド
- [ ] iOS ビルド成功 (`make build-ios ...`)
- [ ] Android ビルド成功 (`make build-android ...`)

---

## よくある問題

### FCM: `INVALID_ARGUMENT` エラー
- `FIREBASE_SERVICE_ACCOUNT_JSON` の JSON が壊れていないか確認
- `private_key` の改行 (`\n`) が正しくエスケープされているか確認

### RevenueCat: `PRODUCT_NOT_FOUND`
- App Store Connect / Google Play Console で商品ステータスが **「承認済み」** になっているか確認
- RC Offering に Product が紐付けられているか確認

### Supabase: `JWT expired`
- `SUPABASE_ANON_KEY` が正しいか確認（ローカルと本番を混在させていないか）

### プッシュ通知が届かない (iOS)
- APNs 環境 (Development/Production) が Firebase の設定と一致しているか確認
- `ios/Runner/Runner.entitlements` に `aps-environment: production` があるか確認

---

*最終更新: 2026-02-26*

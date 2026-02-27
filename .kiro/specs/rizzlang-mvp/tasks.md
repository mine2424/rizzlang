# Implementation Tasks — RizzLang

## ステータス凡例
- [x] 完了（コード実装済み）
- [ ] 未着手 or Ryota手動作業待ち
- (P) 他タスクと並列実行可能

---

## Phase A: MVP（韓国語単一言語）

### 1. プロジェクト基盤 ✅
- [x] 1.1 Flutter プロジェクト初期化・pubspec.yaml・テーマ
- [x] 1.2 Supabase スキーマ定義（`20260226_init.sql`）
- [x] 1.3 環境変数管理・Freezed モデル（User/Message/Scenario/Vocabulary）

### 2. 認証・ユーザー管理 ✅
- [x] 2.1 Google / Apple OAuth ログイン（`login_screen.dart` + `auth_provider.dart`）
- [x] 2.2 初回ログイン時 DB トリガー（`20260226_user_trigger.sql`）
- [x] 2.3 GoRouter ルート保護 + JWT 検証 Edge Function

### 3. オンボーディング ✅
- [x] 3.1 4ステップオンボーディング（Welcome → DemoChat → CallName → Complete）
- [x] 3.2 呼称選択（オッパ / 자기야 / カスタム）→ `users.user_call_name` 保存
- [x] 3.3 完了後 `/chat` 遷移・シナリオ Day1 開始

### 4. AIチャット生成 ✅
- [x] 4.1 `generate-reply` Edge Function（Gemini 1.5 Flash + System Prompt 動的構築）
- [x] 4.2 使用量チェック（Free=3ターン/日）・`generate-demo-reply`（未認証用）
- [x] 4.3 チャット UI（`chat_screen.dart` / `message_bubble.dart` / `reply_panel.dart`）
- [x] 4.4 `edit_count` / `retry_count` トラッキング → Edge Function → `usage_logs`

### 5. シナリオシステム ✅
- [x] 5.1 Season 1 Week 1 シード（7シーン × 4難易度 × 4時間帯 = 112パターン）
- [x] 5.2 今日のシナリオ選択・`opening_message` バリエーション取得
- [x] 5.3 シナリオ自動進行（Day+1 → Week+1 → Season+1）
- [x] 5.4 Tension 2フェーズ（friction → reconciliation → 関係値+1 アニメ）

### 6. 難易度自動変動 ✅
- [x] 6.1 `calcNextLevel()` + `difficulty-updater` Edge Function（毎週月曜 Cron）
- [x] 6.2 `generate-reply` に `current_level` 注入・レベル別 System Prompt

### 7. 語彙帳 ✅
- [x] 7.1 `saveVocabulary()` — slang + vocab_targets を会話ごとに自動 upsert
- [x] 7.2 語彙帳画面（フィルター / SRS フリップカード / SM-2 評価ボタン）

### 8. ストリーク・進捗可視化 ✅
- [x] 8.1 ストリーク更新ロジック + マイルストーン検知（7/30/100日）
- [x] 8.2 `StreakBar`（実データ連動・XP プログレス・スケルトン）
- [x] 8.3 `WeeklySummaryCard`（初回セッション時表示）+ マイルストーンダイアログ

### 9. フリーミアム課金（RevenueCat）✅
- [x] 9.1 RevenueCat 初期化（`revenue_cat_service.dart`）
- [x] 9.2 ペイウォール BottomSheet（キャラメッセージ + 特典リスト + 購入/復元）
- [x] 9.3 `revenuecat-webhook` Edge Function（INITIAL_PURCHASE/EXPIRATION 処理）

### 10. FCM Push 通知 ✅
- [x] 10.1 FCM トークン管理（取得・upsert・通知ON/OFF）
- [x] 10.2 `fcm-scheduler` Edge Function（毎日 0:00 UTC = 9:00 JST Cron）

### 11. 設定・ホーム画面 ✅
- [x] 11.1 `HomeScreen`（BottomNavigationBar シェル）
- [x] 11.2 `SettingsScreen`（通知トグル / 呼称変更 / 購入復元 / ログアウト）

### 12. セキュリティ・パフォーマンス ✅
- [x] 12.1 共通認証ミドルウェア（`_shared/auth.ts` — verifyAuth + checkRateLimit）
- [x] 12.2 `CacheService`（SharedPreferences + 日次自動クリア）
- [x] 12.3 DB インデックス（`20260226_indexes.sql`）

### 13. テスト ✅
- [x] 13.1 ユニットテスト（難易度エンジン / SM-2 SRS / ストリーク）
- [x] 13.2 Widget テスト（MessageBubble / ReplyPanel / StreakBar）
- [x] 13.3 VRT Golden テスト（23パターン）
- [x] 13.4 E2E 統合テスト（8グループ 30ケース）
- [x] 13.5 CI（`.github/workflows/test.yml` — analyze / golden / build）

### 14. コード品質 ✅（2026-02-27）
- [x] 14.1 Import パス修正（`fcm_service` / `revenue_cat_service`）
- [x] 14.2 `onBackgroundMessage` 二重登録解消
- [x] 14.3 `chatProvider` → `ref.watch(supabaseClientProvider)` に変更（テスト注入対応）
- [x] 14.4 `ChatState.copyWith` — `tensionPhase` null クリアバグ修正（_Undefined センチネル）
- [x] 14.5 未使用 9 パッケージ削除（dio / lottie / shimmer など）
- [x] 14.6 `assets/images/` `assets/fonts/` ディレクトリ作成
- [x] 14.7 タイポ修正（"地우" → "지우" 全ファイル）

---

## Phase B: 多言語対応（2026-02-27〜）

### 15. DB スキーマ拡張 ✅
- [x] 15.1 `users.active_character_id` カラム追加（`20260227_multilang.sql`）
- [x] 15.2 `user_characters` テーブル（解放キャラクター管理 + RLS）
- [x] 15.3 `character_level_guides` テーブル（言語別難易度ガイド + RLS）
- [x] 15.4 `handle_new_user` トリガー更新（지우を自動解放 + `user_characters` 追加）

### 16. キャラクターシード ✅
- [x] 16.1 Emma（🇺🇸 English / American / 23F / NYU）— `characters_multilang.sql`
- [x] 16.2 Elif（🇹🇷 Turkish / İstanbul / 23F）
- [x] 16.3 Linh（🇻🇳 Vietnamese / Hà Nội / 24F）
- [x] 16.4 Yasmin（🇸🇦 Arabic / Dubai / 25F / LTR）
- [x] 16.5 各キャラクター level 1〜4 の `character_level_guides` シード（16行）

### 17. Edge Function 多言語対応 ✅
- [x] 17.1 `generate-reply`: `characterId` パラメータ追加（デフォルト: 지우 UUID）
- [x] 17.2 `characters` テーブルからキャラクター情報を動的取得
- [x] 17.3 `character_level_guides` から言語別ガイドを DB 取得
- [x] 17.4 `buildSystemPrompt` 汎用化（targetLanguage / Arabic LTR 指示）
- [x] 17.5 レスポンスに `language` フィールド追加

### 18. Flutter — CharacterModel ✅
- [x] 18.1 `CharacterModel`（Freezed）+ `.freezed.dart` + `.g.dart`
- [x] 18.2 Extension: `callName` / `flagEmoji` / `languageDisplayName` / `shortName`

### 19. Flutter — Character Provider ✅
- [x] 19.1 `activeCharacterProvider`（StateNotifierProvider）
- [x] 19.2 `ActiveCharacterNotifier.switchCharacter()` — DB 更新 + シナリオ進捗作成
- [x] 19.3 `allCharactersProvider` / `unlockedCharactersProvider`

### 20. Flutter — 言語選択 UI ✅
- [x] 20.1 `language_select_screen.dart` — キャラクターカード縦スクロール
- [x] 20.2 Free ユーザー: 지우のみ選択可（他は 🔒 "Pro で解放"）
- [x] 20.3 「決定する」→ switchCharacter() → `/chat` 遷移
- [x] 20.4 `/language-select` ルートを `app.dart` に追加

### 21. Flutter — Chat / Settings 更新 ✅
- [x] 21.1 `ChatScreen` AppBar — `activeCharacterProvider` から動的表示（名前・国旗・言語）
- [x] 21.2 `SettingsScreen` — 「学習言語を変更」タイル追加（`/language-select` 遷移）

### 22. LP 更新 ✅
- [x] 22.1 言語グリッドに 🇹🇷 🇻🇳 🇸🇦 を追加（全8言語）
- [x] 22.2 🇺🇸 英語 "BETAで利用可" → "近日公開" に修正（韓国語のみ BETA）

---

## Ryota 手動作業（ブロッカー）

### 外部サービス設定（SETUP.md 参照）
- [ ] **Supabase**: プロジェクト作成 → `supabase link` → `db push` → seed → Edge Functions deploy → Secrets 設定 → pg_cron 設定
- [ ] **Firebase/FCM**: プロジェクト作成 → iOS/Android 登録 → APNs `.p8` → Service Account JSON
- [ ] **RevenueCat**: プロジェクト → Entitlement `pro` → Offering `default` → Product `com.rizzlang.pro.monthly` → Webhook URL
- [ ] **App Store Connect**: Bundle ID `com.rizzlang.app` → サブスク商品（¥1,480/月）
- [ ] **Google Play**: アプリ作成 → サブスク商品
- [ ] **X account**: @rizzlang（SMS 認証必要）

### ローカル作業
- [ ] `make test-golden-update` → `git add test/goldens/` → commit（VRT baseline 生成）
- [ ] `assets/fonts/` に NotoSansJP-Regular.ttf + NotoSansJP-Bold.ttf 配置
- [ ] 実機ビルド・テスト（`make build-ios` / `make build-android`）

---

## 残コード実装タスク

### Phase B 継続
- [x] **23. Season 1 Week 1 シード — 多言語版**（`season1_week1_multilang.sql` — 4言語 × 7シーン × 16バリアント = 1,289行）
- [x] **24. オンボーディング 多言語対応**（Step 0: LanguageSelect 追加、デモチャットをキャラクター連動）
- [x] **25. Paywall — 言語別メッセージ + 全言語解放特典追加**
- [x] **26. テスト更新**（CharacterModel フェイク × 5キャラ + FakeActiveCharacterNotifier + defaultTestOverrides に追加）
- [x] **27. SETUP.md 更新**（多言語シード手順追記）
- [x] **28. generate-demo-reply 多言語対応**（characterId + DEMO_MESSAGES × 5言語）
- [x] **29. オンボーディング言語選択ステップ**（_Step.languageSelect を最初に）
- [x] **30. 呼称選択のキャラクター連動**（ko/en/tr/vi/ar 別オプション）
- [x] **31. AIService.generateDemoReply に characterId 追加**

---

## コミット履歴

| ハッシュ | 内容 |
|---------|------|
| (次) | feat: multilang content + onboarding i18n + paywall i18n ← **最新** |
| `1300ef0` | docs: update tasks.md Phase B |
| `79dbd43` | feat: multi-language support (8 languages, 5 characters) |
| `50ee7e4` | fix: static analysis + code quality |
| `e034e61` | fix: resolve all TODO items + polish |
| `093fa37` | test: E2E + VRT golden + CI |
| `be4dc7d` | feat: remaining tasks (4.4/5.4/7.1/8.1) |
| `0b40b64` | docs: SETUP.md |

# Implementation Tasks — RizzLang Flutter MVP

---

- [ ] 1. Flutter プロジェクト基盤とコード生成

- [ ] 1.1 依存パッケージのセットアップとコード生成
  - `pubspec.yaml` に supabase_flutter / flutter_riverpod / go_router / google_sign_in / sign_in_with_apple / freezed / flutter_stripe / firebase_messaging / flutter_animate / lottie を追加
  - `flutter pub get` を実行してパッケージをインストール
  - `UserModel`, `MessageModel`, `SlangItem`, `GeneratedReply`, `ScenarioModel`, `VocabularyModel` に `@freezed` アノテーションを付与
  - `dart run build_runner build` でFreezeD と json_serializable のコードを生成する
  - _Requirements: 10.2_

- [ ] 1.2 (P) Firebase / Supabase プロジェクト接続
  - Firebase プロジェクトを作成し、iOS（`GoogleService-Info.plist`）と Android（`google-services.json`）の設定ファイルを配置
  - Supabase プロジェクトを作成し、URL と anon key を取得する
  - `--dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx` で実行できることを確認
  - _Requirements: 1.4, 9.1, 10.2_

- [ ] 1.3 (P) Supabase DB スキーマとマイグレーション
  - `supabase/migrations/` に `users`, `characters`, `conversations`, `scenario_templates`, `user_scenario_progress`, `vocabulary`, `usage_logs`, `push_subscriptions` テーブルのSQLを作成
  - 全テーブルに RLS を有効化し `auth.uid() = user_id` ポリシーを適用する
  - `handle_new_user` トリガー関数と `increment_usage` 関数を作成する
  - `conversations(user_id, date)`, `vocabulary(next_review)`, `usage_logs(user_id, date)` にインデックスを作成する
  - `supabase db push` でローカルへのマイグレーションを適用する
  - _Requirements: 1.3, 1.6, 10.4_

---

- [ ] 2. 認証・ナビゲーション

- [ ] 2.1 Google / Apple サインイン実装
  - `AuthNotifier` に Google OAuth フロー（`google_sign_in` → `signInWithIdToken`）を実装する
  - `AuthNotifier` に Apple Sign In フロー（`sign_in_with_apple` → Supabase Auth）を実装する
  - ログイン画面に Google・Apple ボタンを配置し、ローディング中は無効化する
  - _Requirements: 1.1, 1.2_

- [ ] 2.2 GoRouter 認証ガードとルーティング設定
  - `authStateProvider`（`Supabase.instance.client.auth.onAuthStateChange` の Stream）を定義する
  - GoRouter の `redirect` コールバックで未認証ユーザーを `/login` へ、認証済みユーザーを `/chat` へ自動遷移させる
  - `/chat`, `/vocabulary`, `/settings` を ShellRoute でラップし、BottomNavigationBar を表示する
  - _Requirements: 1.5_

- [ ] 2.3 (P) セッション自動更新とユーザーレコード初期化
  - Supabase SDK のリフレッシュトークン自動更新が機能することを確認し、手動リフレッシュロジックを削除する
  - データベーストリガー `handle_new_user` により初回ログイン時に `users` レコードが自動作成されることをテストで確認する
  - _Requirements: 1.3, 1.4_

---

- [ ] 3. オンボーディング

- [ ] 3.1 デモチャット画面（認証前の価値体験）
  - 未認証ユーザーがアプリを起動したときに表示するデモ画面を実装する
  - デモ画面に地우のプリセットメッセージを表示し、日本語入力フィールドを配置する
  - `generate-demo-reply` Edge Function を呼び出してGotchaモーメントを体験させる（認証不要）
  - 2回目の返信試行でサインアップを促すボトムシートを表示する
  - _Requirements: 2.1, 2.2, 2.3_

- [ ] 3.2 キャラクター呼称選択と進捗初期化
  - オンボーディング中に「오빠 / 자기야 / カスタム入力」の3択を提示する画面を実装する
  - 選択した呼称を `users.user_call_name` に保存する
  - オンボーディング完了時に `user_scenario_progress` を season=1, week=1, day=1 で作成する
  - _Requirements: 2.4, 2.5_

---

- [ ] 4. Supabase Edge Functions（AI バックエンド）

- [ ] 4.1 `generate-reply` Edge Function 実装
  - Supabase Edge Function（Deno）で `@google/generative-ai` を使い Gemini 1.5 Flash を呼び出す処理を実装する
  - JWT 検証→使用量チェック（free 3往復制限）→System Prompt 構築（キャラ + レベル + 時間帯）→Gemini 呼び出し→語彙 upsert→`increment_usage` の一連フローを実装する
  - 429 制限超過・401 未認証・500 内部エラーのレスポンスを返す
  - `supabase secrets set GEMINI_API_KEY=xxx` で APIキーを設定し、`supabase functions deploy generate-reply` でデプロイする
  - _Requirements: 3.1, 3.2, 3.6, 5.4, 6.1, 10.3, 10.4_

- [ ] 4.2 (P) `generate-demo-reply` Edge Function 実装
  - 認証不要のデモ用 Edge Function を実装し、固定のデモメッセージ（`오빠, 오늘 뭐 했어?`）に対して返信を生成する
  - `supabase functions deploy generate-demo-reply` でデプロイする
  - _Requirements: 2.2_

- [ ] 4.3 (P) `create-checkout-session` / `stripe-webhook` Edge Functions 実装
  - `create-checkout-session` で Stripe Checkout Session を作成し `clientSecret` と `publishableKey` を返す
  - `stripe-webhook` で `checkout.session.completed` → `users.plan = pro`、`subscription.deleted` → `users.plan = free` を処理する
  - Stripe署名検証（`constructEvent`）と idempotency キー（Stripe Event ID）による重複処理防止を実装する
  - `supabase secrets set STRIPE_SECRET_KEY=xxx STRIPE_WEBHOOK_SECRET=xxx` を設定してデプロイする
  - _Requirements: 8.3, 8.4, 8.5_

---

- [ ] 5. AIチャット生成（コア機能）

- [ ] 5.1 Flutter 側 AIService の実装
  - `supabase.functions.invoke('generate-reply', body: {...})` を呼び出す `AIService` を実装する
  - HTTP 429 を受け取った場合に `AIServiceException(statusCode: 429)` をスローする
  - HTTP 5xx の場合は `AIServiceException` をスローする
  - _Requirements: 3.1, 3.4, 3.5, 3.6_

- [ ] 5.2 ChatNotifier と会話状態管理
  - Riverpod StateNotifier として `ChatNotifier` を実装する
  - 当日の `conversations` レコードを読み込み、未存在の場合はシナリオからオープニングメッセージを取得して表示する
  - `generateReply()` でAI生成→メッセージリスト更新→語彙サマリー表示の一連フローを実装する
  - `AIServiceException(429)` 受信時に `showPaywall = true` にする
  - _Requirements: 3.2, 3.3, 3.7, 4.3_

- [ ] 5.3 (P) チャット画面 UI 実装
  - LINE風チャット画面（地우アイコン・吹き出し・タイムスタンプ）を実装する
  - 日本語入力エリアと「変換」ボタンを実装し、`isGenerating` 中はボタンを無効化して `CircularProgressIndicator` を表示する
  - AI生成結果（韓国語返信 / 理由 / スラング解説）を表示する `ReplyPanel` ウィジェットを実装する
  - 「送信」ボタンで地우の `nextMessage` をキャラクターメッセージとして追加する
  - メッセージ追加時に `flutter_animate` でフェードイン＋スライドアニメーションを付ける
  - _Requirements: 3.3, 3.7_

---

- [ ] 6. シナリオシステム

- [ ] 6.1 シナリオデータ投入
  - Season 1 Week 1（7シーン × 4難易度 × 4時間帯）の `scenario_templates` シードデータを SQL で作成する
  - `scene_type: tension` のシーンに摩擦フェーズ・仲直りフェーズのフラグを追加する
  - `supabase db seed` または SQL ファイルで投入する
  - _Requirements: 4.2, 4.6_

- [ ] 6.2 ScenarioService 実装
  - `getTodayScenario()` で `user_scenario_progress` を読み取り、対応するシナリオレコードを取得する
  - 現在時刻（JST）から時間帯を判定し、`opening_message` の対応バリエーションを選択する
  - 当日セッション存在チェックで二重進行を防ぐ
  - _Requirements: 4.1, 4.2, 4.3, 4.6_

- [ ] 6.3 (P) シナリオ進捗の自動更新
  - 当日初回チャット開始時に `advanceProgress()` を呼び出し、`arc_day + 1` に更新する
  - `arc_day = 7` 完了時は `arc_week + 1, arc_day = 1` にリセットする
  - `arc_week = 4` 完了時は `arc_season + 1, arc_week = 1` にリセットする
  - _Requirements: 4.4_

- [ ] 6.4 Tension シーンの2フェーズ UI
  - `scene_type = tension` のシーンで摩擦→仲直りの2フェーズフローを実装する
  - 仲直り完了時に Lottie アニメーション（関係値+1）を表示する
  - _Requirements: 4.5_

---

- [ ] 7. 難易度変動とストリーク

- [ ] 7.1 難易度計算エンジン実装
  - 直近7日間の `usage_logs` から `noEditRate` と `avgRetries` を集計する関数を実装する
  - `calcNextLevel()` で閾値（0.8/0.4, 0.5/2.0）に基づいて level を +1 / -1 / 維持を返す
  - 週次バッチを Supabase Edge Function（cron）または手動トリガーで実行する
  - _Requirements: 5.1–5.4_

- [ ] 7.2 (P) ストリーク管理実装
  - 当日初回チャット開始時に `updateStreak()` を呼び出し、`streak +1` または断絶リセットを行う
  - チャット画面のストリークバーに 🔥{N}日連続 と XP進捗バーをリアルタイム更新する
  - 7・30・100日マイルストーン到達時に Lottie 紙吹雪アニメーションを表示する
  - _Requirements: 7.1–7.4_

---

- [ ] 8. 語彙帳

- [ ] 8.1 語彙の自動保存と SRS スケジューリング
  - Edge Function からの `slang[]` を受け取り `vocabulary` テーブルに upsert する処理を Flutter 側で実装する
  - SM-2 アルゴリズムで `next_review` を計算する（初回: +1日 / 2回目: +3日 / 3回目: +7日 / 以降: ×ease_factor）
  - チャットセッション終了後に「今日 +{n}表現習得」サマリーカードを `flutter_animate` で表示する
  - _Requirements: 6.1, 6.2, 6.4_

- [ ] 8.2 (P) 語彙帳画面 UI
  - 語彙帳タブに習得済み語彙を「最近学んだ順」でリスト表示する
  - 単語・意味・習得日を表示する語彙カードウィジェットを実装する
  - _Requirements: 6.3_

---

- [ ] 9. 課金（Stripe）

- [ ] 9.1 ペイウォール UI とアップグレードフロー
  - 無料3往復超過時に「지우がもっと話したそうにしています...」コピーを含むペイウォールのボトムシートを表示する
  - 「アップグレード」ボタンで `create-checkout-session` Edge Function を呼び出し、`flutter_stripe` の `presentPaymentSheet()` を表示する
  - 決済完了後に `users.plan = pro` になっていることを確認してペイウォールを閉じる
  - _Requirements: 8.1, 8.2, 8.3_

---

- [ ] 10. FCM プッシュ通知

- [ ] 10.1 FCMトークン取得と保存
  - アプリ初回起動時に `firebase_messaging` で通知許可ダイアログを表示する
  - 許可後に FCM トークンを取得して `push_subscriptions` テーブルに保存する
  - `FirebaseMessaging.onMessageOpenedApp` でチャット画面へのディープリンク遷移を実装する
  - _Requirements: 9.1, 9.2, 9.4_

- [ ] 10.2 (P) `daily-reminder` Edge Function 実装
  - Supabase Edge Function（cron: 毎日 9:00 JST）で前日アクセスあり・当日未アクセスのユーザーを抽出する
  - FCM HTTP v1 API を呼び出して「지우からメッセージが届いています 🥺」通知を送信する
  - 1日1回制限のフラグ管理を実装する
  - _Requirements: 9.3_

---

- [ ] 11. テスト

- [ ] 11.1 ユニットテスト
  - `DifficultyService.calcNextLevel()` の境界値テスト（0.8/0.4/0.5/2.0）
  - `ScenarioService.selectOpeningMessage()` の4時間帯 × 4レベルのマトリクステスト
  - SM-2 アルゴリズムの `next_review` 計算テスト（初回〜3回目）
  - `StreakService.updateStreak()` の継続・断絶両ケース
  - _Requirements: 5.2, 5.3, 6.2, 7.1, 7.2_

- [ ] 11.2 (P) ウィジェットテスト
  - `ChatScreen` — `isGenerating = true` 時のボタン無効化確認
  - `ReplyPanel` — `slang[]` が空の場合と1件以上の場合の表示確認
  - `StreakBar` — streak 値がプロバイダーから正しく反映されるか
  - _Requirements: 3.3, 6.4, 7.3_

- [ ] 11.3 統合テスト（Flutter Integration Test）
  - オンボーディング → デモ → Google サインアップ → 初回チャット の完全フロー
  - 無料3往復 → ペイウォールボトムシート表示の確認
  - `arc_day = 7` 完了 → 翌日 `arc_week + 1` への進行確認
  - _Requirements: 2.1, 2.3, 3.4, 4.4, 8.1_

---

## 要件カバレッジ確認

| 要件グループ | カバーするタスク |
|------------|----------------|
| 1（認証） | 2.1, 2.2, 2.3, 1.3 |
| 2（オンボーディング） | 3.1, 3.2 |
| 3（AIチャット） | 4.1, 5.1, 5.2, 5.3 |
| 4（シナリオ） | 6.1, 6.2, 6.3, 6.4 |
| 5（難易度変動） | 7.1 |
| 6（語彙帳） | 8.1, 8.2 |
| 7（ストリーク） | 7.2 |
| 8（Stripe課金） | 4.3, 9.1 |
| 9（FCM通知） | 10.1, 10.2 |
| 10（性能・セキュリティ） | 1.1, 4.1, 1.3 |

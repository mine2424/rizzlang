# Requirements Document

## Introduction

RizzLang は、AI外国人パートナーとの疑似恋愛LINE会話を通じて、日本語話者が自然な外国語表現を身につける Flutter モバイルアプリ（iOS / Android）である。ユーザーは日本語で「言いたいこと」を入力すると、Supabase Edge Function 経由の Gemini 1.5 Flash が自然な返信・理由解説・スラング解説を生成する。K-drama的なシナリオアーク（30日）と難易度自動変動がリテンションを生む。

**スタック:** Flutter 3.19 / Riverpod 2 / GoRouter / Supabase / Gemini 1.5 Flash / Stripe / FCM

---

## Requirements

### Requirement 1: ユーザー認証・アカウント管理

**Objective:** 言語学習者として、モバイルアプリで手軽にサインアップ・ログインできること。学習データが永続化され、端末を変えても継続できる。

#### Acceptance Criteria

1. When ユーザーが「Googleでサインイン」ボタンをタップした場合, the RizzLang App shall `google_sign_in` パッケージ経由でGoogle OAuthを開始し、取得した `idToken` を Supabase Auth の `signInWithIdToken` に渡して認証を完了する
2. When ユーザーが「Appleでサインイン」ボタンをタップした場合, the RizzLang App shall `sign_in_with_apple` パッケージ経由でApple Sign Inを開始し、Supabase Auth で認証を完了する
3. When 認証が初めて完了した場合, the RizzLang App shall Supabaseのデータベーストリガー（`handle_new_user`）により `users` テーブルに `plan=free`, `streak=0`, `current_level=1` のレコードを自動作成する
4. If アクセストークンの有効期限が切れた場合, the RizzLang App shall Supabase Flutter SDK のリフレッシュトークン自動更新機能により、ユーザーに再ログインを求めることなくセッションを継続する
5. The RizzLang App shall GoRouter の `redirect` でセッション状態を監視し、未認証ユーザーをログイン画面へ、認証済みユーザーをチャット画面へ自動遷移させる
6. The RizzLang App shall Supabase RLS（Row Level Security）により、全テーブルで `auth.uid() = user_id` ポリシーを適用し、他ユーザーのデータアクセスを禁止する

---

### Requirement 2: オンボーディング（Gotchaモーメント体験）

**Objective:** 新規ユーザーとして、アカウント作成前にアプリの価値を体験できること。「これが言いたかった」という感動（Gotchaモーメント）を経験してからサインアップする。

#### Acceptance Criteria

1. When 未認証ユーザーがアプリを起動した場合, the RizzLang App shall ログイン画面ではなくデモチャット画面を表示し、地우からのプリセットメッセージ（`오빠, 오늘 뭐 했어? 🥺 나 보고 싶었어~`）を表示する
2. When 未認証ユーザーがデモ画面で日本語テキストを入力して送信した場合, the RizzLang App shall 認証不要の `generate-demo-reply` Edge Function を呼び出し、韓国語返信・理由・スラング解説を生成して表示する
3. When 未認証ユーザーが2回目の返信を試みた場合, the RizzLang App shall サインアップを促すボトムシートを表示し、Google・Apple ログインボタンを提示する
4. When オンボーディング中にキャラクターからの呼ばれ方を設定する場合, the RizzLang App shall 「오빠 / 자기야 / カスタム入力」の3択から選択させ、`users.user_call_name` に保存する
5. When オンボーディングが完了した場合, the RizzLang App shall `user_scenario_progress` を season=1, week=1, day=1 で初期化し、チャット画面へ遷移する

---

### Requirement 3: AI チャット生成（コア機能）

**Objective:** 学習者として、日本語で「言いたいこと」を入力するだけで、自然な外国語返信と学習解説が3秒以内に得られること。

#### Acceptance Criteria

1. When ユーザーが日本語テキストを入力して「変換」ボタンをタップした場合, the RizzLang App shall Supabase の `functions.invoke('generate-reply')` を呼び出し、`userText` ・ `conversationId` ・ `history`（直近20件）・ `userLevel` ・ `userCallName` を渡す
2. When `generate-reply` Edge Function がレスポンスを返した場合, the RizzLang App shall `{reply, why, slang[], nextMessage}` の JSON をパースし、韓国語返信・理由（30文字以内）・スラング解説・地우の次のセリフを画面に表示する
3. While Edge Function への HTTP リクエストが処理中の場合, the RizzLang App shall 入力フィールドと送信ボタンを無効化し、`CircularProgressIndicator` をボタン内に表示する
4. If `generate-reply` Edge Function が HTTP 429（制限超過）を返した場合, the RizzLang App shall ペイウォールのボトムシートを表示する
5. If `generate-reply` Edge Function がその他のエラーを返した場合, the RizzLang App shall `SnackBar` でエラーメッセージを表示し、入力フィールドを再有効化する
6. The RizzLang App shall Gemini API キー・Stripe Secret・Supabase Service Role Key を Edge Function の環境変数にのみ保存し、Flutter アプリのバンドルに含めない
7. When ユーザーが生成された外国語返信を「送信」した場合, the RizzLang App shall その返信をメッセージリストに追加し、続けて地우の `nextMessage` をキャラクターメッセージとして表示する

---

### Requirement 4: シナリオシステム

**Objective:** 学習者として、毎日K-dramaのような感情的なストーリーの続きを体験できること。前日からの文脈があり、感情曲線に沿ったシーンが展開される。

#### Acceptance Criteria

1. When ユーザーがチャット画面を開いた場合, the RizzLang App shall `user_scenario_progress` から現在の season / week / day を読み取り、対応する `scenario_templates` レコードを取得する
2. When シナリオが取得された場合, the RizzLang App shall ユーザーの `current_level`（1-4）と現在時刻（morning / afternoon / evening / night）に対応する `opening_message` バリエーションを選択して地우のメッセージとして表示する
3. When 当日すでにチャットセッションが存在する場合, the RizzLang App shall 新しいシナリオを開始せず既存の `conversations` レコードの `messages` を継続表示する（1日1シーン固定）
4. When ユーザーが当日初めてチャットを開始した場合, the RizzLang App shall `user_scenario_progress` の `arc_day` を翌日分に更新し、`arc_day = 7` 完了時は `arc_week + 1`、`arc_week = 4` 完了時は `arc_season + 1` にリセットする
5. Where シーンタイプが `tension` の場合, the RizzLang App shall 摩擦フェーズと仲直りフェーズの2段階フローを実行し、仲直り完了時に Lottie アニメーション（関係値+1）を表示する
6. The RizzLang App shall 時間帯（5-11時: morning / 11-17時: afternoon / 17-21時: evening / 21-5時: night）を JST で判定し、地うのオープニングメッセージのトーンを自動調整する

---

### Requirement 5: 難易度自動変動

**Objective:** 学習者として、自分のレベルに合った外国語で会話できること。上達に応じて自然に難易度が上がり、飽きることなく学習が続く。

#### Acceptance Criteria

1. The RizzLang App shall ユーザーのレベルを Level 1（初級）〜 Level 4（ネイティブ感性）で管理し、`users.current_level` に保存する
2. When 直近7日間の `usage_logs` で「編集なし送信率 > 80%」かつ「平均リトライ数 < 0.5」の場合, the RizzLang App shall `current_level` を +1 する（上限 Level 4）
3. When 直近7日間の `usage_logs` で「編集なし送信率 < 40%」または「平均リトライ数 > 2」の場合, the RizzLang App shall `current_level` を -1 する（下限 Level 1）
4. When `generate-reply` Edge Function を呼び出す場合, the RizzLang App shall `userLevel` パラメータを渡し、Edge Function 側の System Prompt に難易度指定（Lv1=短文 / Lv2=スラング / Lv3=複合表現 / Lv4=ネイティブ）を含める
5. The RizzLang App shall 往復ごとに `edit_count`（テキスト編集回数）と `retry_count`（再生成回数）を `usage_logs` に記録する

---

### Requirement 6: 語彙帳・学習記録

**Objective:** 学習者として、会話で出た表現が自動蓄積され、後から復習できること。学習量の可視化でモチベーションが維持できる。

#### Acceptance Criteria

1. When Edge Function から `slang[]` を含むレスポンスが返った場合, the RizzLang App shall 各スラングアイテムを `vocabulary` テーブルに upsert する（`user_id, word, language` でユニーク制約）
2. The RizzLang App shall SM-2アルゴリズムに基づき `next_review` を計算して保存する（初回: +1日 / 2回目: +3日 / 3回目: +7日 / 以降: 前回間隔 × ease_factor）
3. When ユーザーが語彙帳タブを開いた場合, the RizzLang App shall 習得済み語彙を「最近学んだ順」でリスト表示し、単語・意味・習得日を表示する
4. When チャットセッションが終了した場合, the RizzLang App shall 「今日 +{n}表現を習得しました 🎉」というサマリーカードを `flutter_animate` でアニメーション表示する

---

### Requirement 7: ストリーク・進捗可視化

**Objective:** 学習者として、毎日の継続状況を視覚的に確認でき、続けるモチベーションが生まれること。

#### Acceptance Criteria

1. When ユーザーが当日初めてチャットセッションを開始した場合, the RizzLang App shall `users.streak` を +1 し、`users.last_active` を今日の日付に更新する
2. If `users.last_active < today - 1日` の場合, the RizzLang App shall `users.streak` を 0 にリセットしてから +1 する
3. The RizzLang App shall チャット画面上部のストリークバーに「🔥 {N}日連続」と当日XP進捗バーを常時表示する
4. When ストリークが 7・30・100日 の節目に達した場合, the RizzLang App shall Lottie の紙吹雪アニメーションと「{N}日達成！」バナーを表示する

---

### Requirement 8: フリーミアム課金（Stripe）

**Objective:** ユーザーとして、無料で価値を体験し、必要になったら簡単に Pro プランへアップグレードできること。

#### Acceptance Criteria

1. While `users.plan = free` の場合, the RizzLang App shall 1日3往復目の返信後に次の送信をブロックし、ペイウォールのボトムシートを表示する
2. When ペイウォールが表示された場合, the RizzLang App shall 「지우がもっと話したそうにしています...」のコピーと Pro プラン料金（¥1,480/月）を表示し、「アップグレード」ボタンを配置する
3. When ユーザーが「アップグレード」ボタンをタップした場合, the RizzLang App shall Supabase Edge Function の `create-checkout-session` を呼び出し、Stripe Payment Sheet を `flutter_stripe` で表示する
4. When Stripe の `checkout.session.completed` Webhook を受信した場合, the RizzLang App shall `users.plan` を `pro` に更新し、往復制限を解除する
5. When Stripe の `customer.subscription.deleted` Webhook を受信した場合, the RizzLang App shall `users.plan` を `free` に戻す
6. Where `users.plan = pro` の場合, the RizzLang App shall 往復数制限なし・全キャラクター・語彙SRS復習モードを提供する

---

### Requirement 9: FCM プッシュ通知

**Objective:** 学習者として、毎日の学習を忘れないよう、地うからのメッセージ通知をモバイルで受け取れること。

#### Acceptance Criteria

1. When アプリが初回起動された場合, the RizzLang App shall `firebase_messaging` で通知許可ダイアログを表示する
2. When 通知が許可された場合, the RizzLang App shall FCM トークンを取得して `push_subscriptions` テーブルに保存する
3. When 前日アクセスがありかつ当日 9:00 JST 時点でアクセスがないユーザーが存在する場合, the RizzLang App shall Supabase Edge Function（cron）から FCM API 経由で「지우からメッセージが届いています 🥺」という通知を送信する
4. When ユーザーが通知をタップした場合, the RizzLang App shall アプリがフォアグラウンド・バックグラウンドどちらの状態でも当日のチャット画面へ遷移する

---

### Requirement 10: パフォーマンス・セキュリティ

**Objective:** サービスとして、快適なレスポンスと安全なデータ管理を維持すること。

#### Acceptance Criteria

1. The RizzLang App shall Edge Function の AI 生成レスポンスタイムを 3秒以内（P95）に維持する（Gemini 1.5 Flash の平均レイテンシ: 1-2秒）
2. The RizzLang App shall `--dart-define` フラグで注入した Supabase URL / Anon Key 以外の秘密鍵を Flutter バンドルに含めない
3. When Edge Function がリクエストを受信した場合, the RizzLang App shall JWT の `auth.getUser()` で認証を検証し、未認証リクエストを HTTP 401 で拒否する
4. The RizzLang App shall 1ユーザーあたり1分間に10回を超える Edge Function リクエストを HTTP 429 で拒否するレート制限を `usage_logs` を使って実装する
5. The RizzLang App shall Flutter の `CachedNetworkImage` でキャラクターアバターをキャッシュし、初回以降の画像読み込みを 100ms 以内にする

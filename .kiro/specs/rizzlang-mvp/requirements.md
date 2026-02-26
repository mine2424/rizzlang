# Requirements Document

## Introduction

RizzLang は、AI外国人パートナー（지우：韓国人女性キャラクター）と毎日LINE風チャットをしながら、感情的な文脈で自然な韓国語表現を身につける言語学習Webアプリである。ユーザーは日本語で「言いたいこと」を入力すると、自然な韓国語返信・表現の理由解説・スラング解説が即時出力される。シナリオは疑似恋愛の関係アーク（30日 × Season）に沿って進行し、感情的な山場がリテンションを生む。

**MVP スコープ：** 韓国語（지우キャラ）/ Gemini 1.5 Flash（無料枠）/ Next.js 14 + Supabase / Stripe課金

---

## Requirements

### Requirement 1: ユーザー認証・アカウント管理

**Objective:** 言語学習者として、手間なくアカウントを作成・管理できること。学習データが永続化され、どのデバイスからでも継続できる。

#### Acceptance Criteria

1. When ユーザーが「Googleでログイン」ボタンをタップした場合, the RizzLang shall Supabase Auth を通じてGoogle OAuthフローを開始し、認証完了後にホーム画面へリダイレクトする
2. When ユーザーが「Appleでログイン」ボタンをタップした場合, the RizzLang shall Apple Sign In フローを開始し、認証完了後にホーム画面へリダイレクトする
3. When 初回ログインが完了した場合, the RizzLang shall `users` テーブルに新規レコードを作成し、plan=free、streak=0 で初期化する
4. If 認証トークンの有効期限が切れた場合, the RizzLang shall Supabase のリフレッシュトークンで自動更新し、ユーザーに再ログインを求めない
5. The RizzLang shall すべてのAPIエンドポイントに対してSupabase RLSポリシーを適用し、他ユーザーのデータへのアクセスを禁止する

---

### Requirement 2: オンボーディングフロー

**Objective:** 新規ユーザーとして、アカウント作成前にアプリの価値（Gotchaモーメント）を体験できること。体験後に自然な流れでサインアップする。

#### Acceptance Criteria

1. When 未認証ユーザーがアプリにアクセスした場合, the RizzLang shall ログイン画面ではなく지우からの最初のメッセージを含むデモ画面を表示する
2. When 未認証ユーザーがデモ画面で日本語テキストを入力して送信した場合, the RizzLang shall Gemini APIを呼び出して韓国語返信・理由・スラング解説を生成し表示する（アカウント不要）
3. When 未認証ユーザーが2回目の返信を試みた場合, the RizzLang shall 「続けるにはアカウントが必要です」というモーダルを表示し、Google/Apple ログインボタンを提示する
4. When オンボーディング中にユーザー名（지우から呼ばれる呼称）を設定する場合, the RizzLang shall「오빠 / 자기야 / ユーザー設定名」の3つから選択させる
5. While オンボーディングが完了していない場合, the RizzLang shall シナリオDay 1のシーンから開始し、進捗をDay 0として保存する

---

### Requirement 3: AIチャット生成（コア機能）

**Objective:** 学習者として、日本語で「言いたいこと」を入力するだけで、自然な韓国語返信と学習解説が即座に得られること。

#### Acceptance Criteria

1. When ユーザーが日本語テキストを入力して「変換」ボタンを押した場合, the RizzLang shall Gemini 1.5 Flash API に対してキャラクタープロンプト・会話履歴・ユーザーレベルを含むリクエストを送信する
2. When Gemini APIのレスポンスが返った場合, the RizzLang shall `reply`（韓国語返信）・`why`（30文字以内の理由）・`slang`（スラング解説リスト）・`nextMessage`（地우の次のセリフ）の4フィールドをJSON形式でパースして表示する
3. While APIリクエストが処理中の場合, the RizzLang shall ローディングアニメーション（ドット3つの点滅）を表示し、ユーザーの追加入力を無効化する
4. If Gemini APIがエラーを返した場合, the RizzLang shall 3回までリトライし、それでも失敗した場合は「少し時間をおいてもう一度試してください」というエラーメッセージを日本語で表示する
5. The RizzLang shall 直近10往復の会話メッセージをAPIコンテキストに含め、会話の文脈を保持する
6. The RizzLang shall すべてのAI生成ロジックをサーバーサイド（Next.js API Route / Server Action）で実行し、APIキーをクライアントに露出しない
7. When ユーザーが生成された韓国語返信を「送信」した場合, the RizzLang shall そのメッセージを会話履歴に追加し、地우の`nextMessage`を地우のメッセージとして表示する

---

### Requirement 4: シナリオシステム

**Objective:** 学習者として、毎日K-drama的なストーリーの続きを体験できること。前日からの文脈があり、感情が動くシーンが展開される。

#### Acceptance Criteria

1. When ユーザーがアプリを開いた場合, the RizzLang shall `user_scenario_progress` から現在のseason・week・dayを読み取り、対応するシナリオテンプレートを`scenario_templates`から取得する
2. When シナリオテンプレートが取得された場合, the RizzLang shall ユーザーの現在レベル（1-4）に対応するメッセージバリエーションを`opening_message`JSONから選択して地우のメッセージとして表示する
3. When 現在のday = 7かつweekのシナリオが完了した場合, the RizzLang shall 翌アクセス時にweekを+1してday=1にリセットし、次のweekのシナリオに進める
4. The RizzLang shall 時間帯（morning: 5-11時 / afternoon: 11-17時 / evening: 17-21時 / night: 21-5時）に応じて`opening_message`のトーンを調整するプロンプトパラメータを渡す
5. When ユーザーが当日すでにセッションを開始している場合, the RizzLang shall 新しいシナリオではなく当日のチャット履歴を継続表示する（1日1シーン固定）
6. Where シナリオタイプが「Tension」の場合, the RizzLang shall 摩擦→仲直りの2フェーズを持つ特別なシーケンスを実行し、仲直り完了時に「関係値+1」のアニメーションを表示する

---

### Requirement 5: 難易度自動変動システム

**Objective:** 学習者として、自分のレベルに合った韓国語で地우と会話できること。上達するにつれて自然に難易度が上がる。

#### Acceptance Criteria

1. The RizzLang shall ユーザーのレベルをLevel 1（初級）〜Level 4（上級）で管理し、`users.current_level`に保存する
2. When ユーザーが7日間で「編集なし送信率 > 80%」かつ「1回あたりのリトライ数 < 0.5」の場合, the RizzLang shall 自動的にcurrent_levelを+1する（上限: Level 4）
3. When ユーザーが7日間で「編集なし送信率 < 40%」または「1回あたりのリトライ数 > 2」の場合, the RizzLang shall 自動的にcurrent_levelを-1する（下限: Level 1）
4. When AIリクエストを送信する場合, the RizzLang shall System Promptに`難易度レベル: {level}`パラメータを含め、地우のメッセージ複雑度を自動調整させる
5. The RizzLang shall 各往復ごとに`usage_logs.edit_count`と`usage_logs.retry_count`を記録し、レベル計算に使用する

---

### Requirement 6: 語彙帳・学習記録

**Objective:** 学習者として、会話で出てきた表現が自動的に蓄積され、後から復習できること。

#### Acceptance Criteria

1. When AI返信が生成された場合, the RizzLang shall `slang`フィールドに含まれる単語・意味・例文を`vocabulary`テーブルに自動保存する（重複はupsert）
2. When `why`フィールドに学習表現が含まれる場合, the RizzLang shall その表現も語彙帳に追加する
3. When ユーザーが語彙帳タブを開いた場合, the RizzLang shall 習得済み語彙を「最近学んだ順」でリスト表示し、単語・意味・習得日を表示する
4. The RizzLang shall SRS（間隔反復）アルゴリズムに基づき`next_review`日時を計算して保存する（初回: 翌日、2回目: 3日後、3回目: 7日後、以降倍増）
5. When セッション終了時, the RizzLang shall 「今日 +{n}表現を習得しました」というサマリーカードをアニメーション付きで表示する

---

### Requirement 7: ストリーク・進捗可視化

**Objective:** 学習者として、毎日継続できているかを視覚的に確認でき、継続のモチベーションが生まれること。

#### Acceptance Criteria

1. When ユーザーが当日初めてチャットセッションを開始した場合, the RizzLang shall `users.streak`を+1し、`users.last_active`を今日の日付に更新する
2. If ユーザーが昨日アクセスしていなかった場合（`last_active < today - 1日`）, the RizzLang shall `users.streak`を0にリセットする
3. The RizzLang shall チャット画面上部にストリーク日数（🔥 N日連続）と当日のXP獲得状況（進捗バー）を常時表示する
4. When ストリークが7・30・100日の節目に達した場合, the RizzLang shall 特別なアニメーション（紙吹雪等）と「{N}日達成！」メッセージを表示する
5. The RizzLang shall 週次で「今週 +{n}表現 / {n}日連続」のサマリーを生成し、ホーム画面に表示する

---

### Requirement 8: フリーミアム課金（Stripe）

**Objective:** ユーザーとして、無料で価値を体験でき、続けたいと思ったときにProプランにアップグレードできること。

#### Acceptance Criteria

1. While ユーザーのplan = freeの場合, the RizzLang shall 1日あたり3往復を超えた時点でペイウォール画面を表示し、それ以上のチャット送信を無効化する
2. When ペイウォール画面が表示された場合, the RizzLang shall 「지우がもっと話したそうにしています...」というコピーとProプランの料金（¥1,480/月）を表示する
3. When ユーザーが「Proにアップグレード」ボタンを押した場合, the RizzLang shall Stripe Checkout セッションを生成してリダイレクトする
4. When Stripe の `checkout.session.completed` Webhookを受信した場合, the RizzLang shall 対象ユーザーの`users.plan`を`pro`に更新し、往復制限を解除する
5. When Stripe の `customer.subscription.deleted` Webhookを受信した場合, the RizzLang shall `users.plan`を`free`に戻し、次の往復から制限を再適用する
6. Where ユーザーのplan = proの場合, the RizzLang shall 往復数制限なし・全難易度シナリオ・語彙SRS復習モードを提供する

---

### Requirement 9: Web Push通知

**Objective:** 学習者として、毎日の学習を忘れないよう、地우からのメッセージ到着通知をブラウザで受け取れること。

#### Acceptance Criteria

1. When ユーザーが初回セッションを開始した場合, the RizzLang shall ブラウザのWeb Push通知許可ダイアログを表示する
2. When ユーザーが通知を許可した場合, the RizzLang shall Push Subscription を Supabase に保存する
3. When 前日にアクセスがあったユーザーが翌日の指定時刻（デフォルト: 9:00 JST）までアクセスしていない場合, the RizzLang shall 「지우からメッセージが届いています 🥺」という通知を送信する
4. If ユーザーが通知をクリックした場合, the RizzLang shall アプリの当日チャット画面を直接開く
5. The RizzLang shall 通知頻度を1日1回に制限し、ユーザーが通知設定で無効化できるようにする

---

### Requirement 10: セキュリティ・パフォーマンス

**Objective:** サービスとして、ユーザーデータを保護し、快適なレスポンスタイムを維持すること。

#### Acceptance Criteria

1. The RizzLang shall Gemini APIキー・Stripe Secretキー・Supabase Service Keyをサーバーサイド環境変数（`.env.local`）にのみ保存し、クライアントバンドルに含めない
2. When API Routeがリクエストを受信した場合, the RizzLang shall Supabase Auth で認証状態を検証し、未認証リクエストを401で拒否する
3. The RizzLang shall Gemini APIへの1ユーザーあたりのリクエストを1分あたり10回に制限し、超過時は429エラーを返す（Supabase RLSまたはRedis）
4. The RizzLang shall AI返信生成のレスポンスタイムを3秒以内（P95）に維持する
5. The RizzLang shall Next.js Image Optimization と Vercel Edge Networkを活用し、初回ページロードを2秒以内（LCP）に収める

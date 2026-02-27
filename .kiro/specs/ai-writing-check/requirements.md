# Requirements — AI 添削モード（Writing Check）

## Introduction

ユーザーが外国語を「直接書いて」AI にスコア付き添削してもらう機能。
Duolingo にない「自分の言葉で書いて学ぶ」体験を提供し、学習効果とリテンションを両立する。

**優先度:** 🔴 最高（競合との最大差別化）

---

## Requirements

### Requirement 1: 添削モードのトグル

**Objective:** チャットユーザーとして、通常モードと添削モードを簡単に切り替えられること。

#### Acceptance Criteria

1. When ユーザーがチャット画面の入力エリア右側の 📝 アイコンをタップした場合, RizzLang shall 入力フォームのヒントを「外国語で直接書いてみよう」に切り替え、送信ボタンを「📝 添削」に変更する
2. When 添削モードがオンの場合, RizzLang shall 入力フォームの枠をオレンジ色にして視覚的にモードを区別する
3. When 添削モードをもう一度タップした場合, RizzLang shall 通常モード（日本語入力モード）に戻す
4. The RizzLang shall 添削モードの状態をセッション中は保持し、画面遷移後に通常モードにリセットする

---

### Requirement 2: 添削リクエストの送信と結果表示

**Objective:** 言語学習者として、外国語で書いた文を送信すると即座にAIから添削フィードバックをもらえること。

#### Acceptance Criteria

1. When 添削モードでユーザーが外国語テキストを送信した場合, RizzLang shall `check-writing` Edge Function を呼び出し、corrected / errors / score / praise / tip の5フィールドを含む JSON を取得する
2. When 添削結果が返ってきた場合, RizzLang shall ReplyPanel の上に `WritingCheckPanel` を表示し、スコア・添削後テキスト・エラー箇所・称賛・tip を視覚的に表示する
3. When スコアが 90以上の場合, RizzLang shall スコアバッジを緑色で表示し「ほぼネイティブ！」と表示する
4. When スコアが 70〜89の場合, RizzLang shall スコアバッジを黄色で表示する
5. When スコアが 69以下の場合, RizzLang shall スコアバッジをオレンジ色で表示し「もう少し！」と表示する
6. If `check-writing` の呼び出しが失敗した場合, RizzLang shall 「添削できませんでした。もう一度試してください。」エラーメッセージを表示し、通常モードにフォールバックする

---

### Requirement 3: 添削結果の詳細表示

**Objective:** 学習者として、どこが間違っていたか・なぜ間違いか を理解できること。

#### Acceptance Criteria

1. When `errors` 配列が1件以上の場合, RizzLang shall 各エラーを「元の表現 → 正しい表現」の形式と20文字以内の日本語解説で表示する
2. When `errors` 配列が空の場合, RizzLang shall 「エラーなし！完璧です 🎉」と表示する
3. The RizzLang shall `praise` フィールドをグリーン色のテキストで表示し、学習者を常にポジティブに称賛する
4. The RizzLang shall `tip` フィールドを 💡 アイコン付きで表示し、次回に活かせる一言アドバイスとする

---

### Requirement 4: 利用制限

**Objective:** コスト管理のため、添削機能の利用に適切な制限を設ける。

#### Acceptance Criteria

1. The RizzLang shall Free ユーザーに対して1日あたり添削リクエストを 5回 まで許可する
2. The RizzLang shall Pro ユーザーに対して添削リクエストを無制限とする
3. When Free ユーザーが上限に達した場合, RizzLang shall ペイウォールシートを表示し「Pro で無制限に添削できます」というメッセージを表示する
4. The RizzLang shall 添削利用回数を `usage_logs` テーブルに記録し、日付ごとに集計する

---

## Out of Scope

- 音声入力からの添削（Phase 3）
- 添削履歴の永続保存・後から見返す（Phase 2）
- 写真から文字認識して添削（将来）

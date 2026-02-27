# Requirements — AI 弱点フォーカス復習（Weakness Review）

## Introduction

SM-2 スケジューリングデータを分析し、ユーザーが「今日復習すべき語彙」を会話の中に自然に埋め込む機能。
フラッシュカードで暗記するより、文脈の中で出てきた語彙の方が記憶定着率が高い。

**優先度:** 🟡 中（SM-2 × 会話学習のシナジー）

---

## Requirements

### Requirement 1: 復習タイミングの検出

#### Acceptance Criteria

1. When `generate-reply` が呼ばれた場合, RizzLang shall そのユーザーの当日 SM-2 復習予定語彙（`next_review_at <= now()`）を最大3件取得する
2. The RizzLang shall 復習語彙の中でも `easiness_factor` が低い（覚えにくい）ものを優先して選択する
3. When 復習対象語彙が0件の場合, RizzLang shall 通常の会話生成を行う（フォールバック）

---

### Requirement 2: 会話への自然な埋め込み

#### Acceptance Criteria

1. When 復習対象語彙がある場合, RizzLang shall システムプロンプトに「以下の語彙を会話に自然に盛り込んでください」と指示を追加する
2. The RizzLang shall 埋め込む語彙は必ず文脈に合った形で使用する（無理やり挿入はしない）
3. When キャラクターが復習対象語彙を使った場合, RizzLang shall `slang` 配列にその語彙の解説を含める（ユーザーが意識的に学べるよう）

---

### Requirement 3: 復習完了の記録

#### Acceptance Criteria

1. When ユーザーが復習対象語彙を含む会話に正常に返信した場合, RizzLang shall その語彙の `last_reviewed_at` を更新し SM-2 スケジュールを進める
2. The RizzLang shall 「会話で自然に復習した」場合の SM-2 評価グレードを 3（わかった！）相当として処理する

---

### Requirement 4: 弱点レポート表示

#### Acceptance Criteria

1. The RizzLang shall 語彙帳画面に「今日の復習」タブを追加し、本日復習すべき語彙を一覧表示する
2. The RizzLang shall 「会話で復習済み」のバッジを表示し、フラッシュカードと会話学習の両方での進捗を可視化する

---

## Out of Scope

- 発音の弱点検出（Phase 4）
- 文法の弱点パターン分析（Phase 4）

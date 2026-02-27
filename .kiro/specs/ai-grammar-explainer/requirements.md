# Requirements — AI 文法詳細解説（Grammar Deep-Dive）

## Introduction

会話中のキャラクター返信に含まれる文法ポイントを、ユーザーが「詳しく解説」ボタン1タップで深掘りできる機能。
既存の `why`（30文字解説）を超える、例文付き・パターン付きの本格解説を提供する。

**優先度:** 🔴 最高（学習深度の向上・差別化）

---

## Requirements

### Requirement 1: 「詳しく解説」ボタン

**Objective:** 学習者として、気になった文法ポイントをワンタップで深掘りできること。

#### Acceptance Criteria

1. When AI からの返信が表示され ReplyPanel が開いている場合, RizzLang shall `why` テキストの横に「詳しく解説 →」テキストボタンを表示する
2. When ユーザーが「詳しく解説 →」をタップした場合, RizzLang shall `GrammarExplainSheet` をボトムシートで表示する
3. The RizzLang shall 「詳しく解説」ボタンは Pro ユーザー・Free ユーザー問わず利用可能とする（ただし1日5回まで）

---

### Requirement 2: 文法解説コンテンツの生成と表示

**Objective:** 学習者として、文法の名称・詳細な説明・例文・パターンを一度に理解できること。

#### Acceptance Criteria

1. When `GrammarExplainSheet` が表示されたとき, RizzLang shall `explain-grammar` Edge Function を呼び出し、ローディングスピナーを表示する
2. When 解説データが返ってきた場合, RizzLang shall 以下の情報を順番に表示する:
   - `title`: 文法名（例：「보고 싶다 構文」）
   - `level`: レベルバッジ（初級/中級/上級）
   - `pattern`: 基本形（例：`Verb + 고 싶다`）
   - `explanation`: 詳細解説（150文字以内・日本語）
   - `examples`: 例文3つ（外国語 + 日本語訳）
3. When `explain-grammar` の呼び出しが失敗した場合, RizzLang shall 「解説を読み込めませんでした」とエラーメッセージを表示し、閉じるボタンを提供する
4. The RizzLang shall ボトムシートを下スワイプで閉じられるようにする

---

### Requirement 3: 解説の品質要件

**Objective:** 文法解説が学習者にとって実用的で理解しやすいものであること。

#### Acceptance Criteria

1. The RizzLang shall `explanation` は必ず日本語で、文法の核心を150文字以内で伝える
2. The RizzLang shall `examples` は会話で実際に使える自然な例文3つとし、各例文に日本語訳を付ける
3. The RizzLang shall `level` は TOPIK / CEFR 相当の基準で初級（A1-A2）/中級（B1-B2）/上級（C1-C2）の3段階で判定する
4. The RizzLang shall `pattern` は変数を `{}` で表記する（例: `{名詞}이/가 좋다`）

---

## Out of Scope

- 解説の保存・後から見返す機能（Phase 2）
- 文法のクイズ / 練習問題生成（Phase 3）
- 複数文法の比較解説（Phase 3）

# Requirements — AI 発音ガイド（Pronunciation Guide）

## Introduction

外国語メッセージをタップすると、ローマ字読み（Romanization）またはカタカナ読みがポップオーバー表示される機能。
TTS（音声）の補完として「目で読み方を確認」できる手段を提供する。

**優先度:** 🟡 中（Vietnamese・Arabic 学習者に特に必要）

---

## Requirements

### Requirement 1: ポップオーバー表示

#### Acceptance Criteria

1. When ユーザーがキャラクターのメッセージバブルをロングタップした場合, RizzLang shall メッセージの上部にポップオーバーを表示する
2. The RizzLang shall ポップオーバーに以下の情報を表示する:
   - ローマ字読み（Romanization）
   - カタカナ読み近似（日本語話者向け）
3. When ユーザーがポップオーバー外をタップした場合, RizzLang shall ポップオーバーを閉じる

---

### Requirement 2: 言語別変換方式

#### Acceptance Criteria

1. When アクティブ言語が Korean (`ko`) の場合, RizzLang shall Revised Romanization of Korean（RR方式）でローマ字変換を行い、カタカナ読みも表示する（例: 보고 싶어 → "bogo sipeo" / "ポゴシポ"）
2. When アクティブ言語が English (`en`) の場合, RizzLang shall IPA 表記と日本語カタカナ近似を表示する（例: "babe" → /beɪb/ / "ベイブ"）
3. When アクティブ言語が Turkish (`tr`) の場合, RizzLang shall トルコ語ラテン文字はそのままで声調ガイドを表示する
4. When アクティブ言語が Vietnamese (`vi`) の場合, RizzLang shall 声調記号の読み方ガイドを表示する（6声調のポップアップ解説）
5. When アクティブ言語が Arabic (`ar`) の場合, RizzLang shall Buckwalter Transliteration でローマ字化し、カタカナ近似も表示する

---

### Requirement 3: 単語単位のタップ

#### Acceptance Criteria

1. The RizzLang shall メッセージ内の各単語をタップ可能なスパンとして表示する（Word-level tap）
2. When ユーザーが特定の単語をタップした場合, RizzLang shall その単語のみの発音ガイドを表示する
3. When ユーザーが単語を長タップした場合, RizzLang shall 「語彙帳に追加」オプションを表示する

---

## Out of Scope

- 発音評価（マイクで録音して採点）— Phase 4
- IPA 詳細解説（Phase 3）
- オフライン変換テーブル全言語対応（Phase 3）

# Design — AI 文法詳細解説（Grammar Deep-Dive）

## Overview

ReplyPanel → GrammarExplainSheet → explain-grammar Edge Function の3レイヤー。
既存の `why` フィールドを「入口」として、Gemini に同じフレーズの詳細解説を追加生成させる。

---

## Architecture

```
[ReplyPanel]
  └── 「詳しく解説 →」ボタン
        └── [GrammarExplainSheet] (BottomSheet)
              └── AIService.explainGrammar()
                    └── Supabase Functions.invoke('explain-grammar')
                          └── Gemini 1.5 Flash
```

---

## Edge Function: `explain-grammar`

**ファイル:** `supabase/functions/explain-grammar/index.ts`

### リクエスト

```typescript
{
  phrase: string,    // 解説対象のフレーズ（例: "보고 싶어"）
  why: string,       // 既存の30文字解説（コンテキスト補正用）
  language: string   // 'ko' | 'en' | 'tr' | 'vi' | 'ar'
}
```

### レスポンス

```typescript
{
  title: string,           // 文法名（例: "보고 싶다 — 〜したい構文"）
  level: '初級' | '中級' | '上級',
  pattern: string,         // 基本形（例: "Verb + 고 싶다"）
  explanation: string,     // 詳細解説（150文字以内・日本語）
  examples: Array<{
    foreign: string,       // 外国語の例文
    japanese: string       // 日本語訳
  }>
}
```

### Gemini プロンプト

```
あなたは${languageName}の文法専門家です。
以下のフレーズの文法を詳しく解説してください。

フレーズ: "${phrase}"
基本説明: "${why}"

以下のJSONのみを返す（説明は日本語で）:
{
  "title": "文法名（20文字以内）",
  "level": "初級 or 中級 or 上級",
  "pattern": "基本形（変数は{}で）",
  "explanation": "詳細解説（150文字以内・日本語）",
  "examples": [
    {"foreign": "例文1", "japanese": "訳1"},
    {"foreign": "例文2", "japanese": "訳2"},
    {"foreign": "例文3", "japanese": "訳3"}
  ]
}
```

---

## Flutter: AIService

```dart
class GrammarExplanation {
  final String title;
  final String level;          // '初級' | '中級' | '上級'
  final String pattern;
  final String explanation;
  final List<GrammarExample> examples;
}

class GrammarExample {
  final String foreign;
  final String japanese;
}

Future<GrammarExplanation> explainGrammar({
  required String phrase,
  required String why,
  required String language,
}) async {
  final response = await _supabase.functions.invoke(
    'explain-grammar',
    body: {'phrase': phrase, 'why': why, 'language': language},
  );
  return GrammarExplanation.fromJson(response.data);
}
```

---

## Flutter: GrammarExplainSheet UI

```
┌─────────────────────────────────────────────────┐
│ ─── (ドラッグハンドル)                             │
│                                                 │
│  보고 싶다 — 〜したい構文          [中級]          │
│                                                 │
│  📐 基本形                                       │
│  Verb + 고 싶다                                  │
│                                                 │
│  📖 解説                                        │
│  「〜したい」という願望を表す構文。動詞の語幹に고 싶   │
│  다を続けることで使える。日常会話で最も頻出する表現。  │
│                                                 │
│  💬 例文                                        │
│  ① 밥 먹고 싶어  — ご飯食べたい                   │
│  ② 자고 싶어     — 眠りたい                       │
│  ③ 오빠 보고 싶어 — オッパに会いたい               │
└─────────────────────────────────────────────────┘
```

**レベルバッジ色分け:**
- 初級: `Colors.green`
- 中級: `Colors.amber`
- 上級: `Colors.red`

---

## 非機能要件

- レスポンスタイム: P95 < 3秒
- コスト: 約 400 tokens / リクエスト = ¥0.00006 / 解説
- キャッシュ: 同一フレーズの解説結果を `Map<String, GrammarExplanation>` でメモリキャッシュ（セッション中有効）

# Design — AI 発音ガイド（Pronunciation Guide）

## Overview

クライアントサイドのルールベース変換（サーバーコスト0）で大部分をカバーする。
難易度の高い言語（Arabic・Vietnamese）のみ Gemini にフォールバック。

---

## 変換エンジン設計

```
言語     | 方式                              | 実装
---------|-----------------------------------|---------
Korean   | Revised Romanization (RR)         | ルールベース（Dart）
English  | IPA / カタカナ近似                | 辞書テーブル（頻出単語）
Turkish  | Latin基底 → 発音ルール             | ルールベース（Dart）
Vietnamese | Unicode声調記号 → ガイド         | ルールベース（声調マッピング）
Arabic   | Buckwalter Transliteration        | Gemini フォールバック（複雑）
```

---

## Korean Romanization エンジン

**ファイル:** `lib/core/utils/korean_romanizer.dart`

```dart
// Revised Romanization of Korean
// ハングル Unicode → ローマ字変換テーブル

class KoreanRomanizer {
  static String romanize(String hangul) {
    // 初声 (초성) × 中声 (중성) × 終声 (종성) の分解
    // Unicode: 가 = 0xAC00, 각 글자 = 초성*21*28 + 중성*28 + 종성
    // 変換テーブルに従って組み立て
    ...
  }

  static String toKatakana(String hangul) {
    // カタカナ近似変換
    // 例: 보 → ポ, 고 → ゴ, 싶어 → シポ
    ...
  }
}
```

---

## MessageBubble への統合

**ファイル:** `lib/features/chat/widgets/message_bubble.dart`

```dart
// キャラクターのメッセージを SelectableText → RichText + InkWell に変更
// 各単語をタップ可能なスパンに分割

GestureDetector(
  onLongPress: () => _showPronunciationPopover(context, message.content),
  child: RichText(
    text: TextSpan(
      children: message.content
        .split(' ')
        .map((word) => WidgetSpan(
          child: GestureDetector(
            onTap: () => _showWordPopover(context, word),
            onLongPress: () => _showWordMenu(context, word),
            child: Text(word + ' '),
          ),
        ))
        .toList(),
    ),
  ),
)
```

---

## PronunciationPopover UI

```
┌─────────────────────────────────────────┐
│ 보고 싶어                                 │
│ Romanization:  bogo sipeo               │
│ カタカナ:       ポゴ シポ                  │
│                              [🔊 再生]  │
└─────────────────────────────────────────┘
```

Vietnamese の場合（声調ガイド付き）:
```
┌─────────────────────────────────────────┐
│ Em nhớ anh lắm                          │
│ Romanization:  em nho anh lam           │
│ 声調:          nhớ (下降調) / lắm (上昇) │
│ カタカナ:       エム ニョー アン ラーム    │
└─────────────────────────────────────────┘
```

---

## 非機能要件

- 変換速度: < 50ms（ルールベース、サーバー不要）
- サーバーコスト: $0（Arabic のみ Gemini: 約 100 tokens / タップ）
- オフライン動作: Korean/English/Turkish/Vietnamese は完全オフライン
- 推定工数: 6〜8時間（Korean ルールベースが最大作業）

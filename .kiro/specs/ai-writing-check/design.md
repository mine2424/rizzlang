# Design — AI 添削モード（Writing Check）

## Overview

外国語の直書き → AI スコア付き添削のフル実装設計。
`check-writing` Edge Function（Gemini 1.5 Flash）→ Flutter `WritingCheckPanel` UI の2レイヤー構造。

---

## Architecture

```
[ChatScreen]
  ├── 通常モード: generateReply() → ReplyPanel
  └── 添削モード: checkWriting() → WritingCheckPanel
        └── AIService.checkWriting()
              └── Supabase Functions.invoke('check-writing')
                    └── Gemini 1.5 Flash (添削プロンプト)
```

---

## Edge Function: `check-writing`

**ファイル:** `supabase/functions/check-writing/index.ts`

### リクエスト

```typescript
{
  userText: string,      // ユーザーが書いた外国語テキスト
  language: string,      // 対象言語コード ('ko' | 'en' | 'tr' | 'vi' | 'ar')
  contextMessage?: string // 直前のキャラクターメッセージ（文脈補正用）
}
```

### レスポンス

```typescript
{
  corrected: string,             // 自然な修正後テキスト
  errors: Array<{
    original: string,            // 間違いの部分
    corrected: string,           // 正しい形
    explanation: string          // 理由（日本語 20文字以内）
  }>,
  score: number,                 // 0〜100
  praise: string,                // 良かった点（日本語・励まし）
  tip: string                    // 一言アドバイス（日本語 20文字以内）
}
```

### Gemini プロンプト設計

```
あなたは${languageName}の語学コーチです。
ユーザーが${languageName}で書いた文を添削し、以下のJSONのみを返してください。

ユーザーの文: "${userText}"
${context ? `直前の文脈: "${contextMessage}"` : ''}

採点基準:
- 文法の正確さ: 50点
- 自然さ・流暢さ: 30点
- 文脈への適切さ: 20点

{"corrected":"...","errors":[{"original":"...","corrected":"...","explanation":"..."}],"score":85,"praise":"...","tip":"..."}
```

### 認証 / レート制限

```typescript
// auth.ts 共通ミドルウェア
const { userId, plan } = await verifyAuth(req)
const dailyLimit = plan === 'pro' ? Infinity : 5
await checkRateLimit(userId, 'writing_check', dailyLimit)
```

---

## Flutter: AIService

**ファイル:** `lib/core/services/ai_service.dart`

```dart
// ── モデル ──
class WritingCheckResult {
  final String corrected;
  final List<WritingError> errors;
  final int score;
  final String praise;
  final String tip;
}

class WritingError {
  final String original;
  final String corrected;
  final String explanation;
}

// ── メソッド ──
Future<WritingCheckResult> checkWriting({
  required String userText,
  required String language,
  String? contextMessage,
}) async {
  final response = await _supabase.functions.invoke(
    'check-writing',
    body: {
      'userText': userText,
      'language': language,
      if (contextMessage != null) 'contextMessage': contextMessage,
    },
  );
  return WritingCheckResult.fromJson(response.data);
}
```

---

## Flutter: ChatScreen — 添削モードトグル

**ファイル:** `lib/features/chat/screens/chat_screen.dart`

```dart
bool _isCheckMode = false;

// 入力エリアの変更点:
// - ヒントテキスト: _isCheckMode ? '外国語で直接書いてみよう' : 'オッパに伝えたいことを...'
// - 送信ボタン: _isCheckMode ? '📝 添削' : '→'
// - 枠色: _isCheckMode ? Colors.orange : AppTheme.primary
// - onSend: _isCheckMode ? _onCheckWriting() : _onSendMessage()

Future<void> _onCheckWriting() async {
  final text = _controller.text.trim();
  if (text.isEmpty) return;
  final character = ref.read(activeCharacterProvider);
  final lastMsg = state.messages.lastOrNull;
  final result = await ref.read(aiServiceProvider).checkWriting(
    userText: text,
    language: character?.language ?? 'ko',
    contextMessage: lastMsg?.content,
  );
  setState(() => _writingCheckResult = result);
}
```

---

## Flutter: WritingCheckPanel

**ファイル:** `lib/features/chat/widgets/writing_check_panel.dart`

```
┌─────────────────────────────────────────────┐
│ 📝 添削結果                        スコア [85] │  ← スコアバッジ（色分け）
├─────────────────────────────────────────────┤
│ ✅  나 오빠 보고 싶어                          │  ← corrected（太字・メイン）
│                                             │
│  ⚠  보고십어 → 보고 싶어                      │  ← error row（オレンジ）
│     띄어쓰기が必要                             │
│                                             │
│  💪  助詞の使い方が上手！                      │  ← praise（グリーン）
│  💡  간격에 주의해봐                          │  ← tip（アイコン付き）
└─────────────────────────────────────────────┘
```

**スコア色分け:**
- 90〜100: `Colors.green` — "ほぼネイティブ！"
- 70〜89: `Colors.amber` — （ラベルなし）
- 0〜69: `Colors.orange` — "もう少し！"

---

## データ設計

`usage_logs` テーブル（既存）に `event_type = 'writing_check'` で記録:

```sql
INSERT INTO usage_logs (user_id, event_type, created_at)
VALUES (auth.uid(), 'writing_check', now());
```

---

## 非機能要件

- レスポンスタイム: P95 < 4秒（添削は通常返信より複雑なため許容幅広め）
- コスト: 約 500 tokens / リクエスト × ¥0.00015 = 約 ¥0.00008 / 添削
- エラー時のフォールバック: 通常モードに自動切り替え

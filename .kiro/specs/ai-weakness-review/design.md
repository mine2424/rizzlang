# Design — AI 弱点フォーカス復習（Weakness Review）

## Overview

`vocabulary` テーブルの SM-2 データを読んで、当日復習すべき語彙を `generate-reply` のシステムプロンプトに注入する。
サーバー追加コストほぼ0（語彙取得 DB クエリのみ追加）。

---

## generate-reply への弱点注入

**ファイル:** `supabase/functions/generate-reply/index.ts`

```typescript
// Step 1: 今日の復習対象語彙を取得（最大3件）
const reviewWords = await supabase
  .from('user_vocabulary')
  .select('word, meaning, easiness_factor')
  .eq('user_id', userId)
  .eq('character_id', characterId)
  .lte('next_review_at', new Date().toISOString())
  .order('easiness_factor', { ascending: true })  // 苦手なものを優先
  .limit(3)

// Step 2: システムプロンプトに追加
const weaknessBlock = reviewWords.length > 0
  ? `
## 今日の復習語彙（会話に自然に含めてください）
${reviewWords.map(w => `- ${w.word}（意味: ${w.meaning}）`).join('\n')}

注意: 無理に全部使わなくてよいが、文脈に合う場合は必ず使うこと。
使った語彙は slang 配列に含め、ユーザーが気づけるようにすること。
`
  : ''
```

---

## DB クエリ最適化

```sql
-- 既存の user_vocabulary インデックスに追加
CREATE INDEX ON user_vocabulary(user_id, character_id, next_review_at)
WHERE next_review_at IS NOT NULL;
```

---

## Flutter: 語彙帳 「今日の復習」タブ

**ファイル:** `lib/features/vocabulary/screens/vocabulary_screen.dart`

```dart
// TabBar に「今日の復習」タブ追加
TabBar(tabs: [
  Tab(text: '全て'),
  Tab(text: '今日の復習'),  // NEW
  Tab(text: '習得済み'),
])

// todayReviewProvider
final todayReviewProvider = FutureProvider<List<VocabularyModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser!.id;
  return supabase
    .from('user_vocabulary')
    .select()
    .eq('user_id', userId)
    .lte('next_review_at', DateTime.now().toIso8601String())
    .order('easiness_factor');
});
```

---

## 復習完了マーキング

会話返信後に `generate-reply` のレスポンスに `reviewedWords` フィールドを追加:

```typescript
// generate-reply レスポンスに追加
{
  ...,
  reviewedWords: string[]  // 今回の会話で使われた復習語彙リスト
}
```

Flutter 側で `reviewedWords` を受け取り SM-2 更新:

```dart
// chat_provider.dart
if (reply.reviewedWords.isNotEmpty) {
  for (final word in reply.reviewedWords) {
    await ref.read(vocabularyProvider.notifier)
      .reviewWord(word, grade: 3);  // 会話で出てきた = grade 3
  }
}
```

---

## 非機能要件

- 追加 DB クエリ: 1回（generate-reply 内）
- 追加コスト: ほぼ0（プロンプトトークン数が 50〜100 増加するのみ）
- 推定工数: 3〜4時間

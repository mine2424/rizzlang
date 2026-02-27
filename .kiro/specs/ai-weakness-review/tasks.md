# Tasks — AI 弱点フォーカス復習（Weakness Review）

## ステータス: ✅ 実装済み（2026-02-28）

---

### Backend

- [x] 1. `generate-reply` に弱点語彙取得ロジック追加
  - [x] 1.1 `user_vocabulary` から `next_review_at <= now()` を最大3件取得
  - [x] 1.2 `easiness_factor` 昇順でソート（苦手なものを優先）
  - [x] 1.3 `buildSystemPrompt()` に弱点ブロックを注入
  - [x] 1.4 レスポンスに `reviewedWords: string[]` フィールドを追加

- [x] 2. `user_vocabulary` インデックス最適化
  - [x] `supabase/migrations/20260228_vocabulary_index.sql` 作成
  - [x] `CREATE INDEX ON user_vocabulary(user_id, character_id, next_review_at)`

### Flutter

- [x] 3. `chat_provider.dart` — `reviewedWords` 受け取り処理
  - [x] 3.1 返信データから `reviewedWords` を抽出
  - [x] 3.2 各語彙を grade=3 で SM-2 更新（`_reviewWord` メソッド）

- [x] 4. 語彙帳に「今日の復習」タブ追加
  - [x] 4.1 `todayReviewProvider` 作成（next_review_at フィルター）
  - [x] 4.2 タブ UI + 空状態（「今日の復習はありません 🎉」）
  - [x] 4.3 3タブ構成（全て / 今日の復習 / 習得済み）

- [x] 5. `GeneratedReply` モデルに `reviewedWords` フィールド追加
- [x] 6. `VocabularyNotifier.reviewWord()` メソッド追加

### 推定工数

- Backend: 2〜3時間
- Flutter: 2時間
- 合計: **4〜5時間**

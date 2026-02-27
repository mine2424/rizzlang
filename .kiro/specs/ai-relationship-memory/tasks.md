# Tasks — AI 関係値メモリ（Relationship Memory）

## ステータス: ⏳ 未実装（承認待ち）

---

### Backend

- [ ] 1. DB マイグレーション `relationship_memories` テーブル作成
  - [ ] 1.1 `supabase/migrations/20260228_relationship_memories.sql`
  - [ ] 1.2 RLS ポリシー設定（owner のみアクセス）
  - [ ] 1.3 インデックス追加（user_id + character_id + week_number）

- [ ] 2. `memory-generator` Edge Function 作成
  - [ ] 2.1 アクティブユーザー取得（過去7日に会話があったユーザー）
  - [ ] 2.2 会話履歴取得 + Gemini サマリー生成（キャラ視点・100文字）
  - [ ] 2.3 `emotional_weight` 自動判定（Tension シーン = +3）
  - [ ] 2.4 `relationship_memories` への upsert（同週の重複防止）

- [ ] 3. Supabase Cron 設定（毎週月曜 15:00 UTC = 月曜 0:00 JST）
  ```sql
  SELECT cron.schedule('memory-generator-weekly', '0 15 * * 1',
    $$SELECT net.http_post(...) $$);
  ```

- [ ] 4. `generate-reply` にメモリ注入処理を追加
  - [ ] 4.1 直近2週分の `relationship_memories` を取得
  - [ ] 4.2 `buildSystemPrompt()` にメモリブロックを注入
  - [ ] 4.3 プロンプト: 「30%の確率でさりげなく過去に言及」

### Flutter

- [ ] 5. `RelationshipMemory` モデル（Freezed）
- [ ] 6. `relationshipMemoriesProvider`（Supabase から取得）
- [ ] 7. 設定画面に「지우の記憶」タイル追加
- [ ] 8. `RelationshipMemoriesScreen` 作成
  - [ ] 8.1 週ごとのサマリーリスト表示
  - [ ] 8.2 削除機能（プライバシー配慮）
  - [ ] 8.3 空状態 UI（「まだ記憶がありません」）

### 推定工数

- Backend: 4〜6時間
- Flutter: 2〜3時間
- 合計: **6〜9時間**

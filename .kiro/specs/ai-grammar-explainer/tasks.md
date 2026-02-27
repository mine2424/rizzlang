# Tasks — AI 文法詳細解説（Grammar Deep-Dive）

## ステータス: ✅ 実装完了（2026-02-27）

---

- [x] 1. `explain-grammar` Edge Function
  - [x] 1.1 Gemini プロンプト（title/level/pattern/explanation/examples）
  - [x] 1.2 `verifyAuth()` + レート制限（1日5回）
  - [x] 1.3 言語別プロンプト（5言語対応）

- [x] 2. `GrammarExplanation` / `GrammarExample` モデル
- [x] 3. `AIService.explainGrammar()` メソッド

- [x] 4. ReplyPanel に「詳しく解説 →」ボタン追加
  - [x] 4.1 `why` テキスト横にテキストボタン配置
  - [x] 4.2 タップ → `GrammarExplainSheet` をボトムシートで表示

- [x] 5. `GrammarExplainSheet` ウィジェット
  - [x] 5.1 ドラッグハンドル + スクロール可能レイアウト
  - [x] 5.2 title + レベルバッジ（色分け）
  - [x] 5.3 pattern セクション（コードフォント）
  - [x] 5.4 explanation セクション
  - [x] 5.5 examples セクション（番号付き + 日本語訳）
  - [x] 5.6 ローディングスピナー + エラー表示

### 残タスク（Phase 2）

- [ ] 6. 解説のメモリキャッシュ（同一フレーズの再リクエスト防止）
- [ ] 7. 解説した文法をタグとして vocabulary に保存
- [ ] 8. 「この文法を練習する」ボタン → 添削モードで練習文を自動生成

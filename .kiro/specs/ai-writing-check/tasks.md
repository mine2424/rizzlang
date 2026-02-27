# Tasks — AI 添削モード（Writing Check）

## ステータス: ✅ 実装完了（2026-02-27）

---

### Backend

- [x] 1. `check-writing` Edge Function 作成
  - [x] 1.1 Gemini 1.5 Flash プロンプト（JSON強制出力）
  - [x] 1.2 `verifyAuth()` + `checkRateLimit()` (Free=5回/日, Pro=無制限)
  - [x] 1.3 レスポンス: corrected / errors / score / praise / tip
  - [x] 1.4 言語別プロンプト切り替え（ko/en/tr/vi/ar）

### Flutter — モデル / サービス

- [x] 2. `WritingCheckResult` + `WritingError` データクラス（Dart）
- [x] 3. `AIService.checkWriting()` メソッド追加
  - [x] 3.1 `check-writing` Edge Function invoke
  - [x] 3.2 JSON パース + エラーハンドリング

### Flutter — UI

- [x] 4. `ChatScreen` 添削モードトグル追加
  - [x] 4.1 📝 アイコンボタン → `_isCheckMode` 切り替え
  - [x] 4.2 入力フォーム: ヒント / ボタンラベル / 枠色の切り替え
  - [x] 4.3 送信時: `checkWriting()` を呼び出す `_onCheckWriting()`
- [x] 5. `WritingCheckPanel` ウィジェット作成
  - [x] 5.1 スコアバッジ（緑/黄/オレンジ 色分け）
  - [x] 5.2 添削後テキスト（太字）
  - [x] 5.3 エラー行リスト（original → corrected + explanation）
  - [x] 5.4 称賛テキスト（グリーン）
  - [x] 5.5 Tip（💡 アイコン）

### 残タスク（Phase 2）

- [ ] 6. 添削履歴の永続保存（conversations テーブルに `type=writing_check` で保存）
- [ ] 7. 添削結果から語彙を自動登録（vocabulary テーブルへ upsert）
- [ ] 8. Free ユーザー向け「今日あと N 回使えます」カウンター表示

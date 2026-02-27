# Tasks — AI 発音ガイド（Pronunciation Guide）

## ステータス: ⏳ 未実装（承認待ち）

---

### Core ライブラリ

- [ ] 1. `KoreanRomanizer` ユーティリティ（`lib/core/utils/korean_romanizer.dart`）
  - [ ] 1.1 ハングル Unicode 分解アルゴリズム（初声/中声/終声）
  - [ ] 1.2 RR方式ローマ字変換テーブル
  - [ ] 1.3 カタカナ近似変換テーブル
  - [ ] 1.4 ユニットテスト（典型的なフレーズ20件）

- [ ] 2. `VietnameseToneGuide` ユーティリティ（`lib/core/utils/viet_tone_guide.dart`）
  - [ ] 2.1 6声調の Unicode 文字マッピング（à â ã ả ạ など）
  - [ ] 2.2 声調名と説明の日本語テーブル

- [ ] 3. `PronunciationService`（`lib/core/services/pronunciation_service.dart`）
  - [ ] 3.1 言語コード別の変換ルーター
  - [ ] 3.2 Arabic のみ `explain-pronunciation` Edge Function への委譲
  - [ ] 3.3 変換結果のメモリキャッシュ（LRU 100件）

### Flutter UI

- [ ] 4. `MessageBubble` を単語タップ対応に改修
  - [ ] 4.1 文字列 → 単語スパン分割（空白区切り）
  - [ ] 4.2 単語タップ → 単語ポップオーバー
  - [ ] 4.3 メッセージロングタップ → 全文ポップオーバー
  - [ ] 4.4 単語ロングタップ → 「語彙帳に追加」メニュー

- [ ] 5. `PronunciationPopover` ウィジェット
  - [ ] 5.1 Romanization 行 + カタカナ行 + 声調ガイド（言語別）
  - [ ] 5.2 🔊 ボタン（TtsService 連携）
  - [ ] 5.3 OverlayEntry でポップオーバー実装

### 推定工数

- ルールベースエンジン: 4〜5時間
- Flutter UI: 2〜3時間
- テスト: 1時間
- 合計: **7〜9時間**

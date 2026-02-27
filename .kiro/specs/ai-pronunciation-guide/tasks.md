# Tasks — AI 発音ガイド（Pronunciation Guide）

## ステータス: ✅ 実装完了

---

### Core ライブラリ

- [x] 1. `KoreanRomanizer` ユーティリティ（`lib/core/utils/korean_romanizer.dart`）
  - [x] 1.1 ハングル Unicode 分解アルゴリズム（初声/中声/終声）
  - [x] 1.2 RR方式ローマ字変換テーブル（初声19個・中声21個・終声28個）
  - [x] 1.3 カタカナ近似変換テーブル（`_initialKatakana` / `_vowelKatakana`）
  - [x] 1.4 `romanize()` + `toKatakana()` 静的メソッド実装

- [x] 2. `VietnameseToneGuide` ユーティリティ（`lib/core/utils/vietnamese_tone_guide.dart`）
  - [x] 2.1 6声調の Unicode 文字マッピング（à á ả ã ạ + â ă ê ê ô ơ ư 各系統）
  - [x] 2.2 声調名と説明の日本語テーブル（名称・ピッチ方向・記号）
  - [x] 2.3 `detectTones()` で重複除去しながら声調リストを返す

- [x] 3. `PronunciationService`（`lib/core/services/pronunciation_service.dart`）
  - [x] 3.1 言語コード別の変換ルーター（ko / en / tr / vi / ar）
  - [x] 3.2 英語カタカナ近似辞書（頻出単語20件）
  - [x] 3.3 トルコ語カタカナ近似辞書（頻出単語13件）
  - [x] 3.4 ベトナム語声調記号除去（ローマ字基底へ正規化）
  - [x] 3.5 アラビア語 Buckwalter-style 転写（30文字対応）
  - [x] 3.6 メモリキャッシュ（最大100件、簡易LRU）

### TTS サービス

- [x] 3.7 `TtsService`（`lib/core/services/tts_service.dart`）
  - [x] flutter_tts を pubspec.yaml に追加（^4.0.2）
  - [x] 言語コード → locale マッピング（ko/en/tr/vi/ar/ja）
  - [x] `speak(text, languageCode)` + `stop()` メソッド
  - [x] 読み上げ速度 0.85（リスニング練習最適化）

### Flutter UI

- [x] 4. `MessageBubble` ロングタップ対応（`lib/features/chat/widgets/message_bubble.dart`）
  - [x] 4.1 `StatelessWidget` → `ConsumerWidget` に変更
  - [x] 4.2 `activeCharacterProvider` から言語コードを取得
  - [x] 4.3 GestureDetector の `onLongPress` でキャラクターメッセージのみ発音ガイド表示
  - [x] 4.4 「長押しで発音ガイド」ヒントテキストをバブル下部に追加
  - [x] 4.5 `_showPronunciationPopover()` で `showModalBottomSheet` を呼び出す

- [x] 5. `PronunciationGuideSheet` ウィジェット（`lib/features/chat/widgets/pronunciation_guide_sheet.dart`）
  - [x] 5.1 ドラッグハンドル + 元テキスト（大きめフォント）
  - [x] 5.2 📖 ローマ字読み行（`_GuideRow`）
  - [x] 5.3 🔤 カタカナ読み行（空でなければ表示）
  - [x] 5.4 声調ガイドセクション（ベトナム語のみ: `_ToneHintTile`）
  - [x] 5.5 🔊 TtsButton — 押下中インジケーター付き FilledButton
  - [x] 5.6 SafeArea / Bottom Padding 対応

### 推定工数

- ルールベースエンジン: 4〜5時間（実績: ✅）
- Flutter UI: 2〜3時間（実績: ✅）
- TTS 統合: 1時間（実績: ✅）
- 合計: **実装完了**

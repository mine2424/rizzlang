# Tasks — キャラクター音声（Character TTS）

## ステータス: ✅ 実装完了（2026-02-27）

---

- [x] 1. `flutter_tts: ^4.0.0` を pubspec.yaml に追加
- [x] 2. `TtsService` 作成（speak / stop / isSpeaking）
- [x] 3. `ttsServiceProvider` (Riverpod Provider)
- [x] 4. `MessageBubble` に `_SpeakButton` 追加
  - [x] 4.1 キャラクターバブルのみ表示
  - [x] 4.2 タップで speak / stop トグル
  - [x] 4.3 再生中は ⏹ アイコンに変更
  - [x] 4.4 `activeCharacterProvider` から言語コード取得

### 残タスク（Phase 2）

- [ ] 5. 設定画面に「音声読み上げ ON/OFF」トグル追加
- [ ] 6. TTS エンジン未導入時のフォールバック UI
- [ ] 7. 再生速度のユーザー設定（0.7 / 0.85 / 1.0 の3段階）
- [ ] 8. iOS: Background Audio 権限設定（AVAudioSession）

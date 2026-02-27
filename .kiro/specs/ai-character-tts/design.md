# Design — キャラクター音声（Character TTS）

## Overview

デバイスOS標準のTTSエンジンを `flutter_tts` 経由で使用。サーバーコスト0。
`TtsService` をシングルトンとして提供し、複数バブルからの同時読み上げを防止する。

---

## 依存パッケージ

```yaml
# pubspec.yaml
flutter_tts: ^4.0.0
```

---

## TtsService

**ファイル:** `lib/core/services/tts_service.dart`

```dart
final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  static const _langMap = {
    'ko': 'ko-KR',
    'en': 'en-US',
    'tr': 'tr-TR',
    'vi': 'vi-VN',
    'ar': 'ar-SA',
  };

  Future<void> speak(String text, String languageCode) async {
    if (_isSpeaking) await stop();
    final lang = _langMap[languageCode] ?? 'ko-KR';
    await _tts.setLanguage(lang);
    await _tts.setSpeechRate(0.85);  // 学習用ゆっくり
    await _tts.setPitch(1.1);         // 女性キャラ演出
    _isSpeaking = true;
    await _tts.speak(text);
    _isSpeaking = false;
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  bool get isSpeaking => _isSpeaking;
}
```

---

## MessageBubble — 🔊 ボタン統合

**ファイル:** `lib/features/chat/widgets/message_bubble.dart`

```dart
// キャラクターのバブルのみに追加
if (!isUser) ...[
  Positioned(
    bottom: 4,
    right: 4,
    child: _SpeakButton(
      text: message.content,
      language: character?.language ?? 'ko',
    ),
  ),
]

// _SpeakButton (StatefulWidget)
class _SpeakButton extends ConsumerStatefulWidget {
  final String text;
  final String language;
}

// タップ → speak / stop トグル
// 再生中: ⏹ アイコン（AppTheme.primary）
// 停止中: 🔊 アイコン（Colors.white38）
```

---

## 対応言語 × TTS エンジン

| 言語 | BCP-47 | iOS | Android |
|------|--------|-----|---------|
| 韓国語 | ko-KR | ✅ | ✅ |
| 英語 | en-US | ✅ | ✅ |
| トルコ語 | tr-TR | ✅ | 要DL |
| ベトナム語 | vi-VN | ✅ | 要DL |
| アラビア語 | ar-SA | ✅ | 要DL |

> Android でトルコ語・ベトナム語・アラビア語は追加TTSエンジンのDLが必要な場合がある。
> エンジン未導入時はボタンをグレーアウトして「設定からTTSをDLしてください」を表示。

---

## 非機能要件

- コスト: $0（デバイスOS TTS）
- 遅延: 即時（ネットワーク不要）
- バッテリー: 低消費（OS標準エンジン）

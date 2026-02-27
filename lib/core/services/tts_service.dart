import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

/// デバイス側 TTS (flutter_tts) を薄くラップするサービス。
/// 言語コードに応じて locale を切り替え、読み上げ速度を最適化する。
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  static const _langToLocale = {
    'ko': 'ko-KR',
    'en': 'en-US',
    'tr': 'tr-TR',
    'vi': 'vi-VN',
    'ar': 'ar-SA',
    'ja': 'ja-JP',
  };

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.85); // リスニング練習向けに少しゆっくり
    _initialized = true;
  }

  /// [text] を [languageCode] の TTS で読み上げる
  Future<void> speak(String text, {String languageCode = 'ko'}) async {
    await _ensureInit();
    final locale = _langToLocale[languageCode] ?? 'ko-KR';
    await _tts.setLanguage(locale);
    await _tts.speak(text);
  }

  /// 読み上げを停止
  Future<void> stop() async {
    await _tts.stop();
  }

  /// 日本語で読み上げ（ローマ字フォールバック用）
  Future<void> speakJapanese(String text) async {
    await _ensureInit();
    await _tts.setLanguage('ja-JP');
    await _tts.speak(text);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/korean_romanizer.dart';
import '../utils/vietnamese_tone_guide.dart';

final pronunciationServiceProvider =
    Provider<PronunciationService>((ref) => PronunciationService());

// ────────────────────────────────────────────────
// データモデル
// ────────────────────────────────────────────────

class PronunciationResult {
  final String romanization;
  final String katakana;
  final List<ToneHint> toneHints; // ベトナム語のみ

  const PronunciationResult({
    required this.romanization,
    required this.katakana,
    this.toneHints = const [],
  });
}

class ToneHint {
  final String char;
  final String name;
  final String description;
  final String symbol;

  const ToneHint({
    required this.char,
    required this.name,
    required this.description,
    required this.symbol,
  });
}

// ────────────────────────────────────────────────
// PronunciationService
// ────────────────────────────────────────────────

class PronunciationService {
  /// メモリキャッシュ（最大100件程度を想定）
  final Map<String, PronunciationResult> _cache = {};

  /// 指定テキストと言語コードから発音ガイドを返す
  PronunciationResult getGuide(String text, String languageCode) {
    final key = '$languageCode:$text';
    if (_cache.containsKey(key)) return _cache[key]!;

    final result = switch (languageCode) {
      'ko' => PronunciationResult(
          romanization: KoreanRomanizer.romanize(text),
          katakana: KoreanRomanizer.toKatakana(text),
        ),
      'en' => PronunciationResult(
          romanization: text, // 英語はそのまま表示
          katakana: _englishToKatakana(text),
        ),
      'tr' => PronunciationResult(
          romanization: text, // トルコ語はラテン文字基底
          katakana: _turkishToKatakana(text),
        ),
      'vi' => _buildVietnameseResult(text),
      'ar' => PronunciationResult(
          romanization: _arabicTransliterate(text),
          katakana: '（発音ガイド）',
        ),
      _ => PronunciationResult(romanization: text, katakana: ''),
    };

    // キャッシュ上限を超えたら古いエントリを削除（簡易LRU）
    if (_cache.length >= 100) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = result;
    return result;
  }

  // ─── ベトナム語 ───────────────────────────────
  PronunciationResult _buildVietnameseResult(String text) {
    final tones = VietnameseToneGuide.detectTones(text);
    return PronunciationResult(
      romanization: _removeVietnameseTones(text),
      katakana: '（声調に注意）',
      toneHints: tones
          .map((t) => ToneHint(
                char: t.char,
                name: t.name,
                description: t.description,
                symbol: t.symbol,
              ))
          .toList(),
    );
  }

  // ─── 英語カタカナ近似（頻出単語辞書）────────────
  static const _enKatakana = {
    'babe': 'ベイブ',
    'honey': 'ハニー',
    'miss': 'ミス',
    'you': 'ユー',
    'love': 'ラブ',
    'good': 'グッド',
    'morning': 'モーニング',
    'today': 'トゥデイ',
    'hey': 'ヘイ',
    'wait': 'ウェイト',
    'hi': 'ハイ',
    'hello': 'ハロー',
    'baby': 'ベイビー',
    'cute': 'キュート',
    'sweet': 'スウィート',
    'night': 'ナイト',
    'beautiful': 'ビューティフル',
    'awesome': 'オーサム',
    'amazing': 'アメイジング',
    'perfect': 'パーフェクト',
  };

  String _englishToKatakana(String text) {
    final words = text.toLowerCase().split(' ');
    return words.map((w) => _enKatakana[w] ?? w).join(' ');
  }

  // ─── トルコ語カタカナ近似（簡易）────────────────
  static const _trKatakana = {
    'merhaba': 'メルハバ',
    'günaydın': 'ギュナイドゥン',
    'özledim': 'オズレディム',
    'canım': 'ジャニム',
    'seni': 'セニ',
    'seviyorum': 'セビヨルム',
    'teşekkürler': 'テシェッキュルレル',
    'evet': 'エヴェット',
    'hayır': 'ハユル',
    'nasılsın': 'ナスルスン',
    'güzel': 'ギュゼル',
    'iyi': 'イイ',
    'tamam': 'タマム',
  };

  String _turkishToKatakana(String text) {
    final words = text.toLowerCase().split(' ');
    return words
        .map((w) => _trKatakana[w.replaceAll(RegExp(r'[^\w\u00C0-\u024F]'), '')] ?? w)
        .join(' ');
  }

  // ─── ベトナム語声調記号除去 ───────────────────
  String _removeVietnameseTones(String text) {
    return text
        .replaceAll(RegExp(r'[àáảãạ]'), 'a')
        .replaceAll(RegExp(r'[ắằẳẵặ]'), 'a')
        .replaceAll(RegExp(r'[ấầẩẫậ]'), 'a')
        .replaceAll(RegExp(r'[èéẻẽẹ]'), 'e')
        .replaceAll(RegExp(r'[ềếểễệ]'), 'e')
        .replaceAll(RegExp(r'[ìíỉĩị]'), 'i')
        .replaceAll(RegExp(r'[òóỏõọ]'), 'o')
        .replaceAll(RegExp(r'[ồốổỗộ]'), 'o')
        .replaceAll(RegExp(r'[ờớởỡợ]'), 'o')
        .replaceAll(RegExp(r'[ùúủũụ]'), 'u')
        .replaceAll(RegExp(r'[ừứửữự]'), 'u')
        .replaceAll(RegExp(r'[ỳýỷỹỵ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd');
  }

  // ─── アラビア語簡易転写 ──────────────────────
  static const _arabicMap = {
    'ا': 'a',
    'ب': 'b',
    'ت': 't',
    'ث': 'th',
    'ج': 'j',
    'ح': 'H',
    'خ': 'kh',
    'د': 'd',
    'ذ': 'dh',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'sh',
    'ص': 'S',
    'ض': 'D',
    'ط': 'T',
    'ظ': 'Z',
    'ع': "'",
    'غ': 'gh',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'و': 'w',
    'ي': 'y',
    'ة': 'h',
    'ء': "'",
    'ى': 'a',
    'ئ': 'y',
    'ؤ': 'w',
  };

  String _arabicTransliterate(String text) {
    return text
        .split('')
        .map((c) => _arabicMap[c] ?? c)
        .join('');
  }
}

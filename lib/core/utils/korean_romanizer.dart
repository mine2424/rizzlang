/// ハングル → RR方式ローマ字 + カタカナ近似変換
class KoreanRomanizer {
  // 初声 (초성) 19個
  static const _initials = [
    'g', 'kk', 'n', 'd', 'dd', 'r', 'm', 'b', 'pp',
    's', 'ss', '', 'j', 'jj', 'ch', 'k', 't', 'p', 'h',
  ];

  // 中声 (중성) 21個
  static const _vowels = [
    'a', 'ae', 'ya', 'yae', 'eo', 'e', 'yeo', 'ye', 'o',
    'wa', 'wae', 'oe', 'yo', 'u', 'wo', 'we', 'wi', 'yu',
    'eu', 'ui', 'i',
  ];

  // 終声 (종성) 28個
  static const _finals = [
    '', 'k', 'k', 'k', 'n', 'n', 'n', 't', 'l', 'k', 'm',
    'p', 'p', 'k', 't', 'p', 'm', 'p', 'ng', 't', 'k', 't',
    'ng', 't', 'n', 'p', 'h', '',
  ];

  // 中声のカタカナ近似
  static const _vowelKatakana = [
    'ア', 'エ', 'ヤ', 'イェ', 'オ', 'エ', 'ヨ', 'イェ', 'オ',
    'ワ', 'ウェ', 'ウェ', 'ヨ', 'ウ', 'ウォ', 'ウェ', 'ウィ', 'ユ',
    'ウ', 'ウィ', 'イ',
  ];

  // 初声のカタカナ近似（母音前）
  static const _initialKatakana = [
    'カ', 'ッカ', 'ナ', 'タ', 'ッタ', 'ラ', 'マ', 'バ', 'ッパ',
    'サ', 'ッサ', '', 'チャ', 'ッチャ', 'チャ', 'カ', 'タ', 'パ', 'ハ',
  ];

  /// ハングル文字列をローマ字に変換（Revised Romanization of Korean）
  static String romanize(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      if (code >= 0xAC00 && code <= 0xD7A3) {
        final offset = code - 0xAC00;
        final finalIdx = offset % 28;
        final vowelIdx = (offset ~/ 28) % 21;
        final initialIdx = offset ~/ 28 ~/ 21;
        buffer.write(_initials[initialIdx]);
        buffer.write(_vowels[vowelIdx]);
        buffer.write(_finals[finalIdx]);
      } else if (code == 32) {
        buffer.write(' ');
      } else {
        buffer.write(text[i]);
      }
    }
    return buffer.toString();
  }

  /// ハングル文字列をカタカナ近似に変換
  static String toKatakana(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      if (code >= 0xAC00 && code <= 0xD7A3) {
        final offset = code - 0xAC00;
        final vowelIdx = (offset ~/ 28) % 21;
        final initialIdx = offset ~/ 28 ~/ 21;
        final initial = _initialKatakana[initialIdx];
        final vowel = _vowelKatakana[vowelIdx];
        if (initial.isEmpty) {
          buffer.write(vowel);
        } else {
          buffer.write(_combineKatakana(initial, vowel));
        }
      } else if (code == 32) {
        buffer.write(' ');
      } else {
        buffer.write(text[i]);
      }
    }
    return buffer.toString();
  }

  static String _combineKatakana(String initial, String vowel) {
    // 簡易結合: 先頭子音 + 母音で推定カタカナを返す
    // 詳細な変換テーブルは後で拡張可能
    return '$initial($vowel)';
  }
}

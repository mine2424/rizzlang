/// ベトナム語の声調記号ガイド
class VietnameseToneGuide {
  static const Map<String, _ToneInfo> toneMap = {
    // ─── a 系統 ───────────────────────────────
    'à': _ToneInfo('à', '重声（Huyền）', '低く下がる', '↘'),
    'á': _ToneInfo('á', '鋭声（Sắc）', '高く上がる', '↗'),
    'ả': _ToneInfo('ả', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ã': _ToneInfo('ã', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ạ': _ToneInfo('ạ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── ă 系統 ───────────────────────────────
    'ắ': _ToneInfo('ắ', '鋭声（Sắc）', '高く上がる', '↗'),
    'ằ': _ToneInfo('ằ', '重声（Huyền）', '低く下がる', '↘'),
    'ẳ': _ToneInfo('ẳ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ẵ': _ToneInfo('ẵ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ặ': _ToneInfo('ặ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── â 系統 ───────────────────────────────
    'ấ': _ToneInfo('ấ', '鋭声（Sắc）', '高く上がる', '↗'),
    'ầ': _ToneInfo('ầ', '重声（Huyền）', '低く下がる', '↘'),
    'ẩ': _ToneInfo('ẩ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ẫ': _ToneInfo('ẫ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ậ': _ToneInfo('ậ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── e 系統 ───────────────────────────────
    'è': _ToneInfo('è', '重声（Huyền）', '低く下がる', '↘'),
    'é': _ToneInfo('é', '鋭声（Sắc）', '高く上がる', '↗'),
    'ẻ': _ToneInfo('ẻ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ẽ': _ToneInfo('ẽ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ẹ': _ToneInfo('ẹ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── ê 系統 ───────────────────────────────
    'ề': _ToneInfo('ề', '重声（Huyền）', '低く下がる', '↘'),
    'ế': _ToneInfo('ế', '鋭声（Sắc）', '高く上がる', '↗'),
    'ể': _ToneInfo('ể', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ễ': _ToneInfo('ễ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ệ': _ToneInfo('ệ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── i 系統 ───────────────────────────────
    'ì': _ToneInfo('ì', '重声（Huyền）', '低く下がる', '↘'),
    'í': _ToneInfo('í', '鋭声（Sắc）', '高く上がる', '↗'),
    'ỉ': _ToneInfo('ỉ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ĩ': _ToneInfo('ĩ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ị': _ToneInfo('ị', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── o 系統 ───────────────────────────────
    'ò': _ToneInfo('ò', '重声（Huyền）', '低く下がる', '↘'),
    'ó': _ToneInfo('ó', '鋭声（Sắc）', '高く上がる', '↗'),
    'ỏ': _ToneInfo('ỏ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'õ': _ToneInfo('õ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ọ': _ToneInfo('ọ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── ô 系統 ───────────────────────────────
    'ồ': _ToneInfo('ồ', '重声（Huyền）', '低く下がる', '↘'),
    'ố': _ToneInfo('ố', '鋭声（Sắc）', '高く上がる', '↗'),
    'ổ': _ToneInfo('ổ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ỗ': _ToneInfo('ỗ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ộ': _ToneInfo('ộ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── ơ 系統 ───────────────────────────────
    'ờ': _ToneInfo('ờ', '重声（Huyền）', '低く下がる', '↘'),
    'ớ': _ToneInfo('ớ', '鋭声（Sắc）', '高く上がる', '↗'),
    'ở': _ToneInfo('ở', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ỡ': _ToneInfo('ỡ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ợ': _ToneInfo('ợ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── u 系統 ───────────────────────────────
    'ù': _ToneInfo('ù', '重声（Huyền）', '低く下がる', '↘'),
    'ú': _ToneInfo('ú', '鋭声（Sắc）', '高く上がる', '↗'),
    'ủ': _ToneInfo('ủ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ũ': _ToneInfo('ũ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ụ': _ToneInfo('ụ', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── ư 系統 ───────────────────────────────
    'ừ': _ToneInfo('ừ', '重声（Huyền）', '低く下がる', '↘'),
    'ứ': _ToneInfo('ứ', '鋭声（Sắc）', '高く上がる', '↗'),
    'ử': _ToneInfo('ử', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ữ': _ToneInfo('ữ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ự': _ToneInfo('ự', '入声（Nặng）', '低く詰まる', '↘stop'),
    // ─── y 系統 ───────────────────────────────
    'ỳ': _ToneInfo('ỳ', '重声（Huyền）', '低く下がる', '↘'),
    'ý': _ToneInfo('ý', '鋭声（Sắc）', '高く上がる', '↗'),
    'ỷ': _ToneInfo('ỷ', '問声（Hỏi）', '下がって上がる', '↙↗'),
    'ỹ': _ToneInfo('ỹ', '跌声（Ngã）', '途中で声門閉鎖', '↗glottal'),
    'ỵ': _ToneInfo('ỵ', '入声（Nặng）', '低く詰まる', '↘stop'),
  };

  /// テキスト内の声調記号を検出してガイドリストを返す（重複除去）
  static List<_ToneInfo> detectTones(String text) {
    final result = <_ToneInfo>[];
    final seen = <String>{};
    // runes を使って Unicode コードポイント単位でイテレート
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      if (toneMap.containsKey(char) && !seen.contains(char)) {
        result.add(toneMap[char]!);
        seen.add(char);
      }
    }
    return result;
  }
}

class _ToneInfo {
  final String char;
  final String name;
  final String description;
  final String symbol;
  const _ToneInfo(this.char, this.name, this.description, this.symbol);
}

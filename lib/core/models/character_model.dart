import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_model.freezed.dart';
part 'character_model.g.dart';

@freezed
class CharacterModel with _$CharacterModel {
  const factory CharacterModel({
    required String id,
    required String name,
    required String language, // 'ko' | 'en' | 'tr' | 'vi' | 'ar'
    required Map<String, dynamic> persona,
    String? avatarUrl,
  }) = _CharacterModel;

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);
}

// ── Extension ─────────────────────────────────────────────────
extension CharacterModelExt on CharacterModel {
  String get callName => persona['callName'] as String? ?? 'babe';

  String get speechStyle => persona['speechStyle'] as String? ?? '';

  String get flagEmoji => _languageToFlag(language);

  String get languageDisplayName => _languageToDisplay(language);

  /// "지우 (ジウ)" → "지우", "Emma" → "Emma"
  String get shortName => name.split(' ').first;

  /// 短い説明文（キャラクター選択画面用）
  String get shortDescription =>
      persona['shortDescription'] as String? ?? persona['description'] as String? ?? '';
}

String _languageToFlag(String lang) {
  switch (lang) {
    case 'ko':
      return '🇰🇷';
    case 'en':
      return '🇺🇸';
    case 'tr':
      return '🇹🇷';
    case 'vi':
      return '🇻🇳';
    case 'ar':
      return '🇸🇦';
    default:
      return '🌐';
  }
}

String _languageToDisplay(String lang) {
  switch (lang) {
    case 'ko':
      return '韓国語';
    case 'en':
      return '英語';
    case 'tr':
      return 'トルコ語';
    case 'vi':
      return 'ベトナム語';
    case 'ar':
      return 'アラビア語';
    default:
      return lang.toUpperCase();
  }
}

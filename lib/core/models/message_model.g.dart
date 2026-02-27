// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator (minimal stub)
// **************************************************************************

_$MessageModelImpl _$MessageModelFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      content: json['content'] as String,
      originalJapanese: json['originalJapanese'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'originalJapanese': instance.originalJapanese,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.character: 'character',
};

_$SlangItemImpl _$SlangItemFromJson(Map<String, dynamic> json) =>
    _$SlangItemImpl(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
    );

Map<String, dynamic> _$SlangItemToJson(_$SlangItemImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'meaning': instance.meaning,
    };

_$GeneratedReplyImpl _$GeneratedReplyFromJson(Map<String, dynamic> json) =>
    _$GeneratedReplyImpl(
      reply: json['reply'] as String,
      why: json['why'] as String,
      slang: (json['slang'] as List<dynamic>?)
              ?.map((e) => SlangItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextMessage: json['nextMessage'] as String,
      tensionPhase: json['tensionPhase'] as String?,
      phaseTransition: json['phaseTransition'] as String?,
      phaseComplete: json['phaseComplete'] as bool? ?? false,
      turnsRemaining: json['turnsRemaining'] as int?,
      scenarioDay: json['scenarioDay'] as String?,
      reviewedWords: (json['reviewedWords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GeneratedReplyToJson(_$GeneratedReplyImpl instance) =>
    <String, dynamic>{
      'reply': instance.reply,
      'why': instance.why,
      'slang': instance.slang.map((e) => e.toJson()).toList(),
      'nextMessage': instance.nextMessage,
      if (instance.tensionPhase != null) 'tensionPhase': instance.tensionPhase,
      if (instance.phaseTransition != null) 'phaseTransition': instance.phaseTransition,
      'phaseComplete': instance.phaseComplete,
      if (instance.turnsRemaining != null) 'turnsRemaining': instance.turnsRemaining,
      if (instance.scenarioDay != null) 'scenarioDay': instance.scenarioDay,
      'reviewedWords': instance.reviewedWords,
    };

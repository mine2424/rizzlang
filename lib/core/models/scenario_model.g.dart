// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_model.dart';

_$ScenarioModelImpl _$ScenarioModelFromJson(Map<String, dynamic> json) =>
    _$ScenarioModelImpl(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      arcSeason: json['arcSeason'] as int,
      arcWeek: json['arcWeek'] as int,
      arcDay: json['arcDay'] as int,
      sceneType: $enumDecode(_$SceneTypeEnumMap, json['sceneType']),
      openingMessage: (json['openingMessage'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>).map((k, e) => MapEntry(k, e as String)),
        ),
      ),
      vocabTargets: (json['vocabTargets'] as List<dynamic>?)
              ?.map((e) => VocabTarget.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextMessageHint: json['nextMessageHint'] as String?,
    );

Map<String, dynamic> _$ScenarioModelToJson(_$ScenarioModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'characterId': instance.characterId,
      'arcSeason': instance.arcSeason,
      'arcWeek': instance.arcWeek,
      'arcDay': instance.arcDay,
      'sceneType': _$SceneTypeEnumMap[instance.sceneType]!,
      'openingMessage': instance.openingMessage,
      'vocabTargets': instance.vocabTargets.map((e) => e.toJson()).toList(),
      'nextMessageHint': instance.nextMessageHint,
    };

const _$SceneTypeEnumMap = {
  SceneType.daily: 'daily',
  SceneType.emotional: 'emotional',
  SceneType.discovery: 'discovery',
  SceneType.event: 'event',
  SceneType.tension: 'tension',
};

_$VocabTargetImpl _$VocabTargetFromJson(Map<String, dynamic> json) =>
    _$VocabTargetImpl(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      level: json['level'] as int,
    );

Map<String, dynamic> _$VocabTargetToJson(_$VocabTargetImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'meaning': instance.meaning,
      'level': instance.level,
    };

_$ScenarioProgressImpl _$ScenarioProgressFromJson(Map<String, dynamic> json) =>
    _$ScenarioProgressImpl(
      userId: json['userId'] as String,
      characterId: json['characterId'] as String,
      currentSeason: json['currentSeason'] as int? ?? 1,
      currentWeek: json['currentWeek'] as int? ?? 1,
      currentDay: json['currentDay'] as int? ?? 1,
      lastPlayedAt: json['lastPlayedAt'] == null
          ? null
          : DateTime.parse(json['lastPlayedAt'] as String),
    );

Map<String, dynamic> _$ScenarioProgressToJson(_$ScenarioProgressImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'characterId': instance.characterId,
      'currentSeason': instance.currentSeason,
      'currentWeek': instance.currentWeek,
      'currentDay': instance.currentDay,
      'lastPlayedAt': instance.lastPlayedAt?.toIso8601String(),
    };

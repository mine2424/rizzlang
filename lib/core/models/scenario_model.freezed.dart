// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario_model.dart';

class _$ScenarioModelImpl implements _ScenarioModel {
  const _$ScenarioModelImpl({
    required this.id,
    required this.characterId,
    required this.arcSeason,
    required this.arcWeek,
    required this.arcDay,
    required this.sceneType,
    required this.openingMessage,
    this.vocabTargets = const [],
    this.nextMessageHint,
  });

  @override
  final String id;
  @override
  final String characterId;
  @override
  final int arcSeason;
  @override
  final int arcWeek;
  @override
  final int arcDay;
  @override
  final SceneType sceneType;
  @override
  final Map<String, Map<String, String>> openingMessage;
  @override
  final List<VocabTarget> vocabTargets;
  @override
  final String? nextMessageHint;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ScenarioModelImpl && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ScenarioModel(id: $id)';

  @override
  Map<String, dynamic> toJson() => _$ScenarioModelToJson(this);
}

abstract class _ScenarioModel implements ScenarioModel {
  const factory _ScenarioModel({
    required String id,
    required String characterId,
    required int arcSeason,
    required int arcWeek,
    required int arcDay,
    required SceneType sceneType,
    required Map<String, Map<String, String>> openingMessage,
    List<VocabTarget> vocabTargets,
    String? nextMessageHint,
  }) = _$ScenarioModelImpl;

  @override
  String get id;
  @override
  String get characterId;
  @override
  int get arcSeason;
  @override
  int get arcWeek;
  @override
  int get arcDay;
  @override
  SceneType get sceneType;
  @override
  Map<String, Map<String, String>> get openingMessage;
  @override
  List<VocabTarget> get vocabTargets;
  @override
  String? get nextMessageHint;
  @override
  Map<String, dynamic> toJson();
}

class _$VocabTargetImpl implements _VocabTarget {
  const _$VocabTargetImpl({
    required this.word,
    required this.meaning,
    required this.level,
  });

  @override
  final String word;
  @override
  final String meaning;
  @override
  final int level;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$VocabTargetImpl && word == other.word;

  @override
  int get hashCode => word.hashCode;

  @override
  String toString() => 'VocabTarget(word: $word)';

  @override
  Map<String, dynamic> toJson() => _$VocabTargetToJson(this);
}

abstract class _VocabTarget implements VocabTarget {
  const factory _VocabTarget({
    required String word,
    required String meaning,
    required int level,
  }) = _$VocabTargetImpl;

  @override
  String get word;
  @override
  String get meaning;
  @override
  int get level;
  @override
  Map<String, dynamic> toJson();
}

class _$ScenarioProgressImpl implements _ScenarioProgress {
  const _$ScenarioProgressImpl({
    required this.userId,
    required this.characterId,
    this.currentSeason = 1,
    this.currentWeek = 1,
    this.currentDay = 1,
    this.lastPlayedAt,
  });

  @override
  final String userId;
  @override
  final String characterId;
  @override
  final int currentSeason;
  @override
  final int currentWeek;
  @override
  final int currentDay;
  @override
  final DateTime? lastPlayedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ScenarioProgressImpl &&
          userId == other.userId &&
          characterId == other.characterId;

  @override
  int get hashCode => Object.hash(userId, characterId);

  @override
  String toString() => 'ScenarioProgress(userId: $userId)';

  @override
  Map<String, dynamic> toJson() => _$ScenarioProgressToJson(this);
}

abstract class _ScenarioProgress implements ScenarioProgress {
  const factory _ScenarioProgress({
    required String userId,
    required String characterId,
    int currentSeason,
    int currentWeek,
    int currentDay,
    DateTime? lastPlayedAt,
  }) = _$ScenarioProgressImpl;

  @override
  String get userId;
  @override
  String get characterId;
  @override
  int get currentSeason;
  @override
  int get currentWeek;
  @override
  int get currentDay;
  @override
  DateTime? get lastPlayedAt;
  @override
  Map<String, dynamic> toJson();
}

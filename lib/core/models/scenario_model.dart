import 'package:freezed_annotation/freezed_annotation.dart';

part 'scenario_model.freezed.dart';
part 'scenario_model.g.dart';

enum SceneType { daily, emotional, discovery, event, tension }

@freezed
class ScenarioModel with _$ScenarioModel {
  const factory ScenarioModel({
    required String id,
    required String characterId,
    required int arcSeason,
    required int arcWeek,
    required int arcDay,
    required SceneType sceneType,
    required Map<String, Map<String, String>> openingMessage, // {lv1: {morning:.., evening:..}}
    @Default([]) List<VocabTarget> vocabTargets,
    String? nextMessageHint,
  }) = _ScenarioModel;

  factory ScenarioModel.fromJson(Map<String, dynamic> json) =>
      _$ScenarioModelFromJson(json);
}

@freezed
class VocabTarget with _$VocabTarget {
  const factory VocabTarget({
    required String word,
    required String meaning,
    required int level,
  }) = _VocabTarget;

  factory VocabTarget.fromJson(Map<String, dynamic> json) =>
      _$VocabTargetFromJson(json);
}

@freezed
class ScenarioProgress with _$ScenarioProgress {
  const factory ScenarioProgress({
    required String userId,
    required String characterId,
    @Default(1) int currentSeason,
    @Default(1) int currentWeek,
    @Default(1) int currentDay,
    DateTime? lastPlayedAt,
  }) = _ScenarioProgress;

  factory ScenarioProgress.fromJson(Map<String, dynamic> json) =>
      _$ScenarioProgressFromJson(json);
}

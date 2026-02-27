import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_memory_model.freezed.dart';
part 'relationship_memory_model.g.dart';

@freezed
class RelationshipMemoryModel with _$RelationshipMemoryModel {
  const factory RelationshipMemoryModel({
    required String id,
    required String userId,
    required String characterId,
    required int weekNumber,
    required String weekStart,
    required String weekEnd,
    required String summary,
    @Default(5) int emotionalWeight,
    required String createdAt,
  }) = _RelationshipMemoryModel;

  factory RelationshipMemoryModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipMemoryModelFromJson(json);
}

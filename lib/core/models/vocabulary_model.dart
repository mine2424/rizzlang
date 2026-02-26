import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_model.freezed.dart';
part 'vocabulary_model.g.dart';

@freezed
class VocabularyModel with _$VocabularyModel {
  const factory VocabularyModel({
    required String id,
    required String userId,
    required String word,
    required String meaning,
    String? example,
    required String language,
    required DateTime learnedAt,
    required DateTime nextReview,
    @Default(0) int reviewCount,
    @Default(2.5) double easeFactor,
  }) = _VocabularyModel;

  factory VocabularyModel.fromJson(Map<String, dynamic> json) =>
      _$VocabularyModelFromJson(json);
}

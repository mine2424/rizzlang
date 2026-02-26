// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_model.dart';

class _$VocabularyModelImpl implements _VocabularyModel {
  const _$VocabularyModelImpl({
    required this.id,
    required this.userId,
    required this.word,
    required this.meaning,
    this.example,
    required this.language,
    required this.learnedAt,
    required this.nextReview,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
  });

  @override
  final String id;
  @override
  final String userId;
  @override
  final String word;
  @override
  final String meaning;
  @override
  final String? example;
  @override
  final String language;
  @override
  final DateTime learnedAt;
  @override
  final DateTime nextReview;
  @override
  final int reviewCount;
  @override
  final double easeFactor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$VocabularyModelImpl && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'VocabularyModel(id: $id, word: $word)';

  @override
  Map<String, dynamic> toJson() => _$VocabularyModelToJson(this);
}

abstract class _VocabularyModel implements VocabularyModel {
  const factory _VocabularyModel({
    required String id,
    required String userId,
    required String word,
    required String meaning,
    String? example,
    required String language,
    required DateTime learnedAt,
    required DateTime nextReview,
    int reviewCount,
    double easeFactor,
  }) = _$VocabularyModelImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get word;
  @override
  String get meaning;
  @override
  String? get example;
  @override
  String get language;
  @override
  DateTime get learnedAt;
  @override
  DateTime get nextReview;
  @override
  int get reviewCount;
  @override
  double get easeFactor;
  @override
  Map<String, dynamic> toJson();
}

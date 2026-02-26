// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_model.dart';

_$VocabularyModelImpl _$VocabularyModelFromJson(Map<String, dynamic> json) =>
    _$VocabularyModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String?,
      language: json['language'] as String,
      learnedAt: DateTime.parse(json['learnedAt'] as String),
      nextReview: DateTime.parse(json['nextReview'] as String),
      reviewCount: json['reviewCount'] as int? ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
    );

Map<String, dynamic> _$VocabularyModelToJson(_$VocabularyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'word': instance.word,
      'meaning': instance.meaning,
      'example': instance.example,
      'language': instance.language,
      'learnedAt': instance.learnedAt.toIso8601String(),
      'nextReview': instance.nextReview.toIso8601String(),
      'reviewCount': instance.reviewCount,
      'easeFactor': instance.easeFactor,
    };

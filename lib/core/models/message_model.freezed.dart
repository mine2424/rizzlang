// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator (minimal stub for compilation)
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl({
    required this.id,
    required this.role,
    required this.content,
    this.originalJapanese,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final String? originalJapanese;
  @override
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MessageModelImpl &&
          id == other.id &&
          role == other.role &&
          content == other.content &&
          originalJapanese == other.originalJapanese &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, role, content, originalJapanese, createdAt);

  @override
  String toString() =>
      'MessageModel(id: $id, role: $role, content: $content, '
      'originalJapanese: $originalJapanese, createdAt: $createdAt)';

  @override
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel({
    required String id,
    required MessageRole role,
    required String content,
    String? originalJapanese,
    required DateTime createdAt,
  }) = _$MessageModelImpl;

  @override
  String get id;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  String? get originalJapanese;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic> toJson();
}

// SlangItem

class _$SlangItemImpl implements _SlangItem {
  const _$SlangItemImpl({required this.word, required this.meaning});

  @override
  final String word;
  @override
  final String meaning;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SlangItemImpl && word == other.word && meaning == other.meaning;

  @override
  int get hashCode => Object.hash(word, meaning);

  @override
  String toString() => 'SlangItem(word: $word, meaning: $meaning)';

  @override
  Map<String, dynamic> toJson() => _$SlangItemToJson(this);
}

abstract class _SlangItem implements SlangItem {
  const factory _SlangItem({
    required String word,
    required String meaning,
  }) = _$SlangItemImpl;

  @override
  String get word;
  @override
  String get meaning;
  @override
  Map<String, dynamic> toJson();
}

// GeneratedReply

class _$GeneratedReplyImpl implements _GeneratedReply {
  const _$GeneratedReplyImpl({
    required this.reply,
    required this.why,
    this.slang = const [],
    required this.nextMessage,
  });

  @override
  final String reply;
  @override
  final String why;
  @override
  final List<SlangItem> slang;
  @override
  final String nextMessage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$GeneratedReplyImpl &&
          reply == other.reply &&
          why == other.why &&
          nextMessage == other.nextMessage;

  @override
  int get hashCode => Object.hash(reply, why, nextMessage);

  @override
  String toString() =>
      'GeneratedReply(reply: $reply, why: $why, slang: $slang, nextMessage: $nextMessage)';

  @override
  Map<String, dynamic> toJson() => _$GeneratedReplyToJson(this);
}

abstract class _GeneratedReply implements GeneratedReply {
  const factory _GeneratedReply({
    required String reply,
    required String why,
    List<SlangItem> slang,
    required String nextMessage,
  }) = _$GeneratedReplyImpl;

  @override
  String get reply;
  @override
  String get why;
  @override
  List<SlangItem> get slang;
  @override
  String get nextMessage;
  @override
  Map<String, dynamic> toJson();
}

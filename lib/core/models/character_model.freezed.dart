// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_model.dart';

// **************************************************************************
// FreezedGenerator (minimal stub for compilation)
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

class _$CharacterModelImpl implements _CharacterModel {
  const _$CharacterModelImpl({
    required this.id,
    required this.name,
    required this.language,
    required this.persona,
    this.avatarUrl,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String language;
  @override
  final Map<String, dynamic> persona;
  @override
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$CharacterModelImpl &&
          id == other.id &&
          name == other.name &&
          language == other.language;

  @override
  int get hashCode => Object.hash(id, name, language);

  @override
  String toString() =>
      'CharacterModel(id: $id, name: $name, language: $language, '
      'avatarUrl: $avatarUrl)';

  @override
  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  @override
  _$CharacterModelImpl copyWith({
    Object? id = const _$Undefined(),
    Object? name = const _$Undefined(),
    Object? language = const _$Undefined(),
    Object? persona = const _$Undefined(),
    Object? avatarUrl = const _$Undefined(),
  }) {
    return _$CharacterModelImpl(
      id: id is _$Undefined ? this.id : id as String,
      name: name is _$Undefined ? this.name : name as String,
      language: language is _$Undefined ? this.language : language as String,
      persona: persona is _$Undefined
          ? this.persona
          : persona as Map<String, dynamic>,
      avatarUrl:
          avatarUrl is _$Undefined ? this.avatarUrl : avatarUrl as String?,
    );
  }
}

class _$Undefined {
  const _$Undefined();
}

abstract class _CharacterModel implements CharacterModel {
  const factory _CharacterModel({
    required String id,
    required String name,
    required String language,
    required Map<String, dynamic> persona,
    String? avatarUrl,
  }) = _$CharacterModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get language;
  @override
  Map<String, dynamic> get persona;
  @override
  String? get avatarUrl;
  @override
  Map<String, dynamic> toJson();
  @override
  _$CharacterModelImpl copyWith({
    Object? id,
    Object? name,
    Object? language,
    Object? persona,
    Object? avatarUrl,
  });
}

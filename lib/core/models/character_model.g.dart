// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator (minimal stub)
// **************************************************************************

_$CharacterModelImpl _$CharacterModelFromJson(Map<String, dynamic> json) =>
    _$CharacterModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      persona: json['persona'] as Map<String, dynamic>? ??
          json['persona'] as Map<String, dynamic>,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$CharacterModelToJson(_$CharacterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'language': instance.language,
      'persona': instance.persona,
      'avatar_url': instance.avatarUrl,
    };

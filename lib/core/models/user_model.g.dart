// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

_$UserModelImpl _$UserModelFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      plan: $enumDecodeNullable(_$UserPlanEnumMap, json['plan']) ?? UserPlan.free,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      currentLevel: json['currentLevel'] as int? ?? 1,
      userCallName: json['userCallName'] as String? ?? 'オッパ',
      streak: json['streak'] as int? ?? 0,
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'plan': _$UserPlanEnumMap[instance.plan]!,
      'stripeCustomerId': instance.stripeCustomerId,
      'currentLevel': instance.currentLevel,
      'userCallName': instance.userCallName,
      'streak': instance.streak,
      'lastActive': instance.lastActive?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UserPlanEnumMap = {
  UserPlan.free: 'free',
  UserPlan.pro: 'pro',
};

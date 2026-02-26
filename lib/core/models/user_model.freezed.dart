// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    this.plan = UserPlan.free,
    this.stripeCustomerId,
    this.currentLevel = 1,
    this.userCallName = 'オッパ',
    this.streak = 0,
    this.lastActive,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String email;
  @override
  final UserPlan plan;
  @override
  final String? stripeCustomerId;
  @override
  final int currentLevel;
  @override
  final String userCallName;
  @override
  final int streak;
  @override
  final DateTime? lastActive;
  @override
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$UserModelImpl && id == other.id && email == other.email;

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() => 'UserModel(id: $id, email: $email)';

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required String id,
    required String email,
    UserPlan plan,
    String? stripeCustomerId,
    int currentLevel,
    String userCallName,
    int streak,
    DateTime? lastActive,
    required DateTime createdAt,
  }) = _$UserModelImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  UserPlan get plan;
  @override
  String? get stripeCustomerId;
  @override
  int get currentLevel;
  @override
  String get userCallName;
  @override
  int get streak;
  @override
  DateTime? get lastActive;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic> toJson();
}

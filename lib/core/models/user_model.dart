import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserPlan { free, pro }

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @Default(UserPlan.free) UserPlan plan,
    String? stripeCustomerId,
    @Default(1) int currentLevel,
    @Default('オッパ') String userCallName,
    @Default(0) int streak,
    DateTime? lastActive,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

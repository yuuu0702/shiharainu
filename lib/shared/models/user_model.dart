import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? position,
    String? branch,
    String? accountNumber,
    required UserRole role,
    String? age,
    String? gender,
    @Default(false) bool isDrinking,
    @Default(false) bool isGuest,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum UserRole {
  @JsonValue('organizer')
  organizer,
  @JsonValue('participant')
  participant,
  @JsonValue('guest')
  guest,
}
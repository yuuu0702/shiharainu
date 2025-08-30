import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id, // Firebase Auth UID
    required String name,
    required int age,
    required String position, // 役職
    required String email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

// ユーザープロフィール作成用のDTO
@freezed
class CreateUserProfileRequest with _$CreateUserProfileRequest {
  const factory CreateUserProfileRequest({
    required String name,
    required int age,
    required String position,
  }) = _CreateUserProfileRequest;

  factory CreateUserProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserProfileRequestFromJson(json);
}

// よく使用される役職の定数
class UserPositions {
  static const List<String> commonPositions = [
    '学生',
    '会社員',
    '公務員',
    '経営者',
    '自営業',
    'エンジニア',
    'デザイナー',
    '営業',
    'マーケティング',
    '人事',
    '経理',
    '管理職',
    '研究者',
    '教員',
    '医師',
    '看護師',
    'フリーランス',
    '主婦・主夫',
    '無職',
    'その他',
  ];
}
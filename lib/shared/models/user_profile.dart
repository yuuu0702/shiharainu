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

// 役職階層（支払い傾斜用）
enum UserPositionLevel {
  general('一般'),
  chief('チーフ'),
  manager('マネージャー'),
  groupLeader('グループ長');

  const UserPositionLevel(this.displayName);
  final String displayName;

  // 階層レベル（数値が高いほど上位）
  int get level {
    switch (this) {
      case UserPositionLevel.general:
        return 1;
      case UserPositionLevel.chief:
        return 2;
      case UserPositionLevel.manager:
        return 3;
      case UserPositionLevel.groupLeader:
        return 4;
    }
  }

  // 支払い係数（上位ほど多く支払う）
  double get paymentRatio {
    switch (this) {
      case UserPositionLevel.general:
        return 1.0;
      case UserPositionLevel.chief:
        return 1.2;
      case UserPositionLevel.manager:
        return 1.5;
      case UserPositionLevel.groupLeader:
        return 2.0;
    }
  }

  static UserPositionLevel fromString(String position) {
    for (final level in UserPositionLevel.values) {
      if (level.displayName == position) {
        return level;
      }
    }
    return UserPositionLevel.general; // デフォルト
  }
}

class UserPositions {
  // 階層化された役職リスト（下位から上位順）
  static const List<String> hierarchicalPositions = [
    '一般',
    'チーフ',
    'マネージャー',
    'グループ長',
  ];

  // 表示用の説明付き役職リスト
  static const List<Map<String, String>> positionsWithDescription = [
    {'name': '一般', 'description': '標準的な役職レベル（支払い係数: 1.0倍）'},
    {'name': 'チーフ', 'description': '小チームのリーダー（支払い係数: 1.2倍）'},
    {'name': 'マネージャー', 'description': '部門の管理職（支払い係数: 1.5倍）'},
    {'name': 'グループ長', 'description': '大きな組織の責任者（支払い係数: 2.0倍）'},
  ];

  // 後方互換性のための従来の役職リスト（非推奨）
  @Deprecated('hierarchicalPositions を使用してください')
  static const List<String> commonPositions = hierarchicalPositions;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiharainu/shared/models/event_model.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

/// 参加者の役割
enum ParticipantRole {
  @JsonValue('organizer')
  organizer, // 主催者
  @JsonValue('participant')
  participant, // 参加者
}

/// 参加者の性別
enum ParticipantGender {
  @JsonValue('male')
  male, // 男性
  @JsonValue('female')
  female, // 女性
  @JsonValue('other')
  other, // その他
}

/// 支払いステータス
enum PaymentStatus {
  @JsonValue('paid')
  paid, // 支払済
  @JsonValue('pending')
  pending, // 確認中
  @JsonValue('unpaid')
  unpaid, // 未払
}

/// 参加者モデル
@freezed
class ParticipantModel with _$ParticipantModel {
  const factory ParticipantModel({
    required String id,
    required String eventId,
    required String userId,
    required String displayName,
    @Default(ParticipantRole.participant) ParticipantRole role,
    int? age, // 年齢（オプション）
    @Default(ParticipantGender.other) ParticipantGender gender,
    @Default(1.0) double multiplier, // 支払い比率の重み付け（デフォルト1.0）
    @Default(0.0) double amountToPay, // 支払い額
    @Default(PaymentStatus.unpaid) PaymentStatus paymentStatus, // 支払いステータス
    @TimestampConverter() required DateTime joinedAt,
  }) = _ParticipantModel;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  /// Firestoreドキュメントから作成
  factory ParticipantModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return ParticipantModel.fromJson(data);
  }

  /// Firestore保存用のMapに変換（idを除外）
  static Map<String, dynamic> toFirestore(ParticipantModel participant) {
    final json = participant.toJson();
    json.remove('id'); // Firestoreのドキュメント IDは別管理
    return json;
  }
}

/// 参加者の重み付け計算用の拡張
extension ParticipantMultiplierCalculation on ParticipantModel {
  /// 役職・年齢・性別に基づく重み付け係数を計算
  ///
  /// 計算式:
  /// - 基本係数: 1.0
  /// - 役職ボーナス: 主催者の場合 +0.2
  /// - 年齢係数:
  ///   - 18歳未満: 0.5
  ///   - 18-22歳: 0.7
  ///   - 23-29歳: 0.9
  ///   - 30歳以上: 1.0
  /// - 性別係数: 女性の場合 0.8
  double calculateMultiplier() {
    double coefficient = 1.0;

    // 役職ボーナス
    if (role == ParticipantRole.organizer) {
      coefficient += 0.2;
    }

    // 年齢係数
    if (age != null) {
      if (age! < 18) {
        coefficient *= 0.5;
      } else if (age! < 23) {
        coefficient *= 0.7;
      } else if (age! < 30) {
        coefficient *= 0.9;
      }
      // 30歳以上は係数1.0（変更なし）
    }

    // 性別係数
    if (gender == ParticipantGender.female) {
      coefficient *= 0.8;
    }

    return coefficient;
  }
}

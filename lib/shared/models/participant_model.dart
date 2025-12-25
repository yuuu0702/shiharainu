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
  // Fallback
  other,
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
    required String email, // メールアドレス
    @Default(ParticipantRole.participant)
    // ignore: invalid_annotation_target
    @JsonKey(unknownEnumValue: ParticipantRole.other)
    ParticipantRole role,
    int? age, // 年齢（オプション）
    String? position, // 役職（オプション）
    @Default(ParticipantGender.other) ParticipantGender gender,
    @Default(true) bool isDrinker, // 飲酒有無（デフォルトtrue）
    @Default(1.0) double multiplier, // 支払い比率の重み付け（デフォルト1.0）
    @Default(0.0) double amountToPay, // 支払い額
    @Default(PaymentStatus.unpaid) PaymentStatus paymentStatus, // 支払いステータス
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _ParticipantModel;

  /// 新規作成用ファクトリ（デフォルト値を設定）
  factory ParticipantModel.create({
    required String eventId,
    required String userId,
    required String displayName,
    required String email,
    ParticipantRole role = ParticipantRole.participant,
    int? age,
    String? position,
    ParticipantGender gender = ParticipantGender.other,
    bool isDrinker = true,
  }) {
    final now = DateTime.now();
    // IDはFirestore側で自動生成されることを想定し、一時的に空文字を入れるか、呼び出し側で生成して渡す設計にする
    // ここでは呼び出し側でIDを決定して渡す形がFreezedのrequired idと整合しやすいが、
    // createメソッド内で uuid.v4() などを使うのも手。
    // 今回は既存実装に合わせて、呼び出し側が ID を生成して `copyWith` するか、
    // あるいはこのファクトリの引数に id を含める形にする。
    // 手軽なのは引数に optional String? id を加え、なければ空文字にしておく（保存時に documentRef.id で上書き）
    // ただし Modelの id は required なので、ここでは空文字を入れておき、
    // Service 保存時に `participant.copyWith(id: ref.id)` するパターンを想定する。

    return ParticipantModel(
      id: '', // 保存時にIDを上書きする必要あり
      eventId: eventId,
      userId: userId,
      displayName: displayName,
      email: email,
      role: role,
      age: age,
      position: position,
      gender: gender,
      isDrinker: isDrinker,
      joinedAt: now,
      updatedAt: now,
    );
  }

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

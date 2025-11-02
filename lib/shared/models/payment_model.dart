import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiharainu/shared/models/event_model.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// 支払い方法
enum PaymentMethod {
  @JsonValue('cash')
  cash, // 現金
  @JsonValue('card')
  card, // カード
  @JsonValue('transfer')
  transfer, // 振込
  @JsonValue('other')
  other, // その他
}

/// 支払いレコードモデル
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String eventId,
    required String participantId,
    required double amount,
    @TimestampConverter() required DateTime paidAt,
    @Default(PaymentMethod.cash) PaymentMethod paymentMethod,
    String? note, // メモ（オプション）
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  /// Firestoreドキュメントから作成
  factory PaymentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return PaymentModel.fromJson(data);
  }

  /// Firestore保存用のMapに変換（idを除外）
  static Map<String, dynamic> toFirestore(PaymentModel payment) {
    final json = payment.toJson();
    json.remove('id'); // Firestoreのドキュメント IDは別管理
    return json;
  }
}

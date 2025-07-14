import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String eventId,
    required String userId,
    required double amount,
    required PaymentStatus status,
    PaymentMethod? paymentMethod,
    String? transactionId,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}

enum PaymentMethod {
  @JsonValue('paypay')
  paypay,
  @JsonValue('linepay')
  linepay,
  @JsonValue('rakutenpay')
  rakutenpay,
  @JsonValue('bank')
  bank,
  @JsonValue('other')
  other,
}
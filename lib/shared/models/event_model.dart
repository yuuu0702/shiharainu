import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

/// イベントステータス
enum EventStatus {
  @JsonValue('planning')
  planning, // 計画中
  @JsonValue('active')
  active, // 進行中
  @JsonValue('completed')
  completed, // 完了
}

/// 支払い方法
enum PaymentType {
  @JsonValue('equal')
  equal, // 均等割り
  @JsonValue('proportional')
  proportional, // 比例配分（役職・年齢・性別による重み付け）
}

/// イベントモデル
@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    @TimestampConverter() required DateTime date,
    required List<String> organizerIds, // 複数の主催者をサポート
    @Default(0.0) double totalAmount,
    @Default(EventStatus.planning) EventStatus status,
    @Default(PaymentType.equal) PaymentType paymentType,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? inviteCode, // 招待コード（オプション）
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  /// Firestoreドキュメントから作成
  factory EventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return EventModel.fromJson(data);
  }

  /// Firestore保存用のMapに変換（idを除外）
  static Map<String, dynamic> toFirestore(EventModel event) {
    final json = event.toJson();
    json.remove('id'); // Firestoreのドキュメント IDは別管理
    return json;
  }
}

/// Timestamp <-> DateTime 変換用カスタムコンバーター
class TimestampConverter implements JsonConverter<DateTime, Object> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    throw Exception('Invalid timestamp format');
  }

  @override
  Object toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

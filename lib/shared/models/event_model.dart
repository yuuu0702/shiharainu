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

/// イベント種別
enum EventType {
  @JsonValue('drinking_party')
  drinkingParty, // 飲み会
  @JsonValue('welcome_party')
  welcomeParty, // 歓送迎会
  @JsonValue('year_end_party')
  yearEndParty, // 忘年会・新年会
  @JsonValue('other')
  other, // その他
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
    @Default(EventType.other)
    @EventTypeConverter()
    EventType eventType, // イベント種別
    @TimestampConverter() required DateTime date,
    required List<String> organizerIds, // 複数の主催者をサポート
    @Default(0.0) double totalAmount,
    @Default(EventStatus.planning) EventStatus status,
    @Default(PaymentType.equal) PaymentType paymentType,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? inviteCode, // 招待コード（オプション）
    String? parentEventId, // 親イベントID（二次会の場合のみ）
    @Default([]) List<String> childEventIds, // 子イベントID配列（二次会リスト）
    @Default(false) bool isAfterParty, // 二次会フラグ
    String? paymentUrl, // 支払いリンク（PayPay URLなど）
    String? paymentNote, // 支払いメモ（ID、口座情報など）
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
  DateTime fromJson(Object? json) {
    if (json == null) {
      return DateTime.now(); // Fallback for missing timestamps
    }
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.tryParse(json) ?? DateTime.now();
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  @override
  Object toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

/// EventType 変換用カスタムコンバーター
///
/// 過去のデータ（camelCase）と現在のデータ（snake_case）の両方をサポートします。
class EventTypeConverter implements JsonConverter<EventType, String> {
  const EventTypeConverter();

  @override
  EventType fromJson(String? json) {
    if (json == null) return EventType.other;
    switch (json) {
      // Legacy camelCase values
      case 'drinkingParty':
        return EventType.drinkingParty;
      case 'welcomeParty':
        return EventType.welcomeParty;
      case 'yearEndParty':
        return EventType.yearEndParty;
      // Standard snake_case values
      case 'drinking_party':
        return EventType.drinkingParty;
      case 'welcome_party':
        return EventType.welcomeParty;
      case 'year_end_party':
        return EventType.yearEndParty;
      case 'other':
      default:
        // 未知の値はその他扱いにする（エラーを防ぐ）
        return EventType.other;
    }
  }

  @override
  String toJson(EventType object) {
    switch (object) {
      case EventType.drinkingParty:
        return 'drinking_party';
      case EventType.welcomeParty:
        return 'welcome_party';
      case EventType.yearEndParty:
        return 'year_end_party';
      case EventType.other:
        return 'other';
    }
  }
}

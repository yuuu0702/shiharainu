import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    required String organizerId,
    required double totalAmount,
    required DateTime eventDate,
    required DateTime paymentDeadline,
    required String venue,
    required ProportionalPattern proportionalPattern,
    @Default([]) List<String> participantIds,
    @Default(EventStatus.active) EventStatus status,
    String? qrCode,
    String? shareUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
class ProportionalPattern with _$ProportionalPattern {
  const factory ProportionalPattern({
    required String id,
    required String name,
    required Map<String, double> roleMultipliers,
    required Map<String, double> ageMultipliers,
    required Map<String, double> genderMultipliers,
    required double drinkingMultiplier,
    required double nonDrinkingMultiplier,
    @Default(false) bool isCustom,
  }) = _ProportionalPattern;

  factory ProportionalPattern.fromJson(Map<String, dynamic> json) =>
      _$ProportionalPatternFromJson(json);
}

enum EventStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}
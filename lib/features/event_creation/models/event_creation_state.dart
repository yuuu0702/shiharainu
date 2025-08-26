import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_creation_state.freezed.dart';

@freezed
class EventCreationState with _$EventCreationState {
  const factory EventCreationState({
    @Default('') String eventName,
    @Default('') String description,
    @Default(0.0) double totalAmount,
    @Default([]) List<String> participantEmails,
    @Default(false) bool isLoading,
    String? error,
  }) = _EventCreationState;
}
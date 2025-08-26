import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiharainu/features/event_creation/models/event_creation_state.dart';
import 'package:shiharainu/shared/models/event_model.dart';

// EventCreationViewModel - 従来のStateNotifierアプローチ
class EventCreationViewModel extends StateNotifier<EventCreationState> {
  EventCreationViewModel() : super(const EventCreationState());

  void updateEventName(String name) {
    state = state.copyWith(eventName: name);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateTotalAmount(double amount) {
    state = state.copyWith(totalAmount: amount);
  }

  void addParticipant(String email) {
    final participants = [...state.participantEmails, email];
    state = state.copyWith(participantEmails: participants);
  }

  void removeParticipant(String email) {
    final participants = state.participantEmails
        .where((e) => e != email)
        .toList();
    state = state.copyWith(participantEmails: participants);
  }

  Future<bool> createEvent() async {
    if (state.eventName.isEmpty || state.totalAmount <= 0) {
      state = state.copyWith(error: 'イベント名と金額を入力してください');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 実際のイベント作成ロジックを実装
      final _ = EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: state.eventName,
        description: state.description,
        totalAmount: state.totalAmount,
        organizerId: 'current-user-id', // TODO: 実際の認証ユーザーIDを取得
        status: EventStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        eventDate: DateTime.now().add(const Duration(days: 7)),
        venue: 'TBD',
        paymentDeadline: DateTime.now().add(const Duration(days: 3)),
        proportionalPattern: ProportionalPattern(
          id: 'default',
          name: 'デフォルトパターン',
          roleMultipliers: const {},
          ageMultipliers: const {},
          genderMultipliers: const {},
          drinkingMultiplier: 1.0,
          nonDrinkingMultiplier: 0.8,
        ),
      );

      // シミュレーション用の遅延
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'イベントの作成に失敗しました: $e',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const EventCreationState();
  }
}

// プロバイダー定義
final eventCreationViewModelProvider = StateNotifierProvider<EventCreationViewModel, EventCreationState>((ref) {
  return EventCreationViewModel();
});
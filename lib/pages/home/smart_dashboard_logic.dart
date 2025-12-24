import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';

part 'smart_dashboard_logic.freezed.dart';

enum SmartActionType {
  pay, // 支払いが必要 (最優先)
  checkStatus, // 幹事として状況確認 (期限が近いなど)
  create, // イベント作成 (予定なし)
  join, // イベント参加 (予定なし)
  wait, // 予定はあるが特にアクション不要
}

@freezed
class SmartAction with _$SmartAction {
  const factory SmartAction({
    required SmartActionType type,
    String? eventId,
    String? title,
    String? subTitle,
    DateTime? eventDate,
    required int priority, // 優先度 (高いほど優先)
  }) = _SmartAction;
}

/// スマートダッシュボードのロジック
class SmartDashboardLogic {
  /// イベントリストから最適なアクションを決定する
  static SmartAction determinePrimaryAction({
    required List<EventModel> events,
    required List<ParticipantModel> myParticipations, // 自分が参加している参加者データ
    required String currentUserId,
  }) {
    if (events.isEmpty) {
      final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
      if (isGuest) {
        return const SmartAction(
          type: SmartActionType.join,
          title: '招待コードをお持ちですか？',
          subTitle: '招待リンクからイベントに参加しましょう',
          priority: 0,
        );
      }
      return const SmartAction(
        type: SmartActionType.create,
        title: '新しいイベントを企画しませんか？',
        subTitle: '仲間を誘って楽しい時間を過ごしましょう',
        priority: 0,
      );
    }

    final now = DateTime.now();
    SmartAction? bestAction;

    for (final event in events) {
      // 自分の参加データを検索
      final myParticipation = myParticipations.firstWhere(
        (p) => p.eventId == event.id,
        orElse: () =>
            throw Exception('Participation not found for event ${event.id}'),
      );

      // 1. 支払いが必要な場合 (最優先: Priority 100)
      if (myParticipation.role == ParticipantRole.participant &&
          myParticipation.paymentStatus == PaymentStatus.unpaid &&
          myParticipation.amountToPay > 0) {
        final action = SmartAction(
          type: SmartActionType.pay,
          eventId: event.id,
          title: '${event.title}の支払いがまだです',
          subTitle: '${myParticipation.amountToPay.toInt()}円の支払いが必要です',
          eventDate: event.date,
          priority: 100,
        );

        // より優先度が高い、または同じ優先度なら日付が近いものを採用
        if (bestAction == null || action.priority > bestAction.priority) {
          bestAction = action;
        } else if (action.priority == bestAction.priority &&
            event.date.isBefore(bestAction.eventDate!)) {
          bestAction = action;
        }
        continue;
      }

      // 2. 自分が幹事で、開催日が近い (3日以内) 場合 (Priority 80)
      final daysUntil = event.date.difference(now).inDays;
      if (myParticipation.role == ParticipantRole.organizer &&
          daysUntil >= 0 &&
          daysUntil <= 3) {
        final action = SmartAction(
          type: SmartActionType.checkStatus,
          eventId: event.id,
          title: '${event.title}が近づいています',
          subTitle: 'あと${daysUntil == 0 ? "今日" : "$daysUntil日"}です。準備は順調ですか？',
          eventDate: event.date,
          priority: 80,
        );

        if (bestAction == null || action.priority > bestAction.priority) {
          bestAction = action;
        }
        continue;
      }

      // 3. 支払い確認待ち（自分が参加者） (Priority 50)
      if (myParticipation.role == ParticipantRole.participant &&
          myParticipation.paymentStatus == PaymentStatus.pending) {
        // 特にアクションは不要だが、表示はしてもいいかも。今回はスキップまたはWait
      }
    }

    // アクションがない場合
    if (bestAction == null) {
      // 直近のイベントがあればそれを表示 (Wait)
      final upcomingEvents =
          events
              .where(
                (e) => e.date.isAfter(now.subtract(const Duration(hours: 24))),
              )
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

      if (upcomingEvents.isNotEmpty) {
        final nextEvent = upcomingEvents.first;
        return SmartAction(
          type: SmartActionType.wait,
          eventId: nextEvent.id,
          title: '次のイベント: ${nextEvent.title}',
          subTitle: '楽しみに待ちましょう！',
          eventDate: nextEvent.date,
          priority: 10,
        );
      }

      return const SmartAction(
        type: SmartActionType.create,
        title: '新しいイベントを企画しませんか？',
        subTitle: '次の予定を立てましょう',
        priority: 0,
      );
    }

    return bestAction;
  }
}

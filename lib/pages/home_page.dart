// Governed by Skill: shiharainu-general-design
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';
import 'package:shiharainu/pages/home/home_welcome_section.dart';
import 'package:shiharainu/pages/home/home_quick_actions.dart';
import 'package:shiharainu/pages/home/home_notifications_section.dart';
import 'package:shiharainu/pages/home/home_events_section.dart';
import 'package:shiharainu/pages/home/home_activity_summary.dart';

/// ホームページ
///
/// アプリのメインダッシュボード。ウェルカムメッセージ、クイックアクション、
/// 通知、イベント、活動サマリーを表示します。
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 犬のアイコンリスト（しはらいぬにちなんで）
  static const List<String> _dogEmojis = ['🐕', '🐶', '🦮', '🐕‍🦺', '🎾🐕'];

  // パフォーマンス最適化：ランダム生成をウィジェット初期化時に実行
  late final String _selectedDogEmoji;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _selectedDogEmoji = _dogEmojis[random.nextInt(_dogEmojis.length)];
  }

  // サンプルデータ - 近日中のイベントのみ（3件まで）
  static final List<EventData> _upcomingEvents = [
    EventData(
      id: '1',
      title: '新年会2024',
      description: '会社の新年会です',
      date: DateTime.now().add(const Duration(days: 2)),
      participantCount: 15,
      role: EventRole.organizer,
      status: EventStatus.active,
    ),
    EventData(
      id: '2',
      title: 'チーム懇親会',
      description: 'プロジェクト打ち上げ',
      date: DateTime.now().add(const Duration(days: 7)),
      participantCount: 8,
      role: EventRole.participant,
      status: EventStatus.planning,
    ),
    EventData(
      id: '3',
      title: '送別会',
      description: '田中さんの送別会',
      date: DateTime.now().add(const Duration(days: 14)),
      participantCount: 12,
      role: EventRole.participant,
      status: EventStatus.active,
    ),
  ];

  // 重要な通知のみ（最大2件）
  static final List<NotificationData> _importantNotifications = [
    NotificationData(
      id: '1',
      type: NotificationType.paymentReminder,
      title: '支払い未完了',
      message: '新年会の参加費をお支払いください',
      eventTitle: '新年会2024',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationData(
      id: '2',
      type: NotificationType.invitation,
      title: 'イベント招待',
      message: 'チーム懇親会に招待されました',
      eventTitle: 'チーム懇親会',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (profile) {
        return SimplePage(
          title: 'ホーム',
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
              await Future.delayed(const Duration(milliseconds: 800));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ウェルカムセクション
                  HomeWelcomeSection(
                    userName: profile?.name ?? 'ゲスト',
                    dogEmoji: _selectedDogEmoji,
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // アクションカード（主要機能へのショートカット）
                  const HomeQuickActions(),
                  const SizedBox(height: AppTheme.spacing24),

                  // 重要な通知（2件まで）
                  if (_importantNotifications.isNotEmpty) ...[
                    HomeNotificationsSection(
                      notifications: _importantNotifications,
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                  ],

                  // 近日中のイベント（3件まで）
                  HomeEventsSection(events: _upcomingEvents),
                  const SizedBox(height: AppTheme.spacing24),

                  // 今月の活動サマリー
                  const HomeActivitySummary(),

                  // 下部余白
                  const SizedBox(height: AppTheme.spacing32),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => SimplePage(
        title: 'ホーム',
        body: const Center(
          child: AppProgress.circular(
            size: AppProgressSize.large,
            label: 'データを読み込み中...',
          ),
        ),
      ),
      error: (error, stack) {
        return SimplePage(
          title: 'ホーム',
          body: Center(
            child: AppErrorWidget.networkError(
              onRetry: () {
                ref.invalidate(userProfileProvider);
              },
            ),
          ),
        );
      },
    );
  }
}

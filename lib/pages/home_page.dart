import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 犬のアイコンリスト（しはらいぬにちなんで）
  static const List<String> _dogEmojis = ['🐕', '🐶', '🦮', '🐕‍🦺', '🎾🐕'];

  // ランダムな犬アイコンを取得
  String get _randomDogEmoji {
    final random = Random();
    return _dogEmojis[random.nextInt(_dogEmojis.length)];
  }

  // サンプルデータ - 近日中のイベントのみ（3件まで）
  final List<EventData> _upcomingEvents = [
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
  final List<NotificationData> _importantNotifications = [
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
          actions: [
            // 通知ベルアイコン（未読バッジ付き）
            _buildNotificationIcon(),
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              // データの再読み込み
              ref.invalidate(userProfileProvider);
              await Future.delayed(const Duration(milliseconds: 800));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ウェルカムセクション（簡潔に）
                  _buildWelcomeSection(context, profile),
                  const SizedBox(height: AppTheme.spacing24),

                  // アクションカード（主要機能へのショートカット）
                  _buildQuickActionsSection(context),
                  const SizedBox(height: AppTheme.spacing24),

                  // 重要な通知（2件まで）
                  if (_importantNotifications.isNotEmpty) ...[
                    _buildImportantNotificationsSection(context),
                    const SizedBox(height: AppTheme.spacing24),
                  ],

                  // 近日中のイベント（3件まで）
                  _buildUpcomingEventsSection(context),
                  const SizedBox(height: AppTheme.spacing24),

                  // 今月の活動サマリー（簡素化）
                  _buildActivitySummarySection(context),

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

  Widget _buildWelcomeSection(BuildContext context, profile) {
    return AppCard(
      child: Row(
        children: [
          // シンプルなアバター
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _randomDogEmoji,
                style: AppTheme.displayMedium,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),

          // ウェルカムメッセージ（シンプルに）
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'おかえりなさい',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  profile?.name ?? 'ゲスト',
                  style: AppTheme.headlineLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'よく使う機能',
          style: AppTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.add_circle_outline,
                title: 'イベント作成',
                subtitle: '新しいイベントを企画',
                onTap: () => context.go('/events/create'),
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.event_outlined,
                title: 'イベント一覧',
                subtitle: '参加中のイベント',
                onTap: () => context.go('/events'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            subtitle,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.mutedForegroundAccessible,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotificationsSection(BuildContext context) {
    final unreadNotifications = _importantNotifications.where((n) => !n.isRead).take(2).toList();

    if (unreadNotifications.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '重要な通知',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/notifications'),
              child: const Text('すべて見る'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        ...unreadNotifications.map((notification) => 
          _buildNotificationCard(context, notification)).toList(),
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationData notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing2),
                  Text(
                    notification.message,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.mutedForegroundAccessible,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection(BuildContext context) {
    final upcomingEvents = _upcomingEvents.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '近日中のイベント',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/events'),
              child: const Text('すべて見る'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),

        if (upcomingEvents.isEmpty)
          AppCard(
            child: Column(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 48,
                  color: AppTheme.mutedForegroundAccessible,
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  '近日中のイベントはありません',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                AppButton.outline(
                  text: 'イベントを作成',
                  size: AppButtonSize.small,
                  onPressed: () => context.go('/events/create'),
                ),
              ],
            ),
          )
        else
          ...upcomingEvents.map((event) => _buildEventCard(context, event)).toList(),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: AppCard(
        onTap: () => context.go('/events/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        event.description,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.mutedForegroundAccessible,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: _getEventStatusColor(event).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: _getEventStatusColor(event).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _getEventDaysUntil(event),
                    style: AppTheme.bodySmall.copyWith(
                      color: _getEventStatusColor(event),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: AppTheme.mutedForegroundAccessible,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  '${event.participantCount}人',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Icon(
                  event.role == EventRole.organizer 
                    ? Icons.admin_panel_settings_outlined
                    : Icons.person_outline,
                  size: 16,
                  color: AppTheme.mutedForegroundAccessible,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  event.role == EventRole.organizer ? '幹事' : '参加者',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySummarySection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今月の活動',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.event_outlined,
                  label: '参加イベント',
                  value: '3',
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.payments_outlined,
                  label: '支払い完了',
                  value: '2',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.group_outlined,
                  label: '新しい友人',
                  value: '5',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.mutedForegroundAccessible,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
        return AppTheme.destructiveColor;
      case NotificationType.invitation:
        return AppTheme.primaryColor;
      case NotificationType.general:
        return AppTheme.infoColor;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
        return Icons.payment;
      case NotificationType.invitation:
        return Icons.mail_outline;
      case NotificationType.general:
        return Icons.info_outline;
    }
  }

  Color _getEventStatusColor(EventData event) {
    final now = DateTime.now();
    final difference = event.date.difference(now).inDays;

    if (difference <= 1) {
      return AppTheme.destructiveColor; // 緊急
    } else if (difference <= 3) {
      return AppTheme.warningColor; // 注意
    } else {
      return AppTheme.primaryColor; // 通常
    }
  }

  String _getEventDaysUntil(EventData event) {
    final now = DateTime.now();
    final difference = event.date.difference(now).inDays;

    if (difference < 0) {
      return '終了';
    } else if (difference == 0) {
      return '今日';
    } else if (difference == 1) {
      return '明日';
    } else {
      return 'あと${difference}日';
    }
  }

  // 通知ベルアイコン（未読バッジ付き）を構築
  Widget _buildNotificationIcon() {
    final unreadCount = _importantNotifications.where((n) => !n.isRead).length;

    return Stack(
      children: [
        IconButton(
          onPressed: () => context.go('/notifications'),
          icon: const Icon(Icons.notifications_outlined, size: 24),
          tooltip: '通知を確認',
        ),
        // 未読バッジ
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              decoration: const BoxDecoration(
                color: AppTheme.destructiveColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: AppTheme.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// データモデル（既存のものを使用）
class EventData {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int participantCount;
  final EventRole role;
  final EventStatus status;

  const EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.participantCount,
    required this.role,
    required this.status,
  });
}

enum EventRole { organizer, participant }
enum EventStatus { planning, active, completed }

class NotificationData {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? eventTitle;
  final DateTime createdAt;
  final bool isRead;

  const NotificationData({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.eventTitle,
    required this.createdAt,
    required this.isRead,
  });
}

enum NotificationType {
  invitation,
  paymentReminder,
  general,
}
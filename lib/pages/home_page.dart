import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // サンプルデータ - 実際のアプリではRiverpodプロバイダーから取得
  final List<EventData> _organizerEvents = [
    EventData(
      id: '1',
      title: '新年会2024',
      description: '会社の新年会です',
      date: DateTime.now().add(const Duration(days: 7)),
      participantCount: 15,
      role: EventRole.organizer,
      status: EventStatus.active,
    ),
    EventData(
      id: '2',
      title: 'チーム懇親会',
      description: 'プロジェクト打ち上げ',
      date: DateTime.now().add(const Duration(days: 14)),
      participantCount: 8,
      role: EventRole.organizer,
      status: EventStatus.planning,
    ),
    EventData(
      id: '3',
      title: '送別会',
      description: '田中さんの送別会',
      date: DateTime.now().add(const Duration(days: 3)),
      participantCount: 12,
      role: EventRole.organizer,
      status: EventStatus.active,
    ),
  ];

  final List<EventData> _participantEvents = [
    EventData(
      id: '4',
      title: '歓送迎会',
      description: '春の歓送迎会',
      date: DateTime.now().add(const Duration(days: 21)),
      participantCount: 25,
      role: EventRole.participant,
      status: EventStatus.active,
    ),
    EventData(
      id: '5',
      title: '部署BBQ',
      description: '夏のBBQ大会',
      date: DateTime.now().add(const Duration(days: 35)),
      participantCount: 30,
      role: EventRole.participant,
      status: EventStatus.active,
    ),
    EventData(
      id: '6',
      title: '忘年会2024',
      description: '年末の懇親会',
      date: DateTime.now().add(const Duration(days: 60)),
      participantCount: 40,
      role: EventRole.participant,
      status: EventStatus.planning,
    ),
    EventData(
      id: '7',
      title: '結婚式二次会',
      description: '山田夫妻の結婚式二次会',
      date: DateTime.now().add(const Duration(days: 45)),
      participantCount: 35,
      role: EventRole.participant,
      status: EventStatus.active,
    ),
  ];

  // 通知データ - 実際のアプリではRiverpodプロバイダーから取得
  final List<NotificationData> _notifications = [
    NotificationData(
      id: '1',
      type: NotificationType.invitation,
      title: 'イベント招待',
      message: '「部署BBQ」に招待されました',
      eventTitle: '部署BBQ',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationData(
      id: '2',
      type: NotificationType.paymentReminder,
      title: '支払い未完了',
      message: '「新年会2024」の支払い期限が過ぎています',
      eventTitle: '新年会2024',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
    ),
    NotificationData(
      id: '3',
      type: NotificationType.general,
      title: '一般的なお知らせ',
      message: '参加確認が遅いています',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  // ボトムナビゲーション項目
  static const List<AppBottomNavigationItem> _navigationItems = [
    AppBottomNavigationItem(
      label: 'イベント一覧',
      icon: Icons.event_note_outlined,
      route: '/home',
    ),
    AppBottomNavigationItem(
      label: '支払い管理',
      icon: Icons.payment_outlined,
      route: '/payment-management',
    ),
    AppBottomNavigationItem(
      label: '通知',
      icon: Icons.notifications_outlined,
      route: '/notifications',
    ),
    AppBottomNavigationItem(
      label: 'アカウント情報',
      icon: Icons.account_circle_outlined,
      route: '/account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePageScaffold(
      title: 'アプリホーム',
      navigationItems: _navigationItems,
      currentRoute: '/home',
      actions: [
        AppButton.primary(
          text: 'イベント作成',
          icon: const Icon(Icons.add, size: 18),
          size: AppButtonSize.small,
          onPressed: () => context.go('/events/create'),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'components') {
              context.go('/components');
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'components',
              child: ListTile(
                leading: Icon(Icons.palette),
                title: Text('コンポーネント素材集'),
              ),
            ),
          ],
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // お知らせセクション
            _buildNotificationSection(),
            const SizedBox(height: AppTheme.spacing24),
            
            // イベント一覧セクション
            _buildEventListSection(),
            const SizedBox(height: AppTheme.spacing24),
            
            // 今月のランキングセクション
            _buildRankingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    // 未読通知のみ表示
    final unreadNotifications = _notifications.where((n) => !n.isRead).toList();
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                'お知らせ',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const Spacer(),
              if (unreadNotifications.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.destructive,
                    borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  ),
                  child: Text(
                    '${unreadNotifications.length}',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          
          if (unreadNotifications.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.mutedColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '新しい通知はありません',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...unreadNotifications.map((notification) => 
              _buildNotificationItem(notification)).toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationData notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: _getNotificationBackgroundColor(notification.type),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: _getNotificationBorderColor(notification.type),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getNotificationIcon(notification.type),
            size: 20,
            color: _getNotificationIconColor(notification.type),
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  _formatNotificationTime(notification.createdAt),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.invitation:
        return Icons.event_outlined;
      case NotificationType.paymentReminder:
        return Icons.payment_outlined;
      case NotificationType.general:
        return Icons.info_outline;
    }
  }

  Color _getNotificationIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.invitation:
        return AppTheme.primaryColor;
      case NotificationType.paymentReminder:
        return AppTheme.destructive;
      case NotificationType.general:
        return AppTheme.mutedForeground;
    }
  }

  Color _getNotificationBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.invitation:
        return AppTheme.primaryColor.withOpacity(0.05);
      case NotificationType.paymentReminder:
        return AppTheme.destructive.withOpacity(0.05);
      case NotificationType.general:
        return AppTheme.mutedColor;
    }
  }

  Color _getNotificationBorderColor(NotificationType type) {
    switch (type) {
      case NotificationType.invitation:
        return AppTheme.primaryColor.withOpacity(0.2);
      case NotificationType.paymentReminder:
        return AppTheme.destructive.withOpacity(0.2);
      case NotificationType.general:
        return AppTheme.mutedForeground.withOpacity(0.2);
    }
  }

  String _formatNotificationTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}分前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  Widget _buildEventListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'イベント一覧',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        // 幹事として管理中のイベント
        if (_organizerEvents.isNotEmpty) ...[
          _buildEventSubSection('幹事として管理中のイベント', _organizerEvents),
          const SizedBox(height: AppTheme.spacing20),
        ],
        
        // 参加者として入っているイベントリスト
        if (_participantEvents.isNotEmpty) ...[
          _buildEventSubSection('参加者として入っているイベントリスト', _participantEvents),
        ],
        
        // 空状態
        if (_organizerEvents.isEmpty && _participantEvents.isEmpty)
          _buildEmptyEventState(),
      ],
    );
  }

  Widget _buildEventSubSection(String title, List<EventData> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.mutedColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        // イベントカードリスト
        ...events.map((event) => _buildEventCard(event)).toList(),
      ],
    );
  }

  Widget _buildEventCard(EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: AppCard(
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
                        style: AppTheme.headlineSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        event.description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.mutedForeground,
                        ),
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
                    color: _getStatusColor(event.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: _getStatusColor(event.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(event.status),
                    style: AppTheme.bodySmall.copyWith(
                      color: _getStatusColor(event.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppTheme.mutedForeground,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  _formatDate(event.date),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: AppTheme.mutedForeground,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  '${event.participantCount}人',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return AppTheme.mutedForeground;
      case EventStatus.active:
        return AppTheme.primaryColor;
      case EventStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return '準備中';
      case EventStatus.active:
        return '開催中';
      case EventStatus.completed:
        return '終了';
    }
  }


  Widget _buildRankingSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今月のランキング何位',
            style: AppTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          // ユーザー情報エリア
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.inputBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: AppTheme.mutedColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // ランキング表示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing16,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      ),
                      child: Text(
                        '3位',
                        style: AppTheme.headlineSmall.copyWith(
                          color: AppTheme.primaryForeground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                
                // ユーザー情報ボタン群
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        text: 'ユーザー情報',
                        size: AppButtonSize.small,
                        onPressed: () {
                          // ユーザー情報画面へ遷移
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: AppButton.outline(
                        text: 'ユーザー情報',
                        size: AppButtonSize.small,
                        onPressed: () {
                          // ユーザー情報画面へ遷移
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: AppButton.outline(
                        text: 'ユーザー情報',
                        size: AppButtonSize.small,
                        onPressed: () {
                          // ユーザー情報画面へ遷移
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                AppButton.secondary(
                  text: '詳しく',
                  onPressed: () {
                    // ランキング詳細画面へ遷移
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEventState() {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacing16),
          Icon(
            Icons.event_outlined,
            size: 48,
            color: AppTheme.mutedForeground,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'イベントがありません',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            '新しいイベントを作成するか\nイベントの招待を受けてみましょう',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          AppButton.primary(
            text: 'イベントを作成',
            icon: const Icon(Icons.add, size: 18),
            size: AppButtonSize.small,
            onPressed: () => context.go('/events/create'),
          ),
          const SizedBox(height: AppTheme.spacing16),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return '今日';
    } else if (difference == 1) {
      return '明日';
    } else if (difference < 7) {
      return '${difference}日後';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}

// データモデル（実際のアプリではshared/modelsに移動）
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

enum EventRole {
  organizer,
  participant,
}

enum EventStatus {
  planning,
  active,
  completed,
}

// 通知データモデル（実際のアプリではshared/modelsに移動）
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
  invitation,      // イベント招待
  paymentReminder, // 支払い未完了
  general,         // 一般的なお知らせ
}
// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // サンプル通知データ
  final List<NotificationData> _notifications = [
    NotificationData(
      id: '1',
      title: '支払い期限が近づいています',
      message: '新年会2024の会費支払い期限まであと2日です',
      type: NotificationType.warning,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationData(
      id: '2',
      title: '新しいイベントに招待されました',
      message: '春の歓送迎会にご招待いただきました',
      type: NotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationData(
      id: '3',
      title: '支払い完了のお知らせ',
      message: 'チーム懇親会の会費のお支払いが完了しました',
      type: NotificationType.success,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationData(
      id: '4',
      title: 'イベントがキャンセルされました',
      message: '部署BBQが天候不良のためキャンセルとなりました',
      type: NotificationType.error,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationData(
      id: '5',
      title: '参加者が更新されました',
      message: '忘年会2024に新たに5名の参加者が追加されました',
      type: NotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return SimplePage(
      title: '通知',
      leading: AppButton.icon(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (unreadCount > 0)
          AppButton.outline(
            text: 'すべて既読',
            size: AppButtonSize.small,
            onPressed: _markAllAsRead,
          ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationData notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNotificationTap(notification),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppTheme.inputBackground
                  : AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(
                color: notification.isRead
                    ? AppTheme.mutedColor
                    : AppTheme.primaryColor.withValues(alpha: 0.2),
                width: notification.isRead ? 1 : 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 通知アイコン
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(
                          notification.type,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                      ),
                      child: Icon(
                        _getTypeIcon(notification.type),
                        size: 20,
                        color: _getTypeColor(notification.type),
                      ),
                    ),

                    const SizedBox(width: AppTheme.spacing12),

                    // 通知内容
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: AppTheme.headlineSmall.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacing8),
                          Text(
                            notification.message,
                            style: AppTheme.bodyMedium.copyWith(
                              color: notification.isRead
                                  ? AppTheme.mutedForeground
                                  : AppTheme.foregroundColor,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing8),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.mutedForegroundAccessible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // アクションボタン（未読の場合）
                if (!notification.isRead) ...[
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.ghost(
                        text: '既読にする',
                        size: AppButtonSize.small,
                        onPressed: () => _markAsRead(notification),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 48,
              color: AppTheme.mutedForeground,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              '通知はありません',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'イベントの更新や支払い期限などの\nお知らせがここに表示されます',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return AppTheme.destructiveColor;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }

  void _onNotificationTap(NotificationData notification) {
    if (!notification.isRead) {
      _markAsRead(notification);
    }

    // 通知タイプに応じて適切なページに遷移
    switch (notification.type) {
      case NotificationType.warning:
        // 支払い関連の通知 → 支払い管理画面
        context.go('/payment-management');
        break;
      case NotificationType.info:
        // イベント関連の通知 → イベント一覧画面
        context.go('/events');
        break;
      default:
        // その他の通知は詳細表示などの処理を追加予定
        break;
    }
  }

  void _markAsRead(NotificationData notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    // 実際のアプリでは通知データを再取得
    await Future.delayed(const Duration(seconds: 1));

    // TODO(Issue #45): 通知システムの完成
    // NotificationServiceを使用して通知データを再取得する実装が必要
    // - Firestoreからリアルタイム通知取得
    // - 未読通知数の更新
    // final newNotifications = await NotificationService.fetchNotifications();

    setState(() {
      // 新しい通知があれば追加
    });
  }
}

// データモデル
class NotificationData {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  NotificationData copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { info, success, warning, error }

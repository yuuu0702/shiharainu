import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';

/// ホームページの通知セクション
class HomeNotificationsSection extends StatelessWidget {
  final List<NotificationData> notifications;

  const HomeNotificationsSection({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = notifications
        .where((n) => !n.isRead)
        .take(2)
        .toList();

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
        ...unreadNotifications.map(
          (notification) => _buildNotificationCard(context, notification),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationData notification,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: _getNotificationColor(
                  notification.type,
                ).withValues(alpha: 0.1),
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
}

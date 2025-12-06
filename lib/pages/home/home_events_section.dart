import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';

/// ホームページのイベントセクション
class HomeEventsSection extends StatelessWidget {
  final List<EventData> events;

  const HomeEventsSection({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = events.take(3).toList();

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
                const Icon(
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
          ...upcomingEvents.map((event) => _buildEventCard(context, event)),
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
                const Icon(
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
      return 'あと$difference日';
    }
  }
}

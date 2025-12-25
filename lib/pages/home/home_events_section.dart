import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';

/// ホームページのイベントセクション
class HomeEventsSection extends StatelessWidget {
  final List<EventData> events;

  const HomeEventsSection({super.key, required this.events});

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
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                textStyle: AppTheme.labelMedium,
              ),
              child: const Text('すべて見る'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),

        if (upcomingEvents.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing32,
              horizontal: AppTheme.spacing24,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.elevationLow,
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      size: 32,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    (FirebaseAuth.instance.currentUser?.isAnonymous ?? false)
                        ? 'イベントに参加しましょう'
                        : 'イベントをはじめよう',
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppTheme.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    (FirebaseAuth.instance.currentUser?.isAnonymous ?? false)
                        ? '招待コードを入力して、\n支払いや精算に参加できます。'
                        : '新しいイベントを作成して、\n友人とスムーズに割り勘しましょう。',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  (FirebaseAuth.instance.currentUser?.isAnonymous ?? false)
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const JoinEventDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing24,
                              vertical: AppTheme.spacing12,
                            ),
                          ),
                          child: const Text('招待コードを入力'),
                        )
                      : ElevatedButton(
                          onPressed: () => context.go('/events/create'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing24,
                              vertical: AppTheme.spacing12,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Text('イベントを作成'),
                            ],
                          ),
                        ),
                ],
              ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.mutedColor),
        boxShadow: AppTheme.elevationLow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/events/${event.id}'),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing12,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: _getUrgencyColor(event).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                        border: Border.all(
                          color: _getUrgencyColor(event).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'あと',
                            style: AppTheme.labelSmall.copyWith(
                              color: _getUrgencyColor(event),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getEventDaysUntilNumber(event),
                            style: AppTheme.headlineMedium.copyWith(
                              color: _getUrgencyColor(event),
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '日',
                            style: AppTheme.labelSmall.copyWith(
                              color: _getUrgencyColor(event),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (event.role == EventRole.organizer)
                                Container(
                                  margin: const EdgeInsets.only(
                                    right: AppTheme.spacing8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusRound,
                                    ),
                                  ),
                                  child: Text(
                                    '幹事',
                                    style: AppTheme.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: AppTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppTheme.mutedForegroundAccessible,
                              ),
                              const SizedBox(width: AppTheme.spacing4),
                              Text(
                                _formatDate(event.date),
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.mutedForegroundAccessible,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing12),
                              const Icon(
                                Icons.people,
                                size: 14,
                                color: AppTheme.mutedForegroundAccessible,
                              ),
                              const SizedBox(width: AppTheme.spacing4),
                              Text(
                                '${event.participantCount}人',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.mutedForegroundAccessible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // 簡易的な日付フォーマット
    return '${date.month}/${date.day}';
  }

  String _getEventDaysUntilNumber(EventData event) {
    final now = DateTime.now();
    final difference = event.date.difference(now).inDays;
    return difference < 0 ? '0' : difference.toString();
  }

  Color _getUrgencyColor(EventData event) {
    final now = DateTime.now();
    final difference = event.date.difference(now).inDays;

    if (difference <= 3) {
      return AppTheme.destructiveColor; // Urgent
    } else if (difference <= 7) {
      return AppTheme.warningColor; // Upcoming
    } else {
      return AppTheme.primaryColor; // Normal
    }
  }
}

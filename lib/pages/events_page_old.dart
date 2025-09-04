import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'イベント一覧',
      actions: [
        AppButton.primary(
          text: 'イベント作成',
          icon: const Icon(Icons.add, size: 18),
          size: AppButtonSize.small,
          onPressed: () => context.go('/events/create'),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 幹事として管理中のイベント
            if (_organizerEvents.isNotEmpty) ...[
              _buildEventSection('幹事として管理中', _organizerEvents),
              const SizedBox(height: AppTheme.spacing24),
            ],

            // 参加者として入っているイベントリスト
            if (_participantEvents.isNotEmpty) ...[
              _buildEventSection('参加中', _participantEvents),
            ],

            // 空状態
            if (_organizerEvents.isEmpty && _participantEvents.isEmpty)
              _buildEmptyEventState(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSection(String title, List<EventData> events) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          // イベントカードリスト
          ...events.map((event) => _buildEventCard(event)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/events/${event.id}'),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.inputBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(color: AppTheme.mutedColor, width: 1),
            ),
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
                        color: _getStatusColor(event).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        border: Border.all(
                          color: _getStatusColor(event).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getStatusText(event),
                        style: AppTheme.bodySmall.copyWith(
                          color: _getStatusColor(event),
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
        ),
      ),
    );
  }

  Color _getStatusColor(EventData event) {
    final now = DateTime.now();
    final eventDate = event.date;

    // 開催日が過去の場合
    if (eventDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return Colors.green;
    }

    // 開催日が未来の場合
    return AppTheme.primaryColor;
  }

  String _getStatusText(EventData event) {
    final now = DateTime.now();
    final eventDate = event.date;
    final difference = eventDate
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    // 開催日が過去の場合
    if (difference < 0) {
      return '終了';
    }

    // 開催日が今日の場合
    if (difference == 0) {
      return '本日開催';
    }

    // 開催日が未来の場合
    return '開催日まであと${difference}日';
  }

  Widget _buildEmptyEventState() {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacing16),
          Icon(Icons.event_outlined, size: 48, color: AppTheme.mutedForeground),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'イベントがありません',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.mutedForeground),
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

enum EventRole { organizer, participant }

enum EventStatus { planning, active, completed }

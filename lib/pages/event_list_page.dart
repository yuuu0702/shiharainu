import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/services/auth_service.dart';

class EventListPage extends ConsumerStatefulWidget {
  const EventListPage({super.key});

  @override
  ConsumerState<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends ConsumerState<EventListPage> {
  // TODO: 実際のデータはRiverpodプロバイダーから取得
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
  ];

  final List<EventData> _participantEvents = [
    EventData(
      id: '3',
      title: '歓送迎会',
      description: '春の歓送迎会',
      date: DateTime.now().add(const Duration(days: 21)),
      participantCount: 25,
      role: EventRole.participant,
      status: EventStatus.active,
    ),
  ];

  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('ログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          AppButton.primary(
            text: 'ログアウト',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      try {
        final authService = ref.read(authServiceProvider);
        await authService.signOut();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ログアウトに失敗しました: $e'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 戻るボタンでの画面遷移を禁止
      onPopInvokedWithResult: (didPop, result) {
        // 戻るボタンが押されても何もしない（ログイン画面に戻さない）
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('イベント一覧'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ログアウト',
            onPressed: _handleLogout,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton.primary(
                text: '新しいイベント',
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => context.go('/events/create'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_organizerEvents.isNotEmpty) ...[
                _buildSectionHeader('幹事として管理中', _organizerEvents.length),
                const SizedBox(height: AppTheme.spacing16),
                _buildEventGrid(_organizerEvents),
                const SizedBox(height: AppTheme.spacing32),
              ],
              if (_participantEvents.isNotEmpty) ...[
                _buildSectionHeader('参加中のイベント', _participantEvents.length),
                const SizedBox(height: AppTheme.spacing16),
                _buildEventGrid(_participantEvents),
              ],
              if (_organizerEvents.isEmpty && _participantEvents.isEmpty)
                _buildEmptyState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(title, style: AppTheme.headlineMedium),
        const SizedBox(width: AppTheme.spacing8),
        AppBadge(text: count.toString(), variant: AppBadgeVariant.secondary),
      ],
    );
  }

  Widget _buildEventGrid(List<EventData> events) {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      spacing: AppTheme.spacing16,
      children: events.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(EventData event) {
    return AppCard.interactive(
      onTap: () => context.go('/events/${event.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: AppTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildRoleBadge(event.role),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            event.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppTheme.spacing12),
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
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
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
              const Spacer(),
              _buildStatusBadge(event.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(EventRole role) {
    switch (role) {
      case EventRole.organizer:
        return AppBadge(text: '幹事', variant: AppBadgeVariant.default_);
      case EventRole.participant:
        return AppBadge(text: '参加者', variant: AppBadgeVariant.secondary);
    }
  }

  Widget _buildStatusBadge(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return AppBadge(text: '企画中', variant: AppBadgeVariant.secondary);
      case EventStatus.active:
        return AppBadge(text: '募集中', variant: AppBadgeVariant.default_);
      case EventStatus.completed:
        return AppBadge(text: '完了', variant: AppBadgeVariant.secondary);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacing64),
          Icon(Icons.event_outlined, size: 64, color: AppTheme.mutedForeground),
          const SizedBox(height: AppTheme.spacing24),
          Text('イベントがありません', style: AppTheme.headlineMedium),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            '新しいイベントを作成するか、\n他のイベントに参加してみましょう',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing24),
          AppButton.primary(
            text: '初めてのイベントを作成',
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => context.go('/events/create'),
          ),
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
      return '$difference日後';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}

// TODO: 実際のデータモデルはshared/modelsに移動
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

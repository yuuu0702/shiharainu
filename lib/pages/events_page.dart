import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';

class EventsPage extends HookConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');
    final showFilters = useState(false);
    final eventsAsync = ref.watch(userEventsStreamProvider);

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
      body: eventsAsync.when(
        data: (events) {
          // 検索フィルター適用
          final filteredEvents = events.where((event) {
            if (searchQuery.value.isEmpty) return true;
            final query = searchQuery.value.toLowerCase();
            return event.title.toLowerCase().contains(query) ||
                event.description.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              // 検索バー
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.mutedColor, width: 1),
                  ),
                ),
                child: AppSearchFilterBar(
                  searchQuery: searchQuery.value,
                  onSearchChanged: (query) => searchQuery.value = query,
                  onSearchClear: () => searchQuery.value = '',
                  onFilterTap: () => showFilters.value = !showFilters.value,
                  activeFiltersCount: 0,
                ),
              ),

              // イベント一覧
              Expanded(
                child: filteredEvents.isEmpty
                    ? _buildEmptyState(context, searchQuery.value.isNotEmpty)
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        itemCount: filteredEvents.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppTheme.spacing12),
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return _buildEventCard(context, event);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64, color: AppTheme.destructive),
                const SizedBox(height: AppTheme.spacing16),
                Text('イベント一覧の取得に失敗しました',
                    style: AppTheme.headlineMedium),
                const SizedBox(height: AppTheme.spacing8),
                Text(error.toString(), style: AppTheme.bodySmall),
                const SizedBox(height: AppTheme.spacing24),
                AppButton.primary(
                  text: '再読み込み',
                  onPressed: () => ref.invalidate(userEventsStreamProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return AppCard(
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.status)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(
                        color: _getStatusColor(event.status)
                            .withValues(alpha: 0.3),
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
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    _formatDate(event.date),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.mutedForegroundAccessible,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 16,
                color: AppTheme.mutedForegroundAccessible,
              ),
              const SizedBox(width: AppTheme.spacing4),
              Text(
                '¥${event.totalAmount.toStringAsFixed(0)}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppTheme.mutedForegroundAccessible,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool hasSearchQuery) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearchQuery ? Icons.search_off : Icons.event_outlined,
              size: 64,
              color: AppTheme.mutedForegroundAccessible,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              hasSearchQuery ? '検索結果が見つかりませんでした' : 'イベントがありません',
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              hasSearchQuery
                  ? '検索条件を変更してみてください'
                  : '新しいイベントを作成してみましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),
            if (!hasSearchQuery)
              AppButton.primary(
                text: 'イベントを作成',
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => context.go('/events/create'),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return AppTheme.warningColor;
      case EventStatus.active:
        return AppTheme.primaryColor;
      case EventStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return '企画中';
      case EventStatus.active:
        return '開催予定';
      case EventStatus.completed:
        return '終了';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return '${date.month}/${date.day} (終了)';
    } else if (difference == 0) {
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

// Governed by Skill: shiharainu-general-design
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
        Padding(
          padding: const EdgeInsets.only(right: AppTheme.spacing16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/events/create'),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: 6, // 少しコンパクトに
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18, color: AppTheme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      'イベント作成',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Scaffold(
          body: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(userEventsStreamProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return Container(
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
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'あと',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            _getEventDaysUntilNumber(event.date),
                            style: AppTheme.headlineMedium.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          Text(
                            '日',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
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
                              Container(
                                margin: const EdgeInsets.only(
                                  right: AppTheme.spacing8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(event.status),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusRound,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(event.status),
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
                            ],
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
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                Divider(color: AppTheme.mutedColor.withValues(alpha: 0.5)),
                const SizedBox(height: AppTheme.spacing8),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 16,
                      color: AppTheme.mutedForegroundAccessible,
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      '合計: ¥${event.totalAmount.toStringAsFixed(0)}',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.foregroundColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.mutedColor,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusRound,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: AppTheme.mutedForegroundAccessible,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '詳細',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.mutedForegroundAccessible,
                            ),
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

  Widget _buildEmptyState(BuildContext context, bool hasSearchQuery) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.mutedColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearchQuery ? Icons.search_off : Icons.event_outlined,
                size: 48,
                color: AppTheme.mutedForegroundLegacy,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              hasSearchQuery ? '検索結果が見つかりませんでした' : 'イベントがありません',
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              hasSearchQuery ? '検索条件を変更してみてください' : '新しいイベントを作成して\n割り勘を始めましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing32),
            if (!hasSearchQuery)
              AppButton.outline(
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
        return AppTheme.mutedForegroundLegacy;
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
    return '${date.year}/${date.month}/${date.day}';
  }

  String _getEventDaysUntilNumber(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    return difference < 0 ? '0' : difference.toString();
  }
}

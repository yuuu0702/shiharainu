import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/utils/performance_utils.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  // フィルタリングと検索の状態
  String _searchQuery = '';
  EventRole? _selectedRole;
  EventStatus? _selectedStatus;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _sortBy = 'date_asc';
  bool _showFilters = false;

  // ソートオプション
  static const List<SortOption> _sortOptions = [
    SortOption(value: 'date_asc', label: '開催日（近い順）', icon: Icons.arrow_upward),
    SortOption(value: 'date_desc', label: '開催日（遠い順）', icon: Icons.arrow_downward),
    SortOption(value: 'name_asc', label: '名前（A-Z）', icon: Icons.sort_by_alpha),
    SortOption(value: 'participants_desc', label: '参加者数（多い順）', icon: Icons.people),
  ];

  // サンプルデータ（staticで最適化）
  static final List<EventData> _allEvents = [
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
    EventData(
      id: '8',
      title: 'ゴルフコンペ',
      description: '年次ゴルフコンペティション',
      date: DateTime.now().subtract(const Duration(days: 10)),
      participantCount: 20,
      role: EventRole.participant,
      status: EventStatus.completed,
    ),
  ];

  // フィルタリング結果をキャッシュ
  List<EventData>? _cachedFilteredEvents;
  String? _lastFilterKey;

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEventsOptimized();

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
      body: Column(
        children: [
          // 検索・フィルターバー
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.mutedColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                AppSearchFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (query) {
                    _clearFilterCache();
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onSearchClear: () {
                    _clearFilterCache();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  onFilterTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  activeFiltersCount: _getActiveFiltersCount(),
                  sortWidget: AppSortOptions(
                    selectedOption: _sortBy,
                    options: _sortOptions,
                    onChanged: (value) {
                      _clearFilterCache();
                      setState(() {
                        _sortBy = value;
                      });
                    },
                  ),
                ),

                // フィルターオプション
                if (_showFilters) ...[
                  const SizedBox(height: AppTheme.spacing16),
                  _buildFilterOptions(),
                ],
              ],
            ),
          ),

          // イベント一覧（パフォーマンス最適化済み）
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    child: PerformanceUtils.optimizedListView<EventData>(
                      items: filteredEvents,
                      itemBuilder: (context, event) => _buildEventCard(event),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppTheme.spacing12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return AppCard(
      child: Column(
        children: [
          // ロールフィルター
          AppFilterSection(
            title: '参加種別',
            children: [
              AppFilterChip(
                label: 'すべて',
                isSelected: _selectedRole == null,
                onSelected: (selected) {
                  if (selected) {
                    _clearFilterCache();
                    setState(() {
                      _selectedRole = null;
                    });
                  }
                },
              ),
              AppFilterChip(
                label: '幹事',
                icon: Icons.admin_panel_settings_outlined,
                isSelected: _selectedRole == EventRole.organizer,
                onSelected: (selected) {
                  _clearFilterCache();
                  setState(() {
                    _selectedRole = selected ? EventRole.organizer : null;
                  });
                },
              ),
              AppFilterChip(
                label: '参加者',
                icon: Icons.person_outline,
                isSelected: _selectedRole == EventRole.participant,
                onSelected: (selected) {
                  _clearFilterCache();
                  setState(() {
                    _selectedRole = selected ? EventRole.participant : null;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing16),

          // ステータスフィルター
          AppFilterSection(
            title: 'ステータス',
            children: [
              AppFilterChip(
                label: 'すべて',
                isSelected: _selectedStatus == null,
                onSelected: (selected) {
                  if (selected) {
                    _clearFilterCache();
                    setState(() {
                      _selectedStatus = null;
                    });
                  }
                },
              ),
              AppFilterChip(
                label: '企画中',
                icon: Icons.schedule,
                isSelected: _selectedStatus == EventStatus.planning,
                onSelected: (selected) {
                  _clearFilterCache();
                  setState(() {
                    _selectedStatus = selected ? EventStatus.planning : null;
                  });
                },
              ),
              AppFilterChip(
                label: '開催予定',
                icon: Icons.event,
                isSelected: _selectedStatus == EventStatus.active,
                onSelected: (selected) {
                  _clearFilterCache();
                  setState(() {
                    _selectedStatus = selected ? EventStatus.active : null;
                  });
                },
              ),
              AppFilterChip(
                label: '終了',
                icon: Icons.check_circle_outline,
                isSelected: _selectedStatus == EventStatus.completed,
                onSelected: (selected) {
                  _clearFilterCache();
                  setState(() {
                    _selectedStatus = selected ? EventStatus.completed : null;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing16),

          // フィルタークリア
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text('フィルターをクリア'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventData event) {
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
                        color: _getStatusColor(event.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        border: Border.all(
                          color: _getStatusColor(event.status).withValues(alpha: 0.3),
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

  Widget _buildEmptyState() {
    final hasActiveFilters = _getActiveFiltersCount() > 0;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Icons.search_off : Icons.event_outlined,
              size: 64,
              color: AppTheme.mutedForegroundAccessible,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              hasActiveFilters 
                ? '検索結果が見つかりませんでした'
                : 'イベントがありません',
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              hasActiveFilters 
                ? '検索条件やフィルターを変更してみてください'
                : '新しいイベントを作成してみましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),
            if (hasActiveFilters) ...[
              AppButton.outline(
                text: 'フィルターをクリア',
                onPressed: () {
                  _clearAllFilters();
                  setState(() {
                    _showFilters = false;
                  });
                },
              ),
            ] else ...[
              AppButton.primary(
                text: 'イベントを作成',
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => context.go('/events/create'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<EventData> _getFilteredEventsOptimized() {
    // フィルターキーを生成してキャッシュ判定
    final filterKey = _generateFilterKey();
    if (_cachedFilteredEvents != null && _lastFilterKey == filterKey) {
      return _cachedFilteredEvents!;
    }

    // フィルタリング実行（単一パスで効率化）
    final searchLower = _searchQuery.toLowerCase();
    final events = _allEvents.where((event) {
      // 検索フィルター
      if (_searchQuery.isNotEmpty) {
        if (!event.title.toLowerCase().contains(searchLower) &&
            !event.description.toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // ロールフィルター
      if (_selectedRole != null && event.role != _selectedRole) {
        return false;
      }

      // ステータスフィルター
      if (_selectedStatus != null && event.status != _selectedStatus) {
        return false;
      }

      // 日付フィルター
      if (_dateFrom != null && !event.date.isAfter(_dateFrom!)) {
        return false;
      }
      if (_dateTo != null && !event.date.isBefore(_dateTo!)) {
        return false;
      }

      return true;
    }).toList();

    // ソート（mutableなリストに対して実行）
    events.sort((a, b) {
      switch (_sortBy) {
        case 'date_asc':
          return a.date.compareTo(b.date);
        case 'date_desc':
          return b.date.compareTo(a.date);
        case 'name_asc':
          return a.title.compareTo(b.title);
        case 'participants_desc':
          return b.participantCount.compareTo(a.participantCount);
        default:
          return a.date.compareTo(b.date);
      }
    });

    // 結果をキャッシュ
    _cachedFilteredEvents = events;
    _lastFilterKey = filterKey;

    return events;
  }

  String _generateFilterKey() {
    return '$_searchQuery|$_selectedRole|$_selectedStatus|$_dateFrom|$_dateTo|$_sortBy';
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_selectedRole != null) count++;
    if (_selectedStatus != null) count++;
    if (_dateFrom != null) count++;
    if (_dateTo != null) count++;
    return count;
  }

  void _clearAllFilters() {
    _clearFilterCache();
    setState(() {
      _searchQuery = '';
      _selectedRole = null;
      _selectedStatus = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }

  void _clearFilterCache() {
    _cachedFilteredEvents = null;
    _lastFilterKey = null;
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

// データモデル
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
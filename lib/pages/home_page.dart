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
    EventData(
      id: '4',
      title: '部署BBQ',
      description: '夏のBBQ大会',
      date: DateTime.now().add(const Duration(days: 35)),
      participantCount: 30,
      role: EventRole.participant,
      status: EventStatus.active,
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
      label: '設定',
      icon: Icons.settings_outlined,
      route: '/settings',
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
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.mutedColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Text(
              '参加確定の通知があります',
              style: AppTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
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
        
        // 幹事として管理中のイベントリスト
        if (_organizerEvents.isNotEmpty) ...[
          _buildEventSubSection('幹事として管理中のイベントリスト', _organizerEvents),
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          ...events.map((event) => _buildEventListItem(event)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventListItem(EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: InkWell(
        onTap: () => context.go('/events/${event.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing12),
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: AppTheme.mutedColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: AppTheme.mutedForeground,
                        ),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          _formatDate(event.date),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Icon(
                          Icons.people_outline,
                          size: 14,
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
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
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
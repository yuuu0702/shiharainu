import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isOrganizer = true; // デバッグ用フラグ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダッシュボード'),
        actions: [
          if (isOrganizer)
            AppButton.icon(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => context.go('/event-creation'),
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                context.go('/login');
              } else if (value == 'toggle_role') {
                setState(() {
                  isOrganizer = !isOrganizer;
                });
              } else if (value == 'components') {
                context.go('/components');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_role',
                child: ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text('役割切り替え'),
                ),
              ),
              const PopupMenuItem(
                value: 'components',
                child: ListTile(
                  leading: Icon(Icons.palette),
                  title: Text('コンポーネント素材集'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('ログアウト'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ユーザー情報カード
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isOrganizer ? AppTheme.primaryColor : AppTheme.infoColor,
                    child: Icon(
                      isOrganizer ? Icons.admin_panel_settings : Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '田中太郎',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppBadge(
                          text: isOrganizer ? '幹事' : '参加者',
                          variant: isOrganizer 
                              ? AppBadgeVariant.success 
                              : AppBadgeVariant.info,
                        ),
                      ],
                    ),
                  ),
                  AppBadge.warning(text: 'DEBUG'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 機能セクション
            Text(
              isOrganizer ? '幹事機能' : '参加者機能',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 機能カードグリッド
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: _buildFeatureCards(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        items: isOrganizer 
            ? AppBottomNavigationPresets.organizerItems
            : AppBottomNavigationPresets.participantItems,
        currentRoute: '/dashboard',
      ),
    );
  }

  List<Widget> _buildFeatureCards(BuildContext context) {
    if (isOrganizer) {
      return [
        _buildFeatureCard(
          context,
          'イベント作成',
          Icons.add_circle_outline,
          AppTheme.primaryColor,
          '新しいイベントを作成',
          () => context.go('/event-creation'),
        ),
        _buildFeatureCard(
          context,
          '支払い管理',
          Icons.payment_outlined,
          AppTheme.successColor,
          '支払い状況を確認',
          () {
            // TODO: 支払い管理画面へ
          },
        ),
        _buildFeatureCard(
          context,
          'ランキング',
          Icons.leaderboard_outlined,
          AppTheme.warningColor,
          'バッジとランキング',
          () {
            // TODO: ランキング画面へ
          },
        ),
        _buildFeatureCard(
          context,
          '二次会管理',
          Icons.event_outlined,
          const Color(0xFF8B5CF6),
          '二次会の管理',
          () {
            // TODO: 二次会管理画面へ
          },
        ),
      ];
    } else {
      return [
        _buildFeatureCard(
          context,
          '支払い',
          Icons.payment_outlined,
          AppTheme.successColor,
          '支払い金額を確認',
          () {
            // TODO: 支払い画面へ
          },
        ),
        _buildFeatureCard(
          context,
          'ランキング',
          Icons.leaderboard_outlined,
          AppTheme.warningColor,
          'バッジとランキング',
          () {
            // TODO: ランキング画面へ
          },
        ),
      ];
    }
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return AppCard.interactive(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
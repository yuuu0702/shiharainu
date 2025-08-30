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
    return SimplePage(
      title: 'ダッシュボード',
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
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('ログアウト'),
              ),
            ),
          ],
        ),
      ],
      body: ResponsivePadding(
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
              child: DashboardFeatureCards(
                isOrganizer: isOrganizer,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
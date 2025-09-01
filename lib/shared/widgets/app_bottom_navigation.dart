import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppBottomNavigationItem {
  final String label;
  final IconData icon;
  final String route;
  final int? badgeCount; // 通知バッジ用（nullの場合はバッジなし）

  const AppBottomNavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    this.badgeCount,
  });
}

class AppBottomNavigation extends StatelessWidget {
  final List<AppBottomNavigationItem> items;
  final String currentRoute;

  const AppBottomNavigation({
    super.key,
    required this.items,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.mutedColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items
              .map((item) => _buildNavigationItem(context, item))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    AppBottomNavigationItem item,
  ) {
    final isActive = currentRoute.startsWith(item.route);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isActive) {
              context.go(item.route);
            }
          },
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: isActive
                          ? const BoxDecoration(
                              color: Color(0x0CEA3800), // primary/5
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            )
                          : null,
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: isActive
                            ? AppTheme.primaryColor
                            : AppTheme.mutedForeground,
                      ),
                    ),
                    // バッジ表示
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            item.badgeCount! > 99
                                ? '99+'
                                : item.badgeCount!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? AppTheme.primaryColor
                        : AppTheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 使用例のプリセット
class AppBottomNavigationPresets {
  static const List<AppBottomNavigationItem> organizerItems = [
    AppBottomNavigationItem(
      label: 'ダッシュボード',
      icon: Icons.dashboard_outlined,
      route: '/dashboard',
    ),
    AppBottomNavigationItem(
      label: 'イベント作成',
      icon: Icons.add_circle_outline,
      route: '/event-creation',
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
  ];

  static const List<AppBottomNavigationItem> participantItems = [
    AppBottomNavigationItem(
      label: 'ホーム',
      icon: Icons.home_outlined,
      route: '/dashboard',
    ),
    AppBottomNavigationItem(
      label: '支払い',
      icon: Icons.payment_outlined,
      route: '/payment',
    ),
    AppBottomNavigationItem(
      label: '設定',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiharainu/shared/constants/app_breakpoints.dart';
import 'package:shiharainu/shared/widgets/app_bottom_navigation.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// グローバルナビゲーションラッパー
/// 全てのページで統一したボトムナビゲーションを提供
class GlobalNavigationWrapper extends ConsumerWidget {
  final Widget child;

  const GlobalNavigationWrapper({super.key, required this.child});

  // 通常ユーザー向けナビゲーション項目
  static const List<AppBottomNavigationItem> _userNavigationItems = [
    AppBottomNavigationItem(
      label: 'ホーム',
      icon: Icons.home_outlined,
      route: '/home',
    ),
    AppBottomNavigationItem(
      label: 'イベント一覧',
      icon: Icons.event_note_outlined,
      route: '/events',
    ),
    AppBottomNavigationItem(
      label: '通知',
      icon: Icons.notifications_outlined,
      route: '/notifications',
    ),
    AppBottomNavigationItem(
      label: 'アカウント',
      icon: Icons.account_circle_outlined,
      route: '/account',
    ),
  ];

  // ゲストユーザー向けナビゲーション項目
  static const List<AppBottomNavigationItem> _guestNavigationItems = [
    AppBottomNavigationItem(
      label: 'ホーム',
      icon: Icons.home_outlined,
      route: '/home',
    ),
    AppBottomNavigationItem(
      label: 'イベント一覧',
      icon: Icons.event_note_outlined,
      route: '/events',
    ),
    AppBottomNavigationItem(
      label: '会員登録',
      icon: Icons.person_add_outlined,
      route: '/guest/promotion',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のルートを自動的に取得
    final currentLocation = GoRouterState.of(context).matchedLocation;

    // ユーザー状態によってナビゲーション項目を切り替え
    final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    final navigationItems = isGuest
        ? _guestNavigationItems
        : _userNavigationItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final navigationType = AppBreakpoints.getNavigationType(width);

        switch (navigationType) {
          case NavigationType.rail:
            return _buildNavigationRailLayout(
              context,
              currentLocation,
              navigationItems,
            );
          case NavigationType.bottom:
            return _buildBottomNavigationLayout(
              context,
              currentLocation,
              navigationItems,
            );
        }
      },
    );
  }

  Widget _buildNavigationRailLayout(
    BuildContext context,
    String currentLocation,
    List<AppBottomNavigationItem> items,
  ) {
    return Scaffold(
      body: Row(
        children: [
          // 左側のNavigationRail
          _buildNavigationRail(context, currentLocation, items),
          // 右側のメインコンテンツ
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationLayout(
    BuildContext context,
    String currentLocation,
    List<AppBottomNavigationItem> items,
  ) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigation(
        items: items,
        currentRoute: currentLocation,
      ),
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    String currentLocation,
    List<AppBottomNavigationItem> items,
  ) {
    final currentIndex = items.indexWhere(
      (item) => _isRouteActive(item.route, currentLocation),
    );

    return Builder(
      builder: (context) => NavigationRail(
        selectedIndex: currentIndex >= 0 ? currentIndex : 0,
        onDestinationSelected: (index) {
          if (index < items.length) {
            context.go(items[index].route);
          }
        },
        labelType: NavigationRailLabelType.selected,
        backgroundColor: Colors.white,
        elevation: 4,
        selectedLabelTextStyle: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: AppTheme.mutedForeground,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppTheme.primaryColor,
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppTheme.mutedForeground,
          size: 20,
        ),
        destinations: items
            .map(
              (item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon),
                label: Text(item.label),
              ),
            )
            .toList(),
      ),
    );
  }

  /// 指定したルートが現在アクティブかどうかを判定（部分一致）
  bool _isRouteActive(String navRoute, String currentLocation) {
    // 完全一致の場合
    if (navRoute == currentLocation) {
      return true;
    }

    // サブルートの場合
    if (currentLocation.startsWith(navRoute)) {
      if (currentLocation.length > navRoute.length) {
        return currentLocation[navRoute.length] == '/';
      }
      return true;
    }

    return false;
  }

  /// ナビゲーションが表示されるべきかどうかを判定
  static bool shouldShowNavigation(String route) {
    // ログインページでは非表示
    if (route == '/login') {
      return false;
    }

    // デバッグ用ページでは非表示
    if (route == '/components') {
      return false;
    }

    // その他は表示
    return true;
  }
}

/// アプリバーありのシンプルなページラッパー
class SimplePage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  const SimplePage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (AppBreakpoints.isDesktop(width)) {
          // デスクトップ: 専用ヘッダーレイアウト
          return _buildDesktopLayout();
        } else {
          // モバイル・タブレット: AppBar
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // デスクトップ用ヘッダー
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppTheme.mutedColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 16)],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
        // メインコンテンツ
        Expanded(
          child: Container(
            color: const Color(0xFFFAFAFB), // 背景色でデスクトップ感を演出
            child: body,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions, leading: leading),
      body: body,
    );
  }
}

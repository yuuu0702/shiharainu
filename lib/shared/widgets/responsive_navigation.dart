import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_breakpoints.dart';
import 'package:shiharainu/shared/widgets/app_bottom_navigation.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// レスポンシブナビゲーション統合コンポーネント
/// 画面サイズに応じて最適なナビゲーションUIを提供
class ResponsiveNavigation extends StatelessWidget {
  final List<AppBottomNavigationItem> items;
  final String currentRoute;
  final Widget child;

  const ResponsiveNavigation({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (AppBreakpoints.isDesktop(width)) {
          // デスクトップ: NavigationRail（サイドナビゲーション）
          return _buildDesktopLayout();
        } else {
          // モバイル・タブレット: BottomNavigation
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // 左側のNavigationRail
          _buildNavigationRail(),
          // 右側のメインコンテンツ
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigation(
        items: items,
        currentRoute: currentRoute,
      ),
    );
  }

  Widget _buildNavigationRail() {
    final currentIndex = items.indexWhere((item) => item.route == currentRoute);

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
}

/// デスクトップレイアウト用のページラッパー
class DesktopPageLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const DesktopPageLayout({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
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
            child: child,
          ),
        ),
      ],
    );
  }
}

/// レスポンシブ対応ページスキャフォールド
/// 画面サイズに応じてAppBarまたはDesktopPageLayoutを選択
class ResponsivePageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final List<AppBottomNavigationItem> navigationItems;
  final String currentRoute;

  const ResponsivePageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    required this.navigationItems,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (AppBreakpoints.isDesktop(width)) {
          // デスクトップ: NavigationRail + ヘッダー
          return ResponsiveNavigation(
            items: navigationItems,
            currentRoute: currentRoute,
            child: DesktopPageLayout(
              title: title,
              actions: actions,
              child: body,
            ),
          );
        } else {
          // モバイル・タブレット: AppBar + BottomNavigation
          return ResponsiveNavigation(
            items: navigationItems,
            currentRoute: currentRoute,
            child: Scaffold(
              appBar: AppBar(title: Text(title), actions: actions),
              body: body,
            ),
          );
        }
      },
    );
  }
}

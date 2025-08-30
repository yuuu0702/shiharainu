import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_breakpoints.dart';

/// レスポンシブレイアウト対応ウィジェット
/// 画面サイズに応じてmobile/tablet/desktop用のウィジェットを切り替える
class ResponsiveLayout extends StatelessWidget {
  /// モバイル端末用のウィジェット
  final Widget mobile;
  
  /// タブレット端末用のウィジェット（オプション）
  final Widget? tablet;
  
  /// デスクトップ端末用のウィジェット（オプション）
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (AppBreakpoints.isDesktop(width)) {
          return desktop ?? tablet ?? mobile;
        } else if (AppBreakpoints.isTablet(width)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// レスポンシブパディング対応コンテナ
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? customMobilePadding;
  final double? customTabletPadding;
  final double? customDesktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.customMobilePadding,
    this.customTabletPadding,
    this.customDesktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        double padding;
        
        if (AppBreakpoints.isDesktop(width)) {
          padding = customDesktopPadding ?? AppBreakpoints.getPadding(width);
        } else if (AppBreakpoints.isTablet(width)) {
          padding = customTabletPadding ?? AppBreakpoints.getPadding(width);
        } else {
          padding = customMobilePadding ?? AppBreakpoints.getPadding(width);
        }

        return Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        );
      },
    );
  }
}

/// レスポンシブグリッド対応ウィジェット
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final int mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.mobileColumns = 2,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount;
        
        if (AppBreakpoints.isDesktop(width)) {
          crossAxisCount = desktopColumns ?? mobileColumns + 2;
        } else if (AppBreakpoints.isTablet(width)) {
          crossAxisCount = tabletColumns ?? mobileColumns + 1;
        } else {
          crossAxisCount = mobileColumns;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          children: children,
        );
      },
    );
  }
}
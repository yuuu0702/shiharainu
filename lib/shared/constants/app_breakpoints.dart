/// アプリケーションのレスポンシブデザイン用ブレークポイント定義
class AppBreakpoints {
  /// モバイル端末の最大幅（～600px）
  static const double mobile = 600;

  /// タブレット小サイズ（600px～800px）- BottomNavigation推奨
  static const double tabletSmall = 800;

  /// タブレット大サイズ（800px～1200px）- NavigationRailも選択可能
  static const double tabletLarge = 1200;

  /// デスクトップ端末の最小幅（1200px～）- NavigationRail推奨
  static const double desktop = 1200;

  // 後方互換性のため残しておく
  @Deprecated('Use tabletLarge instead')
  static const double tablet = 1024;

  /// 現在の画面幅がモバイルサイズかどうか判定
  static bool isMobile(double width) => width < mobile;

  /// 現在の画面幅がタブレット小サイズかどうか判定（600px～800px）
  static bool isTabletSmall(double width) => width >= mobile && width < tabletSmall;

  /// 現在の画面幅がタブレット大サイズかどうか判定（800px～1200px）
  static bool isTabletLarge(double width) => width >= tabletSmall && width < desktop;

  /// 現在の画面幅がタブレットサイズ全般かどうか判定（600px～1200px）
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// 現在の画面幅がデスクトップサイズかどうか判定
  static bool isDesktop(double width) => width >= desktop;

  /// BottomNavigationを使用すべきかどうか判定
  static bool shouldUseBottomNavigation(double width) => width < tabletSmall;

  /// NavigationRailを使用すべきかどうか判定
  static bool shouldUseNavigationRail(double width) => width >= desktop;

  /// 中間サイズ（タブレット大）でユーザー選択を可能にするかどうか
  static bool isNavigationFlexible(double width) => isTabletLarge(width);

  /// 画面サイズに応じたパディング値を取得
  static double getPadding(double width) {
    if (isMobile(width)) return 16.0;
    if (isTabletSmall(width)) return 20.0;
    if (isTabletLarge(width)) return 28.0;
    return 32.0; // desktop
  }

  /// 画面サイズに応じたフォントサイズを取得
  static double getFontSize(double width, {double baseSize = 14.0}) {
    if (isMobile(width)) return baseSize;
    if (isTabletSmall(width)) return baseSize + 0.5;
    if (isTabletLarge(width)) return baseSize + 1.0;
    return baseSize + 2.0; // desktop
  }

  /// 画面サイズに応じたグリッド列数を取得
  static int getGridCrossAxisCount(double width, {int mobileColumns = 2}) {
    if (isMobile(width)) return mobileColumns;
    if (isTabletSmall(width)) return mobileColumns + 1;
    if (isTabletLarge(width)) return mobileColumns + 2;
    return mobileColumns + 3; // desktop
  }

  /// ナビゲーション種類を取得
  static NavigationType getNavigationType(double width, {NavigationType? userPreference}) {
    if (shouldUseBottomNavigation(width)) {
      return NavigationType.bottom;
    } else if (shouldUseNavigationRail(width)) {
      return NavigationType.rail;
    } else if (isNavigationFlexible(width)) {
      // タブレット大サイズでは、ユーザー設定があればそれを使用
      return userPreference ?? NavigationType.bottom;
    }
    return NavigationType.bottom;
  }
}

/// ナビゲーションの種類を定義
enum NavigationType {
  bottom, // BottomNavigationBar
  rail,   // NavigationRail
}

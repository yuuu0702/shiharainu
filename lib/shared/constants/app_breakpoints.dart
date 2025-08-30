/// アプリケーションのレスポンシブデザイン用ブレークポイント定義
class AppBreakpoints {
  /// モバイル端末の最大幅（～600px）
  static const double mobile = 600;
  
  /// タブレット端末の最大幅（～1024px）
  static const double tablet = 1024;
  
  /// デスクトップ端末の最小幅（1200px～）
  static const double desktop = 1200;
  
  /// 現在の画面幅がモバイルサイズかどうか判定
  static bool isMobile(double width) => width < mobile;
  
  /// 現在の画面幅がタブレットサイズかどうか判定
  static bool isTablet(double width) => width >= mobile && width < desktop;
  
  /// 現在の画面幅がデスクトップサイズかどうか判定
  static bool isDesktop(double width) => width >= desktop;
  
  /// 画面サイズに応じたパディング値を取得
  static double getPadding(double width) {
    if (isMobile(width)) return 16.0;
    if (isTablet(width)) return 24.0;
    return 32.0;
  }
  
  /// 画面サイズに応じたフォントサイズを取得
  static double getFontSize(double width, {double baseSize = 14.0}) {
    if (isMobile(width)) return baseSize;
    if (isTablet(width)) return baseSize + 1.0;
    return baseSize + 2.0;
  }
  
  /// 画面サイズに応じたグリッド列数を取得
  static int getGridCrossAxisCount(double width, {int mobileColumns = 2}) {
    if (isMobile(width)) return mobileColumns;
    if (isTablet(width)) return mobileColumns + 1;
    return mobileColumns + 2;
  }
}
import 'package:flutter/material.dart';

/// ページ遷移アニメーション定義クラス
///
/// Shiharainuアプリで使用する統一されたページ遷移アニメーションを提供します。
/// Material Design 3のモーションガイドラインに準拠し、滑らかで心地よい遷移を実現します。
class AppPageTransitions {
  /// デフォルトのアニメーション時間
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration slowDuration = Duration(milliseconds: 400);

  /// フェードトランジション
  ///
  /// 透明度の変化によるシンプルで洗練された遷移効果
  /// 使用場面: モーダル、オーバーレイ、軽い画面遷移
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
      child: child,
    );
  }

  /// スライドトランジション（右から左）
  ///
  /// 新しいページが右から滑り込んでくる遷移効果
  /// 使用場面: 階層の深い画面遷移、詳細画面への移動
  static Widget slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: child,
    );
  }

  /// スライドトランジション（下から上）
  ///
  /// 新しいページが下から押し上げられるような遷移効果
  /// 使用場面: ボトムシート風の画面、設定画面
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: child,
    );
  }

  /// スケールトランジション
  ///
  /// ページが中央から徐々に拡大して表示される遷移効果
  /// 使用場面: 重要な画面への遷移、フォーカスを当てたい場面
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// 複合スライド＋フェードトランジション
  ///
  /// スライドとフェードを組み合わせた滑らかな遷移効果
  /// 使用場面: メイン画面間の遷移、ナビゲーション
  static Widget slideWithFadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
        child: child,
      ),
    );
  }

  /// 戻る遷移用のスライドトランジション
  ///
  /// 戻るボタンや左エッジスワイプ時の遷移効果
  /// 使用場面: 戻るナビゲーション
  static Widget backSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 前のページをスライドアウトさせる
    return SlideTransition(
      position: secondaryAnimation.drive(
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      ),
    );
  }

  /// カスタムページルートビルダー
  ///
  /// GoRouterで使用するためのカスタムページ遷移ビルダー
  static Page<T> buildPageWithTransition<T extends Object?>({
    required Widget child,
    required String name,
    Object? arguments,
    String? restorationId,
    PageTransitionType transitionType = PageTransitionType.slideWithFade,
    Duration? duration,
  }) {
    return CustomTransitionPage<T>(
      key: ValueKey(name),
      child: child,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      transitionType: transitionType,
      transitionDuration: duration ?? defaultDuration,
      transitionsBuilder: _getTransitionBuilder(transitionType),
    );
  }

  /// 遷移タイプに応じた遷移ビルダーを取得
  static RouteTransitionsBuilder _getTransitionBuilder(
    PageTransitionType type,
  ) {
    switch (type) {
      case PageTransitionType.fade:
        return fadeTransition;
      case PageTransitionType.slide:
        return slideTransition;
      case PageTransitionType.slideUp:
        return slideUpTransition;
      case PageTransitionType.scale:
        return scaleTransition;
      case PageTransitionType.slideWithFade:
        return slideWithFadeTransition;
      case PageTransitionType.backSlide:
        return backSlideTransition;
    }
  }
}

/// ページ遷移の種類を定義する列挙型
enum PageTransitionType {
  /// フェード遷移
  fade,

  /// スライド遷移（右から左）
  slide,

  /// スライド遷移（下から上）
  slideUp,

  /// スケール遷移
  scale,

  /// スライド＋フェード複合遷移
  slideWithFade,

  /// 戻る遷移用スライド
  backSlide,
}

/// カスタム遷移ページクラス
///
/// GoRouterで使用するためのカスタムページ遷移を実装
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration transitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;

  const CustomTransitionPage({
    required this.child,
    required this.transitionType,
    required this.transitionDuration,
    required this.transitionsBuilder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
    );
  }
}

/// 遷移方向を定義する列挙型
enum TransitionDirection {
  /// 右から左（通常の進む遷移）
  rightToLeft,

  /// 左から右（戻る遷移）
  leftToRight,

  /// 下から上（ボトムアップ）
  bottomToTop,

  /// 上から下（トップダウン）
  topToBottom,
}

/// アニメーションカーブの定義
class AppAnimationCurves {
  /// 標準的なeaseOutカーブ
  static const Curve easeOut = Curves.easeOut;

  /// 標準的なeaseInOutカーブ
  static const Curve easeInOut = Curves.easeInOut;

  /// スプリング効果のあるカーブ
  static const Curve spring = Curves.elasticOut;

  /// 強調されたeaseOutカーブ
  static const Curve emphasizedEaseOut = Cubic(0.05, 0.7, 0.1, 1.0);

  /// 強調されたeaseInカーブ
  static const Curve emphasizedEaseIn = Cubic(0.3, 0.0, 0.8, 0.15);
}

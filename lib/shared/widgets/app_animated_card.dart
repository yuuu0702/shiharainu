import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/app_card.dart';

/// アニメーション付きカードウィジェット
/// 
/// ホバー、タップ時に滑らかなアニメーションを提供する
/// リストアイテムやカード要素に適用して高品質なインタラクションを実現
class AppAnimatedCard extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final bool enableHoverAnimation;
  final bool enableTapAnimation;
  final bool enableShadowAnimation;
  final Duration animationDuration;

  const AppAnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.enableHoverAnimation = true,
    this.enableTapAnimation = true,
    this.enableShadowAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    // アニメーションコントローラーの定義
    final hoverAnimationController = useAnimationController(
      duration: animationDuration,
    );

    final tapAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    // アニメーション値の定義
    final hoverAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.02).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    final tapAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(
          parent: tapAnimationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final elevationAnimation = useAnimation(
      Tween<double>(begin: 0.5, end: 1.5).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    final shadowOpacityAnimation = useAnimation(
      Tween<double>(begin: 0.1, end: 0.15).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    return MouseRegion(
      onEnter: (onTap != null && enableHoverAnimation)
          ? (_) => hoverAnimationController.forward()
          : null,
      onExit: (onTap != null && enableHoverAnimation)
          ? (_) => hoverAnimationController.reverse()
          : null,
      child: GestureDetector(
        onTapDown: (onTap != null && enableTapAnimation)
            ? (_) => tapAnimationController.forward()
            : null,
        onTapUp: (onTap != null && enableTapAnimation)
            ? (_) {
                tapAnimationController.reverse();
                Future.delayed(const Duration(milliseconds: 50), () {
                  onTap?.call();
                });
              }
            : null,
        onTapCancel: (onTap != null && enableTapAnimation)
            ? () => tapAnimationController.reverse()
            : null,
        onLongPress: onLongPress,
        child: Transform.scale(
          scale: enableHoverAnimation && enableTapAnimation
              ? hoverAnimation * tapAnimation
              : enableHoverAnimation
                  ? hoverAnimation
                  : enableTapAnimation
                      ? tapAnimation
                      : 1.0,
          child: AnimatedContainer(
            duration: animationDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: enableShadowAnimation && onTap != null
                  ? [
                      BoxShadow(
                        color: AppTheme.mutedForeground.withValues(alpha: shadowOpacityAnimation),
                        blurRadius: elevationAnimation * 2,
                        offset: Offset(0, elevationAnimation),
                      ),
                    ]
                  : null,
            ),
            child: AppCard(
              onTap: null, // 上位のGestureDetectorで処理するため無効化
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// リストアイテム用のアニメーションウィジェット
/// 
/// リスト内の各アイテムに適用するマイクロインタラクション
/// より軽量で高速な応答を重視した設計
class AppAnimatedListItem extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? hoverColor;
  final BorderRadius? borderRadius;
  final bool showRipple;

  const AppAnimatedListItem({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.backgroundColor,
    this.hoverColor,
    this.borderRadius,
    this.showRipple = true,
  });

  @override
  Widget build(BuildContext context) {
    final hoverAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final backgroundColorAnimation = useAnimation(
      ColorTween(
        begin: backgroundColor ?? Colors.transparent,
        end: hoverColor ?? AppTheme.inputBackground,
      ).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    return MouseRegion(
      onEnter: onTap != null
          ? (_) => hoverAnimationController.forward()
          : null,
      onExit: onTap != null
          ? (_) => hoverAnimationController.reverse()
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: backgroundColorAnimation,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: showRipple
            ? Material(
                color: Colors.transparent,
                borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
                  splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  highlightColor: AppTheme.primaryColor.withValues(alpha: 0.05),
                  child: Container(
                    padding: padding ?? const EdgeInsets.all(AppTheme.spacing12),
                    child: child,
                  ),
                ),
              )
            : GestureDetector(
                onTap: onTap,
                onLongPress: onLongPress,
                child: Container(
                  padding: padding ?? const EdgeInsets.all(AppTheme.spacing12),
                  child: child,
                ),
              ),
      ),
    );
  }
}

/// フローティングカードアニメーション
/// 
/// ホバー時に浮き上がるような効果を演出
/// 重要な情報カードや機能カードに適用
class AppFloatingCard extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double baseElevation;
  final double hoverElevation;

  const AppFloatingCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.baseElevation = 2.0,
    this.hoverElevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );

    final elevationAnimation = useAnimation(
      Tween<double>(begin: baseElevation, end: hoverElevation).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.02).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    return MouseRegion(
      onEnter: onTap != null
          ? (_) => animationController.forward()
          : null,
      onExit: onTap != null
          ? (_) => animationController.reverse()
          : null,
      child: Transform.scale(
        scale: scaleAnimation,
        child: Card(
          elevation: elevationAnimation,
          color: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusLarge),
            child: Container(
              padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// プログレッシブスケールアニメーション
/// 
/// タップ時にスケールダウンし、リリース時にスケールアップする
/// 軽快なフィードバックを提供
class AppScaleAnimation extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;
  final Duration duration;
  final Curve curve;

  const AppScaleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration);

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: scaleValue).animate(
        CurvedAnimation(parent: animationController, curve: curve),
      ),
    );

    return GestureDetector(
      onTapDown: onTap != null ? (_) => animationController.forward() : null,
      onTapUp: onTap != null
          ? (_) {
              animationController.reverse();
              Future.delayed(const Duration(milliseconds: 50), () {
                onTap?.call();
              });
            }
          : null,
      onTapCancel: onTap != null ? () => animationController.reverse() : null,
      child: Transform.scale(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}

/// パルスアニメーション
/// 
/// 重要な情報や通知に注意を引くためのアニメーション
class AppPulseAnimation extends HookWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  const AppPulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 1.0,
    this.maxScale = 1.05,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration);

    final scaleAnimation = useAnimation(
      Tween<double>(begin: minScale, end: maxScale).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(() {
      if (repeat) {
        animationController.repeat(reverse: true);
      } else {
        animationController.forward();
      }
      return () => animationController.dispose();
    }, []);

    return Transform.scale(
      scale: scaleAnimation,
      child: child,
    );
  }
}

/// シマーローディングアニメーション
/// 
/// スケルトンローディング用のシマー効果
class AppShimmerAnimation extends HookWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const AppShimmerAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration);

    final shimmerAnimation = useAnimation(
      Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(() {
      animationController.repeat();
      return () => animationController.dispose();
    }, []);

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: [
            shimmerAnimation - 0.3,
            shimmerAnimation,
            shimmerAnimation + 0.3,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
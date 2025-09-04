import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/app_button.dart';

/// アニメーション付きボタンウィジェット
/// 
/// ホバー、タップ、フォーカス時に滑らかなアニメーションを提供する
/// 高品質なマイクロインタラクションによりユーザー体験を向上させます。
class AppAnimatedButton extends HookWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;

  const AppAnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
  });

  /// プライマリボタンの便利コンストラクタ
  const AppAnimatedButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.primary;

  /// アウトラインボタンの便利コンストラクタ
  const AppAnimatedButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.outline;

  /// ゴーストボタンの便利コンストラクタ
  const AppAnimatedButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.ghost;

  /// アイコンボタンの便利コンストラクタ
  const AppAnimatedButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // アニメーションコントローラーの定義
    final hoverAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    
    final tapAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    final focusAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
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

    final shadowAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    // フォーカスノードの管理
    final focusNode = useFocusNode();
    
    useEffect(() {
      void handleFocusChange() {
        if (focusNode.hasFocus) {
          focusAnimationController.forward();
        } else {
          focusAnimationController.reverse();
        }
      }

      focusNode.addListener(handleFocusChange);
      return () => focusNode.removeListener(handleFocusChange);
    }, [focusNode]);

    return MouseRegion(
      onEnter: onPressed != null 
          ? (_) => hoverAnimationController.forward()
          : null,
      onExit: onPressed != null 
          ? (_) => hoverAnimationController.reverse()
          : null,
      child: GestureDetector(
        onTapDown: onPressed != null 
            ? (_) => tapAnimationController.forward()
            : null,
        onTapUp: onPressed != null 
            ? (_) {
                tapAnimationController.reverse();
                Future.delayed(const Duration(milliseconds: 50), () {
                  onPressed?.call();
                });
              }
            : null,
        onTapCancel: onPressed != null 
            ? () => tapAnimationController.reverse()
            : null,
        child: Transform.scale(
          scale: hoverAnimation * tapAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              boxShadow: onPressed != null ? [
                BoxShadow(
                  color: _getShadowColor().withValues(alpha: 0.1 * shadowAnimation),
                  blurRadius: 4 * shadowAnimation,
                  offset: Offset(0, 2 * shadowAnimation),
                ),
              ] : null,
            ),
            child: Focus(
              focusNode: focusNode,
              child: AppButton(
                text: text,
                onPressed: onPressed,
                variant: variant,
                size: size,
                icon: icon,
                isLoading: isLoading,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// バリアントに応じたシャドウカラーを取得
  Color _getShadowColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppTheme.primaryColor;
      case AppButtonVariant.outline:
        return AppTheme.mutedForeground;
      case AppButtonVariant.secondary:
        return AppTheme.mutedForeground;
      case AppButtonVariant.ghost:
        return AppTheme.mutedForeground;
      case AppButtonVariant.link:
        return AppTheme.primaryColor;
    }
  }
}

/// リップルエフェクト付きのタッチ可能エリア
/// 
/// Material Design のリップルエフェクトを実装
/// タッチフィードバックを強化します。
class AppRippleButton extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final BorderRadius? borderRadius;
  final double? minWidth;
  final double? minHeight;

  const AppRippleButton({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.borderRadius,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
        splashColor: (rippleColor ?? AppTheme.primaryColor).withValues(alpha: 0.1),
        highlightColor: (rippleColor ?? AppTheme.primaryColor).withValues(alpha: 0.05),
        child: Container(
          constraints: BoxConstraints(
            minWidth: minWidth ?? AppTheme.minimumTouchTarget,
            minHeight: minHeight ?? AppTheme.minimumTouchTarget,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// プレスアニメーション付きコンテナ
/// 
/// カードやリストアイテムに使用するプレスエフェクト
/// 軽いタッチフィードバックを提供します。
class AppPressableContainer extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Border? border;

  const AppPressableContainer({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return GestureDetector(
      onTapDown: onTap != null 
          ? (_) => animationController.forward()
          : null,
      onTapUp: onTap != null 
          ? (_) {
              animationController.reverse();
              Future.delayed(const Duration(milliseconds: 50), () {
                onTap?.call();
              });
            }
          : null,
      onTapCancel: onTap != null 
          ? () => animationController.reverse()
          : null,
      onLongPress: onLongPress,
      child: Transform.scale(
        scale: scaleAnimation,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// フローティングアクションボタンのアニメーション版
/// 
/// 拡張可能なFABにホバーとタップアニメーションを追加
class AppAnimatedFab extends HookWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;

  const AppAnimatedFab({
    super.key,
    this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final hoverAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    final tapAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    final hoverAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: hoverAnimationController,
          curve: Curves.easeOut,
        ),
      ),
    );

    final tapAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(
          parent: tapAnimationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return MouseRegion(
      onEnter: onPressed != null 
          ? (_) => hoverAnimationController.forward()
          : null,
      onExit: onPressed != null 
          ? (_) => hoverAnimationController.reverse()
          : null,
      child: GestureDetector(
        onTapDown: onPressed != null 
            ? (_) => tapAnimationController.forward()
            : null,
        onTapUp: onPressed != null 
            ? (_) {
                tapAnimationController.reverse();
                Future.delayed(const Duration(milliseconds: 50), () {
                  onPressed?.call();
                });
              }
            : null,
        onTapCancel: onPressed != null 
            ? () => tapAnimationController.reverse()
            : null,
        child: Transform.scale(
          scale: hoverAnimation * tapAnimation,
          child: isExtended && label != null
              ? FloatingActionButton.extended(
                  onPressed: onPressed,
                  icon: icon,
                  label: Text(label!),
                  backgroundColor: backgroundColor ?? AppTheme.primaryColor,
                  foregroundColor: foregroundColor ?? AppTheme.primaryForeground,
                )
              : FloatingActionButton(
                  onPressed: onPressed,
                  backgroundColor: backgroundColor ?? AppTheme.primaryColor,
                  foregroundColor: foregroundColor ?? AppTheme.primaryForeground,
                  child: icon,
                ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// 高度なフィードバックシステム
///
/// ユーザーのアクションに対する豊富なフィードバックを提供
/// 視覚的・触覚的・聴覚的フィードバックを統合
class AppFeedbackSystem {
  /// 成功フィードバック
  static Future<void> success({
    required BuildContext context,
    String? message,
    bool showToast = true,
    bool hapticFeedback = true,
  }) async {
    if (hapticFeedback) {
      await HapticFeedback.lightImpact();
    }

    if (showToast && message != null && context.mounted) {
      _showFeedbackSnackBar(
        context: context,
        message: message,
        type: FeedbackType.success,
      );
    }
  }

  /// エラーフィードバック
  static Future<void> error({
    required BuildContext context,
    String? message,
    bool showToast = true,
    bool hapticFeedback = true,
  }) async {
    if (hapticFeedback) {
      await HapticFeedback.mediumImpact();
    }

    if (showToast && message != null && context.mounted) {
      _showFeedbackSnackBar(
        context: context,
        message: message,
        type: FeedbackType.error,
      );
    }
  }

  /// 警告フィードバック
  static Future<void> warning({
    required BuildContext context,
    String? message,
    bool showToast = true,
    bool hapticFeedback = true,
  }) async {
    if (hapticFeedback) {
      await HapticFeedback.selectionClick();
    }

    if (showToast && message != null && context.mounted) {
      _showFeedbackSnackBar(
        context: context,
        message: message,
        type: FeedbackType.warning,
      );
    }
  }

  /// 情報フィードバック
  static Future<void> info({
    required BuildContext context,
    String? message,
    bool showToast = true,
    bool hapticFeedback = false,
  }) async {
    if (hapticFeedback) {
      await HapticFeedback.selectionClick();
    }

    if (showToast && message != null && context.mounted) {
      _showFeedbackSnackBar(
        context: context,
        message: message,
        type: FeedbackType.info,
      );
    }
  }

  /// 軽い触覚フィードバック
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// 中程度の触覚フィードバック
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// 強い触覚フィードバック
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// 選択フィードバック
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  static void _showFeedbackSnackBar({
    required BuildContext context,
    required String message,
    required FeedbackType type,
  }) {
    final color = _getTypeColor(type);
    final icon = _getTypeIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        margin: const EdgeInsets.all(AppTheme.spacing16),
      ),
    );
  }

  static Color _getTypeColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.error:
        return AppTheme.destructiveColor;
      case FeedbackType.warning:
        return Colors.orange;
      case FeedbackType.info:
        return Colors.blue;
    }
  }

  static IconData _getTypeIcon(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.error:
        return Icons.error;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.info:
        return Icons.info;
    }
  }
}

enum FeedbackType { success, error, warning, info }

/// インタラクティブなフィードバックウィジェット
///
/// ボタンやカードに統合されたフィードバック機能
class AppInteractiveFeedback extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableHapticFeedback;
  final bool enableVisualFeedback;
  final bool enableScaleAnimation;
  final Color? feedbackColor;
  final Duration animationDuration;

  const AppInteractiveFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enableHapticFeedback = true,
    this.enableVisualFeedback = true,
    this.enableScaleAnimation = true,
    this.feedbackColor,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: animationDuration,
    );

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
    );

    return GestureDetector(
      onTapDown: onTap != null
          ? (_) async {
              if (enableScaleAnimation) {
                animationController.forward();
              }
              if (enableHapticFeedback) {
                await AppFeedbackSystem.lightImpact();
              }
            }
          : null,
      onTapUp: onTap != null
          ? (_) async {
              if (enableScaleAnimation) {
                await animationController.reverse();
              }
              onTap?.call();
            }
          : null,
      onTapCancel: onTap != null
          ? () {
              if (enableScaleAnimation) {
                animationController.reverse();
              }
            }
          : null,
      onLongPress: onLongPress != null
          ? () async {
              if (enableHapticFeedback) {
                await AppFeedbackSystem.mediumImpact();
              }
              onLongPress?.call();
            }
          : null,
      child: enableScaleAnimation
          ? Transform.scale(scale: scaleAnimation, child: _buildChild(context))
          : _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (enableVisualFeedback) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null, // GestureDetectorで処理
          splashColor: (feedbackColor ?? AppTheme.primaryColor).withValues(
            alpha: 0.1,
          ),
          highlightColor: (feedbackColor ?? AppTheme.primaryColor).withValues(
            alpha: 0.05,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: child,
        ),
      );
    }
    return child;
  }
}

/// プルスアクションフィードバック
///
/// プルリフレッシュ時の視覚的フィードバック
class AppPullFeedback extends HookWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshText;
  final Color indicatorColor;

  const AppPullFeedback({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshText = '更新中...',
    this.indicatorColor = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await AppFeedbackSystem.lightImpact();
        await onRefresh();
        // BuildContextを非同期処理前に取得してフィードバックを実行
        if (context.mounted) {
          await AppFeedbackSystem.success(
            context: context,
            message: '更新が完了しました',
            showToast: false,
            hapticFeedback: true,
          );
        }
      },
      color: indicatorColor,
      backgroundColor: Colors.white,
      child: child,
    );
  }
}

/// ローディング状態のフィードバック
class AppLoadingFeedback extends HookWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingText;
  final bool showProgressIndicator;

  const AppLoadingFeedback({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingText,
    this.showProgressIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    if (loadingWidget != null) {
      return loadingWidget!;
    }

    return Stack(
      children: [
        Opacity(opacity: 0.5, child: child),
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.1),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showProgressIndicator)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  if (loadingText != null) ...[
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      loadingText!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mutedForegroundAccessible,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 状態変化のフィードバック
class AppStateChangeFeedback extends HookWidget {
  final bool isActive;
  final Widget child;
  final Duration animationDuration;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppStateChangeFeedback({
    super.key,
    required this.isActive,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 200),
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: animationDuration,
    );

    final colorAnimation = useAnimation(
      ColorTween(
        begin: inactiveColor ?? AppTheme.mutedColor,
        end: activeColor ?? AppTheme.primaryColor,
      ).animate(animationController),
    );

    useEffect(() {
      if (isActive) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isActive]);

    return AnimatedContainer(
      duration: animationDuration,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorAnimation ?? Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: child,
    );
  }
}

/// エラー状態のフィードバック
class AppErrorFeedback extends HookWidget {
  final bool hasError;
  final Widget child;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AppErrorFeedback({
    super.key,
    required this.hasError,
    required this.child,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useEffect(() {
      if (hasError) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [hasError]);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Transform.translate(
          offset: hasError
              ? Offset(2.0 * animationController.value - 1.0, 0)
              : Offset.zero,
          child: Container(
            decoration: hasError
                ? BoxDecoration(
                    border: Border.all(
                      color: AppTheme.destructiveColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  )
                : null,
            child: child,
          ),
        );
      },
    );
  }
}

/// カスタマイズ可能なフィードバックオーバーレイ
class AppFeedbackOverlay extends StatelessWidget {
  final Widget child;
  final bool isVisible;
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppFeedbackOverlay({
    super.key,
    required this.child,
    required this.isVisible,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVisible)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 48,
                          color: textColor ?? AppTheme.primaryColor,
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                      ],
                      Text(
                        message,
                        style: AppTheme.bodyLarge.copyWith(
                          color: textColor ?? AppTheme.foregroundColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

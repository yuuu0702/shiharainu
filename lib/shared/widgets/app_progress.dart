import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppProgressSize { small, medium, large }

enum AppProgressType { circular, linear, skeleton }

class AppProgress extends StatelessWidget {
  final AppProgressSize size;
  final AppProgressType type;
  final String? label;
  final double? value; // 進捗率 (0.0 - 1.0)
  final Color? color;
  final Color? backgroundColor;
  final double? strokeWidth;

  const AppProgress({
    super.key,
    this.size = AppProgressSize.medium,
    this.type = AppProgressType.circular,
    this.label,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
  });

  // 便利なコンストラクタ
  const AppProgress.circular({
    super.key,
    this.size = AppProgressSize.medium,
    this.label,
    this.value,
    this.color,
    this.strokeWidth,
  }) : type = AppProgressType.circular,
       backgroundColor = null;

  const AppProgress.linear({
    super.key,
    this.label,
    this.value,
    this.color,
    this.backgroundColor,
  }) : type = AppProgressType.linear,
       size = AppProgressSize.medium,
       strokeWidth = null;

  const AppProgress.skeleton({super.key, this.size = AppProgressSize.medium})
    : type = AppProgressType.skeleton,
      label = null,
      value = null,
      color = null,
      backgroundColor = null,
      strokeWidth = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppProgressType.circular:
        return _buildCircularProgress(context);
      case AppProgressType.linear:
        return _buildLinearProgress(context);
      case AppProgressType.skeleton:
        return _buildSkeletonProgress(context);
    }
  }

  Widget _buildCircularProgress(BuildContext context) {
    final progressSize = _getProgressSize();
    final progressColor = color ?? AppTheme.primaryColor;

    return Semantics(
      label: label ?? 'ローディング中',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: progressSize,
            height: progressSize,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth ?? _getStrokeWidth(),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor:
                  backgroundColor ?? progressColor.withValues(alpha: 0.2),
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: AppTheme.spacing8),
            Text(
              label!,
              style: _getLabelStyle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLinearProgress(BuildContext context) {
    final progressColor = color ?? AppTheme.primaryColor;
    final bgColor = backgroundColor ?? progressColor.withValues(alpha: 0.2);

    return Semantics(
      label: label ?? 'ローディング中',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null) ...[
            Text(label!, style: _getLabelStyle(context)),
            const SizedBox(height: AppTheme.spacing8),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusXSmall),
            child: LinearProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: bgColor,
              minHeight: 6,
            ),
          ),
          if (value != null) ...[
            const SizedBox(height: AppTheme.spacing4),
            Text(
              '${(value! * 100).toInt()}%',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonProgress(BuildContext context) {
    final skeletonHeight = _getSkeletonHeight();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode
        ? const Color(0xFF2A2A2E)
        : const Color(0xFFE5E7EB);
    final highlightColor = isDarkMode
        ? const Color(0xFF374151)
        : const Color(0xFFF3F4F6);

    return Semantics(
      label: 'コンテンツ読み込み中',
      child: _SkeletonAnimation(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: skeletonHeight,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusXSmall),
          ),
        ),
      ),
    );
  }

  double _getProgressSize() {
    switch (size) {
      case AppProgressSize.small:
        return 24;
      case AppProgressSize.medium:
        return 32;
      case AppProgressSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppProgressSize.small:
        return 2.5;
      case AppProgressSize.medium:
        return 3.0;
      case AppProgressSize.large:
        return 4.0;
    }
  }

  double _getSkeletonHeight() {
    switch (size) {
      case AppProgressSize.small:
        return 16;
      case AppProgressSize.medium:
        return 20;
      case AppProgressSize.large:
        return 24;
    }
  }

  TextStyle _getLabelStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppTheme.bodySmall.copyWith(
      color: isDarkMode ? Colors.white70 : AppTheme.mutedForegroundAccessible,
    );
  }
}

// フルスクリーンローディング表示
class AppFullScreenProgress extends StatelessWidget {
  final String? message;
  final bool barrierDismissible;
  final Color? barrierColor;

  const AppFullScreenProgress({
    super.key,
    this.message,
    this.barrierDismissible = false,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        barrierColor ?? (isDarkMode ? Colors.black54 : Colors.white70);

    return Material(
      color: backgroundColor,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2E) : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.elevationHigh,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppProgress.circular(size: AppProgressSize.large),
              if (message != null) ...[
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  message!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ダイアログとして表示する静的メソッド
  static Future<T?> show<T>(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppFullScreenProgress(
        message: message,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}

// スケルトン用アニメーション
class _SkeletonAnimation extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const _SkeletonAnimation({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_SkeletonAnimation> createState() => _SkeletonAnimationState();
}

class _SkeletonAnimationState extends State<_SkeletonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// スケルトンスクリーン用のコンポーネント群
class AppSkeletonText extends StatelessWidget {
  final double? width;
  final double height;

  const AppSkeletonText({super.key, this.width, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return AppProgress.skeleton(size: AppProgressSize.small);
  }
}

class AppSkeletonCard extends StatelessWidget {
  final double? width;
  final double height;

  const AppSkeletonCard({super.key, this.width, this.height = 120});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode
        ? const Color(0xFF2A2A2E)
        : const Color(0xFFE5E7EB);
    final highlightColor = isDarkMode
        ? const Color(0xFF374151)
        : const Color(0xFFF3F4F6);

    return _SkeletonAnimation(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}

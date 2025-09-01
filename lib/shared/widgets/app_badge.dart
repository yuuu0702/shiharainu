import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppBadgeVariant {
  default_,
  secondary,
  destructive,
  success,
  warning,
  info,
}

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.default_,
  });

  const AppBadge.secondary({super.key, required this.text})
    : variant = AppBadgeVariant.secondary;

  const AppBadge.destructive({super.key, required this.text})
    : variant = AppBadgeVariant.destructive;

  const AppBadge.success({super.key, required this.text})
    : variant = AppBadgeVariant.success;

  const AppBadge.warning({super.key, required this.text})
    : variant = AppBadgeVariant.warning;

  const AppBadge.info({super.key, required this.text})
    : variant = AppBadgeVariant.info;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors['foreground'],
        ),
      ),
    );
  }

  Map<String, Color> _getColors() {
    switch (variant) {
      case AppBadgeVariant.default_:
        return {
          'background': AppTheme.mutedColor,
          'foreground': AppTheme.mutedForeground,
        };
      case AppBadgeVariant.secondary:
        return {
          'background': const Color(0xFFF1F5F9),
          'foreground': const Color(0xFF475569),
        };
      case AppBadgeVariant.destructive:
        return {
          'background': const Color(0xFFFEF2F2),
          'foreground': AppTheme.destructiveColor,
        };
      case AppBadgeVariant.success:
        return {
          'background': const Color(0xFFF0FDF4),
          'foreground': const Color(0xFF16A34A), // 緑系の文字色に変更
        };
      case AppBadgeVariant.warning:
        return {
          'background': const Color(0xFFFFFBEB),
          'foreground': AppTheme.warningColor,
        };
      case AppBadgeVariant.info:
        return {
          'background': const Color(0xFFEFF6FF),
          'foreground': AppTheme.infoColor,
        };
    }
  }
}

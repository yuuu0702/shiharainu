import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppCardElevation { none, low, medium, high }

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final bool isSelected;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final AppCardElevation elevation;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.isInteractive = false,
    this.isSelected = false,
    this.padding,
    this.margin,
    this.elevation = AppCardElevation.low,
  });

  const AppCard.interactive({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding,
    this.margin,
    this.elevation = AppCardElevation.medium,
  }) : isInteractive = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : AppTheme.mutedColor,
          width: 1,
        ),
        boxShadow: _getElevationShadow(),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
        child: child,
      ),
    );

    if (isInteractive || onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          hoverColor: const Color(0x0CEA3800), // primary/5
          splashColor: const Color(0x1AEA3800), // primary/10
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }

  List<BoxShadow> _getElevationShadow() {
    if (isSelected) {
      // Selected state gets enhanced shadow with primary color accent
      return [
        const BoxShadow(
          color: Color(0x1AEA3800), // primary/10
          offset: Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        ...AppTheme.elevationMedium,
      ];
    }

    switch (elevation) {
      case AppCardElevation.none:
        return [];
      case AppCardElevation.low:
        return AppTheme.elevationLow;
      case AppCardElevation.medium:
        return AppTheme.elevationMedium;
      case AppCardElevation.high:
        return AppTheme.elevationHigh;
    }
  }
}

class AppCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const AppCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  subtitle!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppTheme.spacing16),
          trailing!,
        ],
      ],
    );
  }
}

class AppCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppCardContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: AppTheme.spacing16),
      child: child,
    );
  }
}

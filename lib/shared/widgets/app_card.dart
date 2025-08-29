import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final bool isSelected;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.isInteractive = false,
    this.isSelected = false,
    this.padding,
    this.margin,
  });

  const AppCard.interactive({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding,
    this.margin,
  }) : isInteractive = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected 
              ? AppTheme.primaryColor 
              : AppTheme.mutedColor,
          width: 1,
        ),
        boxShadow: isSelected 
            ? [
                const BoxShadow(
                  color: Color(0x1AEA3800), // primary/10
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (isInteractive || onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: const Color(0x0CEA3800), // primary/5
          splashColor: const Color(0x1AEA3800), // primary/10
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing!,
        ],
      ],
    );
  }
}

class AppCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppCardContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16),
      child: child,
    );
  }
}
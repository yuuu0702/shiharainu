import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppButtonVariant {
  primary,
  outline,
  secondary,
  ghost,
  link,
}

enum AppButtonSize {
  small,
  medium,
  large,
  icon,
}

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isDestructive;
  final bool isLoading;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isDestructive = false,
    this.isLoading = false,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided');

  const AppButton.primary({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  }) : variant = AppButtonVariant.primary,
       isDestructive = false;

  const AppButton.outline({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  }) : variant = AppButtonVariant.outline,
       isDestructive = false;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  }) : variant = AppButtonVariant.secondary,
       isDestructive = false;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.size = AppButtonSize.small,
    this.isDestructive = true,
  }) : variant = AppButtonVariant.ghost,
       isLoading = false;

  const AppButton.link({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
  }) : variant = AppButtonVariant.link,
       icon = null,
       isDestructive = false,
       isLoading = false;

  const AppButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.isDestructive = false,
  }) : variant = AppButtonVariant.ghost,
       text = null,
       size = AppButtonSize.icon,
       isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (variant == AppButtonVariant.link) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: _getPadding(),
          textStyle: _getTextStyle().copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
        child: _buildChild(),
      );
    }

    if (variant == AppButtonVariant.primary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? AppTheme.destructiveColor : AppTheme.primaryColor,
          foregroundColor: AppTheme.primaryForeground,
          elevation: 0, // Figmaガイドライン: フラットデザイン
          padding: _getPadding(),
          minimumSize: _getMinimumSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          textStyle: _getTextStyle(),
        ),
        child: _buildChild(),
      );
    }

    if (variant == AppButtonVariant.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDestructive ? AppTheme.destructiveColor : theme.colorScheme.onSurface,
          side: BorderSide(
            color: isDestructive ? AppTheme.destructiveColor : AppTheme.mutedColor,
          ),
          padding: _getPadding(),
          minimumSize: _getMinimumSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          textStyle: _getTextStyle(),
        ),
        child: _buildChild(),
      );
    }

    if (variant == AppButtonVariant.secondary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.mutedColor,
          foregroundColor: AppTheme.mutedForeground,
          elevation: 0,
          padding: _getPadding(),
          minimumSize: _getMinimumSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          textStyle: _getTextStyle(),
        ),
        child: _buildChild(),
      );
    }

    // ghost variant
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isDestructive ? AppTheme.destructiveColor : theme.colorScheme.onSurface,
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        textStyle: _getTextStyle(),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary 
                    ? AppTheme.primaryForeground 
                    : AppTheme.primaryColor,
              ),
            ),
          ),
          if (text != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            Text(text!),
          ],
        ],
      );
    }

    if (text != null && icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppTheme.spacing8),
          Text(text!),
        ],
      );
    }

    return text != null ? Text(text!) : icon!;
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return icon != null && text == null 
            ? const EdgeInsets.all(AppTheme.spacing8) 
            : const EdgeInsets.symmetric(vertical: AppTheme.spacing8, horizontal: AppTheme.spacing12);
      case AppButtonSize.medium:
        return icon != null && text == null 
            ? const EdgeInsets.all(AppTheme.spacing8) 
            : const EdgeInsets.symmetric(vertical: AppTheme.spacing12, horizontal: AppTheme.spacing16);
      case AppButtonSize.large:
        return icon != null && text == null 
            ? const EdgeInsets.all(AppTheme.spacing12) 
            : const EdgeInsets.symmetric(vertical: AppTheme.spacing16, horizontal: AppTheme.spacing24);
      case AppButtonSize.icon:
        return const EdgeInsets.all(AppTheme.spacing8);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(0, 32);
      case AppButtonSize.medium:
        return const Size(0, 36);
      case AppButtonSize.large:
        return const Size(0, 40);
      case AppButtonSize.icon:
        return const Size(36, 36);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTheme.labelMedium;
      case AppButtonSize.medium:
        return AppTheme.labelLarge;
      case AppButtonSize.large:
        return AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500);
      case AppButtonSize.icon:
        return AppTheme.labelLarge;
    }
  }
}
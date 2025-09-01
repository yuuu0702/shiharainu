import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppAvatarSize {
  small, // 32px
  medium, // 40px
  large, // 48px
  xlarge, // 64px
}

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showOnlineIndicator;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showBorder = false,
    this.showOnlineIndicator = false,
  }) : assert(
         imageUrl != null || initials != null,
         'Either imageUrl or initials must be provided',
       );

  const AppAvatar.small({
    super.key,
    this.imageUrl,
    this.initials,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showBorder = false,
    this.showOnlineIndicator = false,
  }) : size = AppAvatarSize.small,
       assert(
         imageUrl != null || initials != null,
         'Either imageUrl or initials must be provided',
       );

  const AppAvatar.medium({
    super.key,
    this.imageUrl,
    this.initials,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showBorder = false,
    this.showOnlineIndicator = false,
  }) : size = AppAvatarSize.medium,
       assert(
         imageUrl != null || initials != null,
         'Either imageUrl or initials must be provided',
       );

  const AppAvatar.large({
    super.key,
    this.imageUrl,
    this.initials,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showBorder = false,
    this.showOnlineIndicator = false,
  }) : size = AppAvatarSize.large,
       assert(
         imageUrl != null || initials != null,
         'Either imageUrl or initials must be provided',
       );

  const AppAvatar.xlarge({
    super.key,
    this.imageUrl,
    this.initials,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.showBorder = false,
    this.showOnlineIndicator = false,
  }) : size = AppAvatarSize.xlarge,
       assert(
         imageUrl != null || initials != null,
         'Either imageUrl or initials must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = _getSize();

    Widget avatar = Stack(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppTheme.mutedColor,
            border: showBorder
                ? Border.all(color: theme.colorScheme.outline, width: 2)
                : null,
            boxShadow: AppTheme.elevationLow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarSize / 2),
            child: _buildContent(),
          ),
        ),
        if (showOnlineIndicator) _buildOnlineIndicator(),
      ],
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(avatarSize / 2),
          child: avatar,
        ),
      );
    }

    return avatar;
  }

  Widget _buildContent() {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: _getSize(),
        height: _getSize(),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialsContent();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: _getSize(),
            height: _getSize(),
            color: AppTheme.mutedColor,
            child: Center(
              child: SizedBox(
                width: _getSize() * 0.4,
                height: _getSize() * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return _buildInitialsContent();
  }

  Widget _buildInitialsContent() {
    return Container(
      width: _getSize(),
      height: _getSize(),
      color: backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initials ?? '?',
          style: _getTextStyle().copyWith(
            color: textColor ?? AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    final indicatorSize = _getSize() * 0.25;
    final offset = _getSize() * 0.1;

    return Positioned(
      right: offset,
      bottom: offset,
      child: Container(
        width: indicatorSize,
        height: indicatorSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF10B981), // green-500
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AppAvatarSize.small:
        return 32.0;
      case AppAvatarSize.medium:
        return 40.0;
      case AppAvatarSize.large:
        return 48.0;
      case AppAvatarSize.xlarge:
        return 64.0;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppAvatarSize.small:
        return AppTheme.labelMedium;
      case AppAvatarSize.medium:
        return AppTheme.labelLarge;
      case AppAvatarSize.large:
        return AppTheme.bodyLarge;
      case AppAvatarSize.xlarge:
        return AppTheme.headlineSmall;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

enum AppProfileCardSize {
  compact, // 小型（アバター + 名前のみ）
  standard, // 標準（アバター + 名前 + サブタイトル）
  detailed, // 詳細（アバター + 名前 + サブタイトル + 説明）
}

class AppProfileCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final String? initials;
  final AppProfileCardSize size;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showOnlineIndicator;
  final AppAvatarSize avatarSize;

  const AppProfileCard({
    super.key,
    required this.name,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.initials,
    this.size = AppProfileCardSize.standard,
    this.onTap,
    this.trailing,
    this.showOnlineIndicator = false,
    this.avatarSize = AppAvatarSize.medium,
  });

  const AppProfileCard.compact({
    super.key,
    required this.name,
    this.imageUrl,
    this.initials,
    this.onTap,
    this.trailing,
    this.showOnlineIndicator = false,
  }) : subtitle = null,
       description = null,
       size = AppProfileCardSize.compact,
       avatarSize = AppAvatarSize.small;

  const AppProfileCard.standard({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
    this.initials,
    this.onTap,
    this.trailing,
    this.showOnlineIndicator = false,
  }) : description = null,
       size = AppProfileCardSize.standard,
       avatarSize = AppAvatarSize.medium;

  const AppProfileCard.detailed({
    super.key,
    required this.name,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.initials,
    this.onTap,
    this.trailing,
    this.showOnlineIndicator = false,
  }) : size = AppProfileCardSize.detailed,
       avatarSize = AppAvatarSize.large;

  @override
  Widget build(BuildContext context) {
    Widget card = AppCard(
      elevation: AppCardElevation.low,
      padding: _getPadding(),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: imageUrl,
            initials: initials ?? _generateInitials(name),
            size: avatarSize,
            showOnlineIndicator: showOnlineIndicator,
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildContent()),
          if (trailing != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return AppCard.interactive(
        elevation: AppCardElevation.medium,
        padding: _getPadding(),
        onTap: onTap,
        child: Row(
          children: [
            AppAvatar(
              imageUrl: imageUrl,
              initials: initials ?? _generateInitials(name),
              size: avatarSize,
              showOnlineIndicator: showOnlineIndicator,
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(child: _buildContent()),
            if (trailing != null) ...[
              const SizedBox(width: AppTheme.spacing8),
              trailing!,
            ],
          ],
        ),
      );
    }

    return card;
  }

  Widget _buildContent() {
    switch (size) {
      case AppProfileCardSize.compact:
        return _buildCompactContent();
      case AppProfileCardSize.standard:
        return _buildStandardContent();
      case AppProfileCardSize.detailed:
        return _buildDetailedContent();
    }
  }

  Widget _buildCompactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStandardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppTheme.spacing4),
          Text(
            subtitle!,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: AppTheme.headlineSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppTheme.spacing4),
          Text(
            subtitle!,
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.mutedForeground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (description != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Text(
            description!,
            style: AppTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppProfileCardSize.compact:
        return const EdgeInsets.all(AppTheme.spacing12);
      case AppProfileCardSize.standard:
        return const EdgeInsets.all(AppTheme.spacing16);
      case AppProfileCardSize.detailed:
        return const EdgeInsets.all(AppTheme.spacing20);
    }
  }

  String _generateInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '?';
    } else {
      return words
          .take(2)
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
          .join();
    }
  }
}

class AppProfileCardGroup extends StatelessWidget {
  final List<AppProfileCard> profiles;
  final String? title;
  final Widget? trailing;
  final int maxVisible;
  final VoidCallback? onSeeAll;

  const AppProfileCardGroup({
    super.key,
    required this.profiles,
    this.title,
    this.trailing,
    this.maxVisible = 3,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final visibleProfiles = profiles.take(maxVisible).toList();
    final hasMore = profiles.length > maxVisible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
            child: Row(
              children: [
                Expanded(child: Text(title!, style: AppTheme.headlineMedium)),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        Column(
          children: [
            ...visibleProfiles.map(
              (profile) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                child: profile,
              ),
            ),
            if (hasMore && onSeeAll != null)
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacing8),
                child: AppButton.link(
                  text: '他${profiles.length - maxVisible}人を表示',
                  onPressed: onSeeAll,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

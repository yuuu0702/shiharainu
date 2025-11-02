import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? prefixIcon;
  final List<Widget>? actions;

  const AppSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.controller,
    this.enabled = true,
    this.prefixIcon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = controller ?? TextEditingController();

    return Container(
      height: AppTheme.minimumTouchTarget,
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.mutedColor, width: 1),
      ),
      child: Row(
        children: [
          // 検索アイコン
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
            child: Icon(
              Icons.search,
              color: AppTheme.mutedForegroundAccessible,
              size: 20,
            ),
          ),

          // 検索入力フィールド
          Expanded(
            child: TextField(
              controller: searchController,
              enabled: enabled,
              onChanged: onChanged,
              style: AppTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hintText ?? '検索...',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),

          // クリアボタン
          if (searchController.text.isNotEmpty && onClear != null)
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacing8),
              child: GestureDetector(
                onTap: () {
                  searchController.clear();
                  onClear?.call();
                },
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  child: Icon(
                    Icons.clear,
                    size: 16,
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
              ),
            ),

          // 追加のアクション（フィルターボタンなど）
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppTheme.primaryColor
        : AppTheme.mutedColor;
    final textColor = isSelected
        ? AppTheme.primaryForeground
        : AppTheme.mutedForegroundAccessible;

    return GestureDetector(
      onTap: () => onSelected?.call(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: isSelected ? null : Border.all(color: AppTheme.mutedColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: AppTheme.spacing4),
            ],
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppFilterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const AppFilterSection({
    super.key,
    required this.title,
    required this.children,
    this.isExpanded = true,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションタイトル
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (onToggle != null)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppTheme.mutedForegroundAccessible,
                  ),
              ],
            ),
          ),
        ),

        // フィルターオプション
        if (isExpanded) ...[
          const SizedBox(height: AppTheme.spacing8),
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: children,
          ),
        ],
      ],
    );
  }
}

class AppSortOptions extends StatelessWidget {
  final String? selectedOption;
  final List<SortOption> options;
  final ValueChanged<String>? onChanged;

  const AppSortOptions({
    super.key,
    this.selectedOption,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      initialValue: selectedOption,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.mutedColor),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              size: 16,
              color: AppTheme.mutedForegroundAccessible,
            ),
            const SizedBox(width: AppTheme.spacing4),
            Text(
              _getSelectedLabel(),
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
            ),
            const SizedBox(width: AppTheme.spacing4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AppTheme.mutedForegroundAccessible,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem<String>(
          value: option.value,
          child: Row(
            children: [
              Icon(
                option.icon,
                size: 16,
                color: selectedOption == option.value
                    ? AppTheme.primaryColor
                    : AppTheme.mutedForegroundAccessible,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                option.label,
                style: AppTheme.bodyMedium.copyWith(
                  color: selectedOption == option.value
                      ? AppTheme.primaryColor
                      : null,
                  fontWeight: selectedOption == option.value
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getSelectedLabel() {
    if (selectedOption == null) return 'ソート';
    final option = options.firstWhere(
      (opt) => opt.value == selectedOption,
      orElse: () => SortOption(value: '', label: 'ソート', icon: Icons.sort),
    );
    return option.label;
  }
}

class SortOption {
  final String value;
  final String label;
  final IconData icon;

  const SortOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class AppSearchFilterBar extends StatelessWidget {
  final String? searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final Widget? sortWidget;
  final VoidCallback? onFilterTap;
  final int? activeFiltersCount;

  const AppSearchFilterBar({
    super.key,
    this.searchQuery,
    this.onSearchChanged,
    this.onSearchClear,
    this.sortWidget,
    this.onFilterTap,
    this.activeFiltersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 検索バー
            Expanded(
              child: AppSearchBar(
                hintText: 'イベントを検索...',
                onChanged: onSearchChanged,
                onClear: onSearchClear,
              ),
            ),

            const SizedBox(width: AppTheme.spacing8),

            // フィルターボタン
            if (onFilterTap != null)
              GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  height: AppTheme.minimumTouchTarget,
                  width: AppTheme.minimumTouchTarget,
                  decoration: BoxDecoration(
                    color: activeFiltersCount != null && activeFiltersCount! > 0
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : AppTheme.inputBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color:
                          activeFiltersCount != null && activeFiltersCount! > 0
                          ? AppTheme.primaryColor
                          : AppTheme.mutedColor,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.filter_list,
                          color:
                              activeFiltersCount != null &&
                                  activeFiltersCount! > 0
                              ? AppTheme.primaryColor
                              : AppTheme.mutedForegroundAccessible,
                          size: 20,
                        ),
                      ),
                      // フィルター数バッジ
                      if (activeFiltersCount != null && activeFiltersCount! > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              activeFiltersCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        // ソートオプション
        if (sortWidget != null) ...[
          const SizedBox(height: AppTheme.spacing12),
          Row(children: [sortWidget!, const Spacer()]),
        ],
      ],
    );
  }
}

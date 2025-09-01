import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppSegmentedControlSize { small, medium, large }

class AppSegmentedControlOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppSegmentedControlOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class AppSegmentedControl<T> extends StatelessWidget {
  final List<AppSegmentedControlOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final AppSegmentedControlSize size;

  const AppSegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.size = AppSegmentedControlSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final fontSize = _getFontSize();

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.mutedColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options
            .map((option) => Expanded(child: _buildOption(option, fontSize)))
            .toList(),
      ),
    );
  }

  Widget _buildOption(AppSegmentedControlOption<T> option, double fontSize) {
    final isSelected = option.value == value;

    return GestureDetector(
      onTap: () => onChanged(option.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (option.icon != null) ...[
                Icon(
                  option.icon,
                  size: 16,
                  color: isSelected ? Colors.black87 : AppTheme.mutedForeground,
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.black87
                        : AppTheme.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppSegmentedControlSize.small:
        return 32;
      case AppSegmentedControlSize.medium:
        return 36;
      case AppSegmentedControlSize.large:
        return 40;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppSegmentedControlSize.small:
        return 12;
      case AppSegmentedControlSize.medium:
        return 14;
      case AppSegmentedControlSize.large:
        return 16;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? initialValue;
  final String? errorText;
  final bool isRequired;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppInput({
    super.key,
    this.label,
    this.placeholder,
    this.initialValue,
    this.errorText,
    this.isRequired = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    Colors.black87,
              ),
              children: [
                TextSpan(text: label!),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppTheme.destructiveColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: placeholder,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }
}

class AppTextarea extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? initialValue;
  final String? errorText;
  final bool isRequired;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final int minLines;
  final int? maxLines;
  final int? maxLength;

  const AppTextarea({
    super.key,
    this.label,
    this.placeholder,
    this.initialValue,
    this.errorText,
    this.isRequired = false,
    this.onChanged,
    this.controller,
    this.minLines = 3,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    Colors.black87,
              ),
              children: [
                TextSpan(text: label!),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppTheme.destructiveColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          minLines: minLines,
          maxLines: maxLines ?? minLines,
          maxLength: maxLength,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: placeholder,
            errorText: errorText,
            counterText: maxLength != null ? null : '',
            alignLabelWithHint: true,
            // Figmaガイドライン: px-3 py-2 = 左右12px、上下8px
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class AppSelect<T> extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final bool isRequired;

  const AppSelect({
    super.key,
    this.label,
    this.placeholder,
    this.value,
    required this.items,
    this.onChanged,
    this.errorText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    Colors.black87,
              ),
              children: [
                TextSpan(text: label!),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppTheme.destructiveColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true, // オーバーフロー防止のため幅を最大化
          decoration: InputDecoration(
            hintText: placeholder,
            errorText: errorText,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:
                Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

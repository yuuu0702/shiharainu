import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

enum AppToastType { success, error, warning, info }

class AppToast extends StatelessWidget {
  final String message;
  final AppToastType type;
  final VoidCallback? onDismiss;
  final Duration? duration;
  final IconData? customIcon;

  const AppToast({
    super.key,
    required this.message,
    this.type = AppToastType.info,
    this.onDismiss,
    this.duration,
    this.customIcon,
  });

  // 便利なコンストラクタ
  const AppToast.success({
    super.key,
    required this.message,
    this.onDismiss,
    this.duration,
  }) : type = AppToastType.success,
       customIcon = null;

  const AppToast.error({
    super.key,
    required this.message,
    this.onDismiss,
    this.duration,
  }) : type = AppToastType.error,
       customIcon = null;

  const AppToast.warning({
    super.key,
    required this.message,
    this.onDismiss,
    this.duration,
  }) : type = AppToastType.warning,
       customIcon = null;

  const AppToast.info({
    super.key,
    required this.message,
    this.onDismiss,
    this.duration,
  }) : type = AppToastType.info,
       customIcon = null;

  @override
  Widget build(BuildContext context) {
    final toastConfig = _getToastConfig();

    return Container(
      constraints: const BoxConstraints(
        minHeight: AppTheme.minimumTouchTarget, // アクセシビリティ対応
        maxWidth: 400,
      ),
      margin: const EdgeInsets.all(AppTheme.spacing16),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: toastConfig.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: toastConfig.borderColor, width: 1),
        boxShadow: AppTheme.elevationMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // アイコン
          Icon(
            customIcon ?? toastConfig.icon,
            color: toastConfig.iconColor,
            size: 20,
            semanticLabel: toastConfig.semanticLabel,
          ),
          const SizedBox(width: AppTheme.spacing12),
          // メッセージ
          Expanded(
            child: Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: toastConfig.textColor,
                fontWeight: FontWeight.w500,
              ),
              semanticsLabel: '${toastConfig.semanticLabel}: $message',
            ),
          ),
          // 閉じるボタン（オプション）
          if (onDismiss != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacing4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: toastConfig.textColor.withValues(alpha: 0.7),
                  semanticLabel: '通知を閉じる',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ToastConfig _getToastConfig() {
    switch (type) {
      case AppToastType.success:
        return _ToastConfig(
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
          iconColor: Colors.green.shade600,
          textColor: Colors.green.shade800,
          icon: Icons.check_circle_outline,
          semanticLabel: '成功',
        );
      case AppToastType.error:
        return _ToastConfig(
          backgroundColor: AppTheme.destructiveColor.withValues(alpha: 0.1),
          borderColor: AppTheme.destructiveColor.withValues(alpha: 0.3),
          iconColor: AppTheme.destructiveColor,
          textColor: AppTheme.destructiveColor,
          icon: Icons.error_outline,
          semanticLabel: 'エラー',
        );
      case AppToastType.warning:
        return _ToastConfig(
          backgroundColor: AppTheme.warningColor.withValues(alpha: 0.1),
          borderColor: AppTheme.warningColor.withValues(alpha: 0.3),
          iconColor: AppTheme.warningColor,
          textColor: const Color(0xFF92400E), // より濃い警告色
          icon: Icons.warning_amber_outlined,
          semanticLabel: '警告',
        );
      case AppToastType.info:
        return _ToastConfig(
          backgroundColor: AppTheme.infoColor.withValues(alpha: 0.1),
          borderColor: AppTheme.infoColor.withValues(alpha: 0.3),
          iconColor: AppTheme.infoColor,
          textColor: const Color(0xFF1E40AF), // より濃い情報色
          icon: Icons.info_outline,
          semanticLabel: '情報',
        );
    }
  }

  // 静的メソッド：ScaffoldMessengerでの表示
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
    IconData? customIcon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppToast(
          message: message,
          type: type,
          onDismiss: onDismiss,
          customIcon: customIcon,
        ),
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // 便利な静的メソッド
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: AppToastType.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      context,
      message: message,
      type: AppToastType.error,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: AppToastType.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: AppToastType.info,
      duration: duration,
    );
  }
}

class _ToastConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final String semanticLabel;

  const _ToastConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
    required this.semanticLabel,
  });
}

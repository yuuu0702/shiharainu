import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/exceptions/app_exception.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final String? message;

  const ErrorView({super.key, this.error, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    String displayMessage = message ?? '予期しないエラーが発生しました';
    String? details;

    if (error is AppException) {
      displayMessage = (error as AppException).userMessage;
      // デバッグ用に元のエラーを表示しても良いが、ユーザーには隠蔽するのが基本
    } else if (error != null) {
      // 未知のエラーの場合は詳細を表示しないか、"Unknown Error"とする
      details = error.toString();
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.destructive),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              displayMessage,
              style: AppTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  details,
                  style: AppTheme.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppTheme.destructive,
                  ),
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacing24),
              AppButton.primary(text: '再読み込み', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}

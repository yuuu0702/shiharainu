import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// シンプルなページ全体のローディング表示ウィジェット
///
/// Scaffoldを含むページレベルのローディング状態を表示します。
/// AsyncValue.when()のloading:句で使用することを想定しています。
class AppLoadingState extends StatelessWidget {
  final String? message;
  final bool showAppBar;
  final String? title;

  const AppLoadingState({
    super.key,
    this.message,
    this.showAppBar = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar && title != null
          ? AppBar(title: Text(title!))
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            if (message != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              Text(
                message!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// エラー状態表示ウィジェット
///
/// ネットワークエラーやその他のエラーを表示します。
/// AsyncValue.when()のerror:句で使用することを想定しています。
class AppErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String? customMessage;
  final IconData? customIcon;
  final bool showAppBar;
  final String? title;

  const AppErrorState({
    super.key,
    required this.error,
    this.onRetry,
    this.customMessage,
    this.customIcon,
    this.showAppBar = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = _isNetworkError(error);

    return Scaffold(
      appBar: showAppBar && title != null
          ? AppBar(title: Text(title!))
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                customIcon ??
                    (isNetworkError ? Icons.wifi_off : Icons.error_outline),
                size: 64,
                color: AppTheme.mutedForegroundAccessible,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                customMessage ?? _getErrorMessage(error),
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                _getErrorDescription(error),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppTheme.spacing24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('再試行'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _isNetworkError(Object error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('internet') ||
        errorString.contains('timeout');
  }

  String _getErrorMessage(Object error) {
    if (_isNetworkError(error)) {
      return 'ネットワークエラー';
    }
    return 'エラーが発生しました';
  }

  String _getErrorDescription(Object error) {
    if (_isNetworkError(error)) {
      return 'インターネット接続を確認して、もう一度お試しください。';
    }
    return '予期しないエラーが発生しました。しばらくしてからもう一度お試しください。';
  }
}

/// インラインローディングインジケーター
///
/// ページ内の一部でローディング状態を表示する際に使用します。
class AppInlineLoading extends StatelessWidget {
  final String? message;
  final double size;

  const AppInlineLoading({
    super.key,
    this.message,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacing8),
            Text(
              message!,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.mutedForegroundAccessible,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/app_progress.dart';
import 'package:shiharainu/shared/widgets/app_skeleton_loader.dart';

/// 統一されたローディング状態管理ウィジェット
/// アプリ全体で一貫したローディングUXを提供し、
/// 様々なローディングパターンに対応します。
class AppLoadingState<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) dataBuilder;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final String? loadingMessage;
  final bool showSkeletonLoader;
  final Widget Function()? skeletonBuilder;
  final VoidCallback? onRetry;

  const AppLoadingState({
    super.key,
    required this.asyncValue,
    required this.dataBuilder,
    this.errorWidget,
    this.loadingWidget,
    this.loadingMessage,
    this.showSkeletonLoader = false,
    this.skeletonBuilder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: dataBuilder,
      loading: () => _buildLoadingWidget(context),
      error: (error, stackTrace) =>
          _buildErrorWidget(context, error, stackTrace),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    if (loadingWidget != null) {
      return loadingWidget!;
    }

    if (showSkeletonLoader && skeletonBuilder != null) {
      return skeletonBuilder!();
    }

    return Center(
      child: AppProgress.circular(
        size: AppProgressSize.large,
        label: loadingMessage ?? 'データを読み込み中...',
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return AppErrorState(error: error, onRetry: onRetry);
  }
}

/// Riverpod AsyncValue専用のローディング状態ウィジェット
class AsyncValue<T> {
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isLoading;

  const AsyncValue._({
    this.data,
    this.error,
    this.stackTrace,
    this.isLoading = false,
  });

  const AsyncValue.data(T data) : this._(data: data);
  const AsyncValue.loading() : this._(isLoading: true);
  const AsyncValue.error(Object error, StackTrace? stackTrace)
    : this._(error: error, stackTrace: stackTrace);

  R when<R>({
    required R Function(T data) data,
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    if (this.error != null) {
      return error(this.error!, stackTrace);
    }
    if (isLoading) {
      return loading();
    }
    return data(this.data as T);
  }
}

/// エラー状態表示ウィジェット
class AppErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String? customMessage;
  final IconData? customIcon;

  const AppErrorState({
    super.key,
    required this.error,
    this.onRetry,
    this.customMessage,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = _isNetworkError(error);

    return Center(
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

/// ページ全体用のローディング状態ウィジェット
class AppPageLoadingState<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) dataBuilder;
  final String title;
  final List<Widget>? actions;
  final String? loadingMessage;
  final VoidCallback? onRetry;

  const AppPageLoadingState({
    super.key,
    required this.asyncValue,
    required this.dataBuilder,
    required this.title,
    this.actions,
    this.loadingMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: asyncValue.data != null ? actions : null,
      ),
      body: AppLoadingState<T>(
        asyncValue: asyncValue,
        dataBuilder: dataBuilder,
        loadingMessage: loadingMessage,
        onRetry: onRetry,
      ),
    );
  }
}

/// ボタンローディング状態管理ウィジェット
class AppButtonLoadingState extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final String? loadingText;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButtonLoadingState({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.loadingText,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.primaryColor,
        foregroundColor: foregroundColor ?? Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(loadingText ?? '処理中...'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppTheme.spacing8),
                ],
                Text(text),
              ],
            ),
    );
  }
}

/// リストアイテム用のスケルトンローダー
class AppListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const AppListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          AppSkeletonLoader.card(height: itemHeight),
    );
  }
}

/// カードグリッド用のスケルトンローダー
class AppGridSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double aspectRatio;
  final EdgeInsetsGeometry padding;

  const AppGridSkeletonLoader({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.aspectRatio = 1.0,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => AppSkeletonLoader.card(),
    );
  }
}

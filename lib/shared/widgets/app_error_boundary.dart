import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class AppErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;
  final void Function(FlutterErrorDetails)? onError;

  const AppErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  // エラー表示ウィジェットをカスタマイズするための静的メソッド
  static void initialize() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return AppErrorWidget(errorDetails: errorDetails);
    };
  }

  // カスタムエラーウィジェットを作成する便利なメソッド
  static Widget createErrorWidget({
    required String title,
    required String message,
    VoidCallback? onRetry,
    IconData icon = Icons.error_outline,
    bool showDetails = false,
    FlutterErrorDetails? errorDetails,
  }) {
    return AppErrorWidget(
      title: title,
      message: message,
      onRetry: onRetry,
      icon: icon,
      showDetails: showDetails,
      errorDetails: errorDetails,
    );
  }
}

class AppErrorWidget extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool showDetails;
  final FlutterErrorDetails? errorDetails;

  const AppErrorWidget({
    super.key,
    this.title = 'エラーが発生しました',
    this.message = '予期しないエラーが発生しました。もう一度お試しください。',
    this.onRetry,
    this.icon = Icons.error_outline,
    this.showDetails = false,
    this.errorDetails,
  });

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();

  static Widget networkError({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'ネットワークエラー',
      message: 'インターネット接続を確認して、もう一度お試しください。',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  static Widget notFound({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'ページが見つかりません',
      message: 'お探しのページは存在しないか、移動した可能性があります。',
      icon: Icons.search_off,
      onRetry: onRetry,
    );
  }

  static Widget serverError({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'サーバーエラー',
      message: 'サーバーに接続できません。しばらくしてからもう一度お試しください。',
      icon: Icons.dns_outlined,
      onRetry: onRetry,
    );
  }

  static Widget permissionError({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'アクセス権限がありません',
      message: 'このコンテンツにアクセスする権限がありません。',
      icon: Icons.lock_outline,
      onRetry: onRetry,
    );
  }
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  bool _showDetailedError = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // エラーアイコン
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.destructiveColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: AppTheme.destructiveColor,
                  semanticLabel: 'エラーアイコン',
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // エラータイトル
              Text(
                widget.title,
                style: AppTheme.headlineMedium.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                semanticsLabel: 'エラー: ${widget.title}',
              ),
              const SizedBox(height: AppTheme.spacing12),

              // エラーメッセージ
              Text(
                widget.message,
                style: AppTheme.bodyMedium.copyWith(
                  color: isDarkMode
                      ? Colors.white70
                      : AppTheme.mutedForegroundAccessible,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacing32),

              // アクションボタン群
              Column(
                children: [
                  // 再試行ボタン
                  if (widget.onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      height: AppTheme.minimumTouchTarget,
                      child: ElevatedButton.icon(
                        onPressed: widget.onRetry,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('再試行'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.primaryForeground,
                        ),
                      ),
                    ),

                  if (widget.onRetry != null)
                    const SizedBox(height: AppTheme.spacing12),

                  // 詳細表示/非表示ボタン（デバッグモードでのみ表示）
                  if (widget.showDetails && widget.errorDetails != null)
                    SizedBox(
                      width: double.infinity,
                      height: AppTheme.minimumTouchTarget,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showDetailedError = !_showDetailedError;
                          });
                        },
                        icon: Icon(
                          _showDetailedError
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                        ),
                        label: Text(_showDetailedError ? '詳細を隠す' : '詳細を表示'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDarkMode
                                ? Colors.white30
                                : AppTheme.mutedColor,
                          ),
                        ),
                      ),
                    ),

                  // ホームに戻るボタン
                  const SizedBox(height: AppTheme.spacing12),
                  SizedBox(
                    width: double.infinity,
                    height: AppTheme.minimumTouchTarget,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/home', (route) => false);
                      },
                      child: const Text('ホームに戻る'),
                    ),
                  ),
                ],
              ),

              // 詳細エラー表示
              if (_showDetailedError && widget.errorDetails != null) ...[
                const SizedBox(height: AppTheme.spacing24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF2A2A2E)
                        : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: isDarkMode ? Colors.white12 : AppTheme.mutedColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'エラー詳細:',
                        style: AppTheme.labelMedium.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.errorDetails!.exception.toString(),
                          style: AppTheme.bodySmall.copyWith(
                            color: isDarkMode
                                ? Colors.white70
                                : AppTheme.mutedForeground,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      if (widget.errorDetails!.stack != null) ...[
                        const SizedBox(height: AppTheme.spacing12),
                        Text(
                          'スタックトレース:',
                          style: AppTheme.labelMedium.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Text(
                              widget.errorDetails!.stack.toString(),
                              style: AppTheme.bodySmall.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : AppTheme.mutedForeground,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 特定のエラータイプ用の便利なコンストラクタ

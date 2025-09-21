import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/utils/debug_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'メールアドレスとパスワードを入力してください';
      });
      return;
    }

    await _performLogin(email, password);
  }

  void _handleDebugLogin() async {
    await _performLogin(DebugUtils.testEmail, DebugUtils.testPassword);
  }

  Future<void> _performLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final authService = container.read(authServiceProvider);

      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アプリロゴ・タイトル
              Icon(Icons.payment, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: AppTheme.spacing24),
              Text(
                'Shiharainu',
                style: AppTheme.displayMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'イベント支払い管理アプリ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: AppTheme.spacing48),

              // ログインフォーム
              AppCard(
                child: Column(
                  children: [
                    AppInput(
                      label: 'メールアドレス',
                      placeholder: 'example@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    AppInput(
                      label: 'パスワード',
                      placeholder: 'パスワードを入力',
                      controller: _passwordController,
                      obscureText: true,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    ),

                    // エラーメッセージ表示
                    if (_errorMessage != null) ...[
                      const SizedBox(height: AppTheme.spacing16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing12),
                        decoration: BoxDecoration(
                          color: AppTheme.destructive.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.destructive.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 20,
                              color: AppTheme.destructive,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.destructive,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: AppTheme.spacing24),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.primary(
                        text: 'ログイン',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        size: AppButtonSize.large,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    AppButton.link(
                      text: 'パスワードを忘れた場合',
                      onPressed: () {
                        _showPasswordResetDialog();
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('アカウントをお持ちでない方は'),
                        const SizedBox(width: AppTheme.spacing4),
                        GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: Text(
                            'こちら',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // デバッグモード用テストユーザーログインボタン
              if (DebugUtils.isDebugMode) ...[
                const SizedBox(height: AppTheme.spacing32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.mutedColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.mutedForeground.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bug_report,
                            size: 16,
                            color: AppTheme.mutedForeground,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Text(
                            'デバッグモード',
                            style: AppTheme.labelMedium.copyWith(
                              color: AppTheme.mutedForeground,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton.outline(
                          text: 'テストユーザーでログイン',
                          onPressed: _isLoading ? null : _handleDebugLogin,
                          size: AppButtonSize.medium,
                          icon: const Icon(Icons.person, size: 16),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        '${DebugUtils.testEmail} でログインします',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.mutedForeground,
                        ),
                      ),
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

  void _showPasswordResetDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('パスワードリセット'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('パスワードリセット用のメールを送信します。'),
            const SizedBox(height: AppTheme.spacing16),
            AppInput(
              label: 'メールアドレス',
              placeholder: 'example@email.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          AppButton.primary(
            text: '送信',
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;

              // BuildContextを非同期処理前に取得
              final container = ProviderScope.containerOf(context);
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              try {
                final authService = container.read(authServiceProvider);
                await authService.sendPasswordResetEmail(email: email);

                if (mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('パスワードリセットメールを送信しました'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                      backgroundColor: AppTheme.destructive,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

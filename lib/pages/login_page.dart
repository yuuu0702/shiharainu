import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate login delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アプリロゴ・タイトル
              Icon(
                Icons.payment,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Shiharainu',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'イベント支払い管理アプリ',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 48),

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
                    const SizedBox(height: 16),
                    AppInput(
                      label: 'パスワード',
                      placeholder: 'パスワードを入力',
                      controller: _passwordController,
                      obscureText: true,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.primary(
                        text: 'ログイン',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        size: AppButtonSize.large,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton.link(
                      text: 'パスワードを忘れた場合',
                      onPressed: () {
                        // TODO: パスワードリセット機能
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // デバッグ用ログインボタン
              Text(
                'デバッグモード',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: '幹事でログイン',
                      onPressed: () => context.go('/dashboard'),
                      size: AppButtonSize.small,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.outline(
                      text: '参加者でログイン',
                      onPressed: () => context.go('/dashboard'),
                      size: AppButtonSize.small,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
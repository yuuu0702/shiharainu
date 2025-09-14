import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // バリデーション
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'すべての項目を入力してください';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'パスワードが一致しません';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'パスワードは6文字以上で入力してください';
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = '利用規約に同意してください';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final authService = container.read(authServiceProvider);

      await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        // アカウント作成成功後、ユーザー情報入力画面に遷移
        context.go('/user-profile-setup');
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
      appBar: AppBar(
        title: const Text('アカウント作成'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: AppButton.icon(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacing24),

              // ページタイトル
              Text('アカウントを作成', style: AppTheme.displayMedium),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Shiharainuでイベントの支払い管理を始めましょう',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // サインアップフォーム
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
                      placeholder: '6文字以上で入力',
                      controller: _passwordController,
                      obscureText: true,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    AppInput(
                      label: 'パスワード確認',
                      placeholder: 'もう一度パスワードを入力',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    ),

                    const SizedBox(height: AppTheme.spacing24),

                    // 利用規約同意
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          activeColor: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.bodySmall.copyWith(
                                color: Colors.black87,
                              ),
                              children: const [
                                TextSpan(text: ''),
                                TextSpan(
                                  text: '利用規約',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: 'および'),
                                TextSpan(
                                  text: 'プライバシーポリシー',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: 'に同意します'),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                        text: 'アカウント作成',
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                        size: AppButtonSize.large,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),

              // ログインへのリンク
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'すでにアカウントをお持ちですか？',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    AppButton.link(
                      text: 'ログイン',
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

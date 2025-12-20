// Governed by Skill: shiharainu-login-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/widgets/auth_input.dart';

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

    // Validation
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
    // Premium Gradient Background
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF6366F1), // Indigo 500
        Color(0xFF8B5CF6), // Violet 500
        Color(0xFFEC4899), // Pink 500 (Subtle hint)
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Layer
          Container(decoration: BoxDecoration(gradient: backgroundGradient)),

          // 2. Mesh/Noise Overlay
          Container(color: Colors.black.withValues(alpha: 0.1)),

          // 3. Content Layer
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing32,
                  vertical: AppTheme.spacing24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Create Account',
                      style: AppTheme.displayLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Shiharainuへようこそ',
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing40),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: AppTheme.spacing20,
                        ),
                        padding: const EdgeInsets.all(AppTheme.spacing12),
                        decoration: BoxDecoration(
                          color: AppTheme.destructive.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Inputs
                    AuthInput(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: AppTheme.spacing20),
                    AuthInput(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: AppTheme.spacing20),
                    AuthInput(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      icon: Icons.lock_outline,
                    ),

                    const SizedBox(height: AppTheme.spacing24),

                    // Terms Checkbox
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: Colors.white,
                            checkColor: AppTheme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '利用規約とプライバシーポリシーに同意します',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacing32),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          textStyle: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign Up'),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing24),

                    // Back Link
                    Center(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.7),
                        ),
                        child: const Text('Back to Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

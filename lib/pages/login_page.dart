// Governed by Skill: shiharainu-login-design
// Standards: Premium Minimal, Weverse Interactive Flow
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/utils/debug_utils.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/widgets/auth_input.dart';

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
  bool _showLoginForm = false; // State to toggle between Landing and Form views

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

  void _toggleForm(bool show) {
    setState(() {
      _showLoginForm = show;
      _errorMessage = null; // Clear error when switching views
    });
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Spacer
                          const SizedBox(height: AppTheme.spacing48),

                          // Header Section (Brand) - Always Visible
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacing20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.payment,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing24),
                              Text(
                                'Shiharainu',
                                style: AppTheme.displayLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                'Smart Event Payments',
                                style: AppTheme.bodyLarge.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppTheme.spacing48),

                          // Bottom Section (Animated Switcher)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.05),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                            child: _showLoginForm
                                ? _buildLoginForm()
                                : _buildLandingActions(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- View: Landing Actions (Initial State) ---
  Widget _buildLandingActions() {
    return Column(
      key: const ValueKey('landing'),
      children: [
        // Log In Button (Triggers Form)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _toggleForm(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              elevation: 0,
              shape: const StadiumBorder(),
              textStyle: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Log In'),
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Sign Up Button (Navigates to Sign Up Page)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => context.go('/signup'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              shape: const StadiumBorder(),
              textStyle: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ),

        const SizedBox(height: AppTheme.spacing48),

        // Debug Login (Only in Debug Mode)
        if (DebugUtils.isDebugMode) ...[
          GestureDetector(
            onTap: _isLoading ? null : _handleDebugLogin,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Text(
                'Debug Login',
                style: TextStyle(
                  color: Colors.white54,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // --- View: Login Form (Secondary State) ---
  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('form'),
      children: [
        // Error Message
        if (_errorMessage != null)
          Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacing20),
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.destructive.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
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

        const SizedBox(height: AppTheme.spacing40),

        // Actions
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Log In'),
          ),
        ),

        const SizedBox(height: AppTheme.spacing24),

        TextButton(
          onPressed: _showPasswordResetDialog,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withValues(alpha: 0.9),
          ),
          child: const Text('Forgot Password?'),
        ),

        const SizedBox(height: AppTheme.spacing8),

        // Back Button
        TextButton.icon(
          onPressed: () => _toggleForm(false),
          icon: const Icon(Icons.arrow_back, size: 16),
          label: const Text('Back'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withValues(alpha: 0.7),
          ),
        ),

        // Debug Login (Only in Form View)
        if (DebugUtils.isDebugMode) ...[
          const SizedBox(height: AppTheme.spacing20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bug_report, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isLoading ? null : _handleDebugLogin,
                child: const Text(
                  'Debug Login',
                  style: TextStyle(
                    color: Colors.white54,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: AppTheme.spacing32),
      ],
    );
  }

  void _showPasswordResetDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a reset link.'),
            const SizedBox(height: 16),
            AppInput(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton.primary(
            text: 'Send',
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;

              final container = ProviderScope.containerOf(context);
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              try {
                final authService = container.read(authServiceProvider);
                await authService.sendPasswordResetEmail(email: email);

                if (navigator.mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (scaffoldMessenger.mounted) {
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

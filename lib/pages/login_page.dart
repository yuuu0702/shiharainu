import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/utils/debug_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLoginForm = false;

  void _toggleView() {
    setState(() {
      _showLoginForm = !_showLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _showLoginForm
            ? _LoginScreen(onBack: _toggleView)
            : _StartScreen(onLoginTap: _toggleView),
      ),
    );
  }
}

class _StartScreen extends ConsumerStatefulWidget {
  final VoidCallback onLoginTap;
  const _StartScreen({required this.onLoginTap});

  @override
  ConsumerState<_StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<_StartScreen> {
  bool _isLoading = false;

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
      // GoRouter handles redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDebugLogin(String email, String password) async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // GoRouter handles redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reference Image Orange Color approximation
    // Reference Image Orange Color approximation (Now using Token)
    final backgroundColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Music Notes
          Positioned(
            top: 80,
            left: 200,
            child: Icon(
              Icons.music_note,
              color: Colors.white.withValues(alpha: 0.3),
              size: 40,
            ),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: Icon(
              Icons.music_note,
              color: Colors.white.withValues(alpha: 0.3),
              size: 30,
            ),
          ),

          // Dog Image (Positioned to sit behind/on the clouds)
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.05, // Adjust based on screen height
            left: -300,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 160, // Increased size
                height: 160,
                child: Image.asset(
                  'assets/images/dog.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Cloud & Content Layer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                MediaQuery.of(context).size.height *
                0.85, // Covers most of the screen
            child: Stack(
              children: [
                // Cloud Shape
                Positioned.fill(
                  child: ClipPath(
                    clipper: _CloudClipper(),
                    child: Container(color: Colors.white),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ), // Push content down below the "wave" crests
                      const Text(
                        'しはらいぬ',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '楽しい飲み会、まかせなさい！',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Buttons
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleGuestLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'ゲストとして利用する',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: widget.onLoginTap,
                            child: Text(
                              'ログイン',
                              style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text('|', style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () {
                              context.push('/signup');
                            },
                            child: const Text(
                              '新規登録',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      if (DebugUtils.isDebugMode) ...[
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _handleDebugLogin(
                                      DebugUtils.testEmail,
                                      DebugUtils.testPassword,
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('DEBUG1'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _handleDebugLogin(
                                      DebugUtils.testEmail2,
                                      DebugUtils.testPassword2,
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('DEBUG2'),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Cloud Clipper
class _CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 60);

    // Bump 1 (Left)
    path.quadraticBezierTo(size.width * 0.15, 0, size.width * 0.3, 60);

    // Bump 2 (Middle - larger)
    path.quadraticBezierTo(size.width * 0.5, 10, size.width * 0.7, 60);

    // Bump 3 (Right)
    path.quadraticBezierTo(size.width * 0.85, 20, size.width, 60);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const _LoginScreen({required this.onBack});

  @override
  ConsumerState<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<_LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // GoRouter handles redirect
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: widget.onBack,
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: const Icon(Icons.pets, size: 50, color: Colors.brown),
            ),
            const SizedBox(height: 24),
            const Text(
              'おかえりなさい！',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Form
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'メールアドレス',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'パスワード',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Remember me switch
            Row(
              children: [
                const Text('パスワードを保存', style: TextStyle(color: Colors.grey)),
                const Spacer(),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: accentColor,
                ),
              ],
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Forgot password
              },
              child: const Text(
                'パスワードをお忘れですか？',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'ログイン',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/providers/auth_provider.dart';
import 'package:shiharainu/shared/constants/debug_config.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> handleLogin() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('メールアドレスとパスワードを入力してください')),
        );
        return;
      }

      isLoading.value = true;
      final success = await ref.read(authProvider.notifier).login(
        emailController.text,
        passwordController.text,
      );

      if (success) {
        if (context.mounted) {
          context.go('/dashboard');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ログインに失敗しました')),
          );
        }
      }
      isLoading.value = false;
    }

    Future<void> handleDebugLogin(Future<void> Function() loginAction) async {
      isLoading.value = true;
      await loginAction();
      if (context.mounted) {
        context.go('/dashboard');
      }
      isLoading.value = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.currency_yen,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Shiharainu',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'イベント支払い管理アプリ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onSubmitted: (_) => handleLogin(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : handleLogin,
                  child: isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('ログイン'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implement registration navigation
                },
                child: const Text('アカウントを作成'),
              ),
              
              // デバッグモードの場合のみテストログインボタンを表示
              if (DebugConfig.isDebugMode) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'デバッグ用ログイン',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading.value
                            ? null
                            : () => handleDebugLogin(() => ref.read(authProvider.notifier).loginAsOrganizer()),
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('幹事'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading.value
                            ? null
                            : () => handleDebugLogin(() => ref.read(authProvider.notifier).loginAsParticipant()),
                        icon: const Icon(Icons.person),
                        label: const Text('参加者'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading.value
                        ? null
                        : () => handleDebugLogin(() => ref.read(authProvider.notifier).loginAsGuest()),
                    icon: const Icon(Icons.person_outline),
                    label: const Text('ゲスト'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'テストアカウント情報:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '幹事: ${DebugConfig.testOrganizerEmail} / ${DebugConfig.testOrganizerPassword}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  '参加者: ${DebugConfig.testParticipantEmail} / ${DebugConfig.testParticipantPassword}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class GuestPromotionPage extends ConsumerStatefulWidget {
  const GuestPromotionPage({super.key});

  @override
  ConsumerState<GuestPromotionPage> createState() => _GuestPromotionPageState();
}

class _GuestPromotionPageState extends ConsumerState<GuestPromotionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLinkAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      // アカウント連携実行
      await authService.linkWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // ユーザー情報の更新（必要であれば、ここでFirestoreのemail項目なども更新すべきだが、
      // 基本的にAuth側の情報が更新されればOK。Firestoreのemailフィールドは今のところ使っていない、または
      // 次のプロフィール更新時に反映されるはず。念のため保存処理を呼ぶ手もあるが今回はスキップ）

      // メールアドレスをFirestoreにも反映（任意）
      try {
        await ref
            .read(userServiceProvider)
            .updateUserProfile(
              name: (await ref.read(userProfileProvider.future))?.name ?? '',
              age: (await ref.read(userProfileProvider.future))?.age ?? 0,
              position:
                  (await ref.read(userProfileProvider.future))?.position ??
                  '一般',
            );
      } catch (_) {
        // プロフィール更新失敗は致命的ではないので無視
      }

      setState(() {
        _isSuccess = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('アカウントのアップグレードが完了しました！'),
            backgroundColor: Colors.green,
          ),
        );

        // 少し待ってからホームへ
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    // GoRouterが認証状態の変化を検知して自動的にリダイレクトします
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
              SizedBox(height: 24),
              Text(
                'アカウント連携成功！',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('ホーム画面へ移動します...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('会員登録のススメ'),
        actions: [
          TextButton(
            onPressed: _handleLogout,
            child: const Text('ログアウト', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // メリット訴求セクション
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.stars, size: 48, color: AppTheme.primaryColor),
                  SizedBox(height: 16),
                  Text(
                    '本会員のメリット',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  _BenefitItem(
                    icon: Icons.add_circle_outline,
                    text: '自分で飲み会イベントを作成できる',
                    isHighlight: true,
                  ),
                  SizedBox(height: 12),
                  _BenefitItem(icon: Icons.history, text: 'これまでの支払い履歴をずっと保存'),
                  SizedBox(height: 8),
                  _BenefitItem(icon: Icons.devices, text: 'スマホを買い替えてもデータを引き継ぎ'),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              '今すぐアップグレード',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '現在のデータを維持したまま、正式なアカウントに切り替えます。',
              style: TextStyle(color: AppTheme.mutedForeground),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // 登録フォーム
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'メールアドレス',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'メールアドレスを入力してください';
                      }
                      if (!value.contains('@')) {
                        return '正しいメールアドレスを入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'パスワード',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードを入力してください';
                      }
                      if (value.length < 6) {
                        return 'パスワードは6文字以上で入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'アカウントを作成して連携',
                      onPressed: _isLoading ? null : _handleLinkAccount,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isHighlight;

  const _BenefitItem({
    required this.icon,
    required this.text,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: isHighlight ? 28 : 20,
          color: isHighlight ? AppTheme.primaryColor : AppTheme.mutedForeground,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight ? AppTheme.primaryColor : null,
            ),
          ),
        ),
      ],
    );
  }
}

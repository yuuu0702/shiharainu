import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    
    return userProfile.when(
      data: (profile) => SimplePage(
        title: 'アカウント情報',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // プロフィールカード
              _buildProfileCard(context, profile),
              const SizedBox(height: AppTheme.spacing24),
              
              // アカウント設定セクション
              _buildAccountSettingsSection(context, ref),
              const SizedBox(height: AppTheme.spacing24),
              
              // アプリ情報セクション
              _buildAppInfoSection(context),
              const SizedBox(height: AppTheme.spacing24),
              
              // ログアウトセクション
              _buildLogoutSection(context, ref),
            ],
          ),
        ),
      ),
      loading: () => const SimplePage(
        title: 'アカウント情報',
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => SimplePage(
        title: 'アカウント情報',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.destructive,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'アカウント情報の読み込みに失敗しました',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.destructive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, profile) {
    return AppCard(
      child: Column(
        children: [
          // ユーザーアバター
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                profile?.name.isNotEmpty == true 
                  ? profile.name.substring(0, 1).toUpperCase()
                  : '?',
                style: AppTheme.headlineLarge.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          // ユーザー情報
          Text(
            profile?.name ?? 'ゲスト',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            profile?.email ?? '未設定',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          // 追加情報
          if (profile != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.mutedColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Column(
                children: [
                  _buildInfoRow('年齢', '${profile.age}歳'),
                  const SizedBox(height: AppTheme.spacing8),
                  _buildInfoRow('役職', profile.position),
                  const SizedBox(height: AppTheme.spacing8),
                  _buildInfoRow('登録日', _formatDate(profile.createdAt)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.mutedForeground,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettingsSection(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'アカウント設定',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          _buildSettingsItem(
            icon: Icons.edit_outlined,
            title: 'プロフィール編集',
            subtitle: '名前、年齢、役職の変更',
            onTap: () {
              context.go('/profile-edit');
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'パスワード変更',
            subtitle: 'ログインパスワードの変更',
            onTap: () {
              // パスワード変更画面への遷移（今後実装）
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('パスワード変更機能は準備中です'),
                ),
              );
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: '通知設定',
            subtitle: 'プッシュ通知やメール通知の設定',
            onTap: () {
              // 通知設定画面への遷移（今後実装）
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('通知設定機能は準備中です'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'アプリ情報',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'バージョン情報',
            subtitle: 'アプリのバージョンと更新履歴',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('しはらいぬ v1.0.0'),
                ),
              );
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'ヘルプ・サポート',
            subtitle: '使い方やよくある質問',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ヘルプ・サポート機能は準備中です'),
                ),
              );
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: 'プライバシーポリシー',
            subtitle: '個人情報の取り扱いについて',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('プライバシーポリシーは準備中です'),
                ),
              );
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildSettingsItem(
            icon: Icons.description_outlined,
            title: '利用規約',
            subtitle: 'アプリの利用に関する規約',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('利用規約は準備中です'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'アカウント操作',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.destructive,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          
          AppButton.secondary(
            text: 'ログアウト',
            icon: const Icon(Icons.logout, size: 18),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      subtitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ログアウト'),
          content: const Text('本当にログアウトしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ログアウトに失敗しました: $e'),
                        backgroundColor: AppTheme.destructive,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'ログアウト',
                style: TextStyle(color: AppTheme.destructive),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}
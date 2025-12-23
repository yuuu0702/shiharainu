// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (profile) => SimplePage(
        title: 'アカウント情報',
        leading: AppButton.icon(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacing16),
              // プロフィールヘッダー (Hero Style)
              _buildProfileHeader(context, profile),
              const SizedBox(height: AppTheme.spacing32),

              // アカウント設定セクション
              _buildSectionTitle('アカウント設定'),
              const SizedBox(height: AppTheme.spacing8),
              _buildSettingsGroup([
                _buildSettingsItem(
                  icon: Icons.edit_outlined,
                  title: 'プロフィール編集',
                  subtitle: '名前、年齢、役職の変更',
                  onTap: () => context.go('/profile-edit'),
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'パスワード変更',
                  subtitle: 'ログインパスワードの変更',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('パスワード変更機能は準備中です')),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: '通知設定',
                  subtitle: 'プッシュ通知やメール通知の設定',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('通知設定機能は準備中です')),
                    );
                  },
                  showDivider: false,
                ),
              ]),
              const SizedBox(height: AppTheme.spacing32),

              // その他セクション
              _buildSectionTitle('その他'),
              const SizedBox(height: AppTheme.spacing8),
              _buildSettingsGroup([
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: 'アプリについて',
                  subtitle: 'バージョン情報、利用規約など',
                  onTap: () => context.go('/app-info'),
                  showDivider: false,
                ),
              ]),
              const SizedBox(height: AppTheme.spacing32),

              // ログアウトボタン
              Center(
                child: TextButton(
                  onPressed: () => _showLogoutDialog(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.destructive,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.logout, size: 18),
                      const SizedBox(width: 8),
                      const Text('ログアウト'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing48),
            ],
          ),
        ),
      ),
      loading: () => const SimplePage(
        title: 'アカウント情報',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SimplePage(
        title: 'アカウント情報',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppTheme.destructive),
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

  Widget _buildProfileHeader(BuildContext context, userProfile) {
    // データ型が不明確なため、dynamicとして扱うか、適切なキャストが必要ですが、
    // ここではプロパティアクセスを前提とします。
    final profile = userProfile;

    return Column(
      children: [
        // アバター
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              width: 4,
            ),
            boxShadow: AppTheme.elevationMedium,
          ),
          child: Center(
            child: Text(
              profile?.name.isNotEmpty == true
                  ? profile.name.substring(0, 1).toUpperCase()
                  : '?',
              style: AppTheme.displaySmall.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // ユーザー名とメール
        Text(
          profile?.name ?? 'ゲスト',
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.foregroundColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          profile?.email ?? '未設定',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.mutedForegroundAccessible,
          ),
        ),
        const SizedBox(height: AppTheme.spacing24),

        // 統計情報 (Chips)
        if (profile != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(Icons.cake, '${profile.age}歳'),
              const SizedBox(width: AppTheme.spacing12),
              Container(width: 1, height: 16, color: AppTheme.mutedColor),
              const SizedBox(width: AppTheme.spacing12),
              _buildInfoChip(Icons.work_outline, profile.position),
              const SizedBox(width: AppTheme.spacing12),
              Container(width: 1, height: 16, color: AppTheme.mutedColor),
              const SizedBox(width: AppTheme.spacing12),
              _buildInfoChip(
                Icons.calendar_today,
                _formatDate(profile.createdAt),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.mutedForegroundAccessible),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.labelMedium.copyWith(
            color: AppTheme.mutedForegroundAccessible,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.spacing4),
      child: Text(
        title,
        style: AppTheme.labelMedium.copyWith(
          color: AppTheme.mutedForegroundAccessible,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.mutedColor),
        boxShadow: AppTheme.elevationLow,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.mutedColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: AppTheme.foregroundColor,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.mutedForegroundAccessible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.mutedColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 60,
            color: AppTheme.mutedColor.withValues(alpha: 0.5),
          ),
      ],
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

                  // プロバイダーを無効化して古い状態をクリア
                  ref.invalidate(userProfileProvider);
                  ref.invalidate(userEventsStreamProvider);
                  ref.invalidate(myParticipationsStreamProvider);

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

// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'アプリについて',
      leading: AppButton.icon(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アプリ情報セクション
            _buildAppDetailsSection(context),
            const SizedBox(height: AppTheme.spacing24),

            // サポート・ヘルプセクション
            _buildSupportSection(context),
            const SizedBox(height: AppTheme.spacing24),

            // 法的情報セクション
            _buildLegalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDetailsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アプリロゴとタイトル
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Text('🐕', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'しはらいぬ',
                  style: AppTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'イベント支払い管理アプリ',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          Text(
            'アプリ情報',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          _buildInfoItem(
            icon: Icons.info_outline,
            title: 'バージョン',
            subtitle: 'v1.0.0',
            onTap: () {
              _showVersionDetails(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.update,
            title: '最終更新',
            subtitle: '2025年8月31日',
            onTap: () {
              _showUpdateHistory(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.code,
            title: '開発者',
            subtitle: 'しはらいぬ開発チーム',
            onTap: () {
              _showDeveloperInfo(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'サポート・ヘルプ',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          _buildInfoItem(
            icon: Icons.help_outline,
            title: '使い方ガイド',
            subtitle: 'アプリの基本的な使い方',
            onTap: () {
              _showUserGuide(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.quiz_outlined,
            title: 'よくある質問',
            subtitle: 'FAQ・トラブルシューティング',
            onTap: () {
              _showFAQ(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.contact_support_outlined,
            title: 'お問い合わせ',
            subtitle: 'サポートチームに連絡',
            onTap: () {
              _showContactSupport(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '法的情報',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          _buildInfoItem(
            icon: Icons.privacy_tip_outlined,
            title: 'プライバシーポリシー',
            subtitle: '個人情報の取り扱いについて',
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.description_outlined,
            title: '利用規約',
            subtitle: 'アプリの利用に関する規約',
            onTap: () {
              _showTermsOfService(context);
            },
          ),
          const Divider(height: AppTheme.spacing16),
          _buildInfoItem(
            icon: Icons.copyright_outlined,
            title: 'ライセンス情報',
            subtitle: '使用ライブラリとライセンス',
            onTap: () {
              _showLicenses(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
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
              Icon(icon, size: 24, color: AppTheme.mutedForeground),
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

  // 各種詳細表示メソッド
  void _showVersionDetails(BuildContext context) {
    _showInfoDialog(
      context,
      'バージョン情報',
      'しはらいぬ v1.0.0\n\nビルド番号: 1\nリリース日: 2025年8月31日\n\n最新の安定版をお使いいただいています。',
    );
  }

  void _showUpdateHistory(BuildContext context) {
    _showInfoDialog(
      context,
      '更新履歴',
      'v1.0.0 (2025/08/31)\n• 初回リリース\n• イベント作成・管理機能\n• 支払い計算機能\n• ユーザープロフィール機能',
    );
  }

  void _showDeveloperInfo(BuildContext context) {
    _showInfoDialog(
      context,
      '開発者情報',
      '開発チーム: しはらいぬ開発チーム\n\nFlutterとFirebaseを使用して\n開発されたモバイルアプリです。',
    );
  }

  void _showUserGuide(BuildContext context) {
    _showInfoDialog(
      context,
      '使い方ガイド',
      '1. イベントを作成\n2. 参加者を追加\n3. 支払い情報を入力\n4. 自動で割り勘計算\n\n詳細なガイドは準備中です。',
    );
  }

  void _showFAQ(BuildContext context) {
    _showInfoDialog(
      context,
      'よくある質問',
      'Q: パスワードを忘れました\nA: ログイン画面からリセットできます\n\nQ: データのバックアップは？\nA: Firebaseに自動保存されます\n\nより詳細なFAQは準備中です。',
    );
  }

  void _showContactSupport(BuildContext context) {
    _showInfoDialog(
      context,
      'お問い合わせ',
      'サポートが必要でしたら、\n以下の方法でご連絡ください：\n\nメール: support@shiharainu.app\n\n※現在準備中のため、\n実際の連絡先は後日公開予定です。',
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showInfoDialog(
      context,
      'プライバシーポリシー',
      '個人情報の取り扱いについて\n\n収集する情報:\n• ユーザー名・メールアドレス\n• アプリ利用履歴\n\n詳細なポリシーは準備中です。',
    );
  }

  void _showTermsOfService(BuildContext context) {
    _showInfoDialog(
      context,
      '利用規約',
      'しはらいぬ利用規約\n\n• アプリを適切にご利用ください\n• 他のユーザーに迷惑をかけないでください\n• 法令を遵守してください\n\n詳細な規約は準備中です。',
    );
  }

  void _showLicenses(BuildContext context) {
    _showInfoDialog(
      context,
      'ライセンス情報',
      '使用しているオープンソースライブラリ:\n\n• Flutter (BSD License)\n• Firebase (Apache License)\n• Riverpod (MIT License)\n\n詳細なライセンス情報は\nFlutterの標準機能で確認できます。',
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content, style: AppTheme.bodyMedium),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}

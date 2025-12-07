import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

/// ホームページのクイックアクションセクション
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'よく使う機能',
          style: AppTheme.headlineSmall.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.add_circle_outline,
                title: 'イベント作成',
                subtitle: '新しいイベントを企画',
                onTap: () => context.go('/events/create'),
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.event_outlined,
                title: 'イベント一覧',
                subtitle: '参加中のイベント',
                onTap: () => context.go('/events'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        // 参加コード入力ボタン
        AppCard(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const JoinEventDialog(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing12,
              horizontal: AppTheme.spacing16,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    Icons.vpn_key_outlined,
                    color: AppTheme.successColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '参加コードで参加',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '招待コードを入力してイベントに参加',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.mutedForegroundAccessible,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.mutedForegroundAccessible,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            subtitle,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.mutedForegroundAccessible,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

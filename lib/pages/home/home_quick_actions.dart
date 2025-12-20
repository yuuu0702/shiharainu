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
                icon: Icons.add,
                title: 'イベント作成',
                subtitle: '新しい企画',
                color: AppTheme.primaryColor,
                onTap: () => context.go('/events/create'),
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.list_alt,
                title: 'イベント一覧',
                subtitle: '参加中の企画',
                color: const Color(0xFF6366F1), // Indigo
                onTap: () => context.go('/events'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        // 参加コード入力ボタン
        _buildJoinButton(context),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppTheme.spacing12),
              Text(
                title,
                style: AppTheme.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.mutedForegroundAccessible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const JoinEventDialog(),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.mutedColor),
            boxShadow: AppTheme.elevationLow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.vpn_key,
                  color: AppTheme.successColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '参加コードを入力',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '招待されたイベントに参加する',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.mutedForegroundAccessible,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppTheme.mutedForegroundLegacy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

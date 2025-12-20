import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// ホームページの活動サマリーセクション
class HomeActivitySummary extends StatelessWidget {
  const HomeActivitySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '今月の活動',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.more_horiz, color: AppTheme.mutedForegroundLegacy),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),

        Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                context,
                icon: Icons.event_available,
                label: '参加イベント',
                value: '3',
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildSummaryItem(
                context,
                icon: Icons.check_circle,
                label: '支払い完了',
                value: '2',
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildSummaryItem(
                context,
                icon: Icons.group_add,
                label: '新しい友人',
                value: '5',
                color: AppTheme.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.mutedColor),
        boxShadow: AppTheme.elevationLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            value,
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.foregroundColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            label,
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.mutedForegroundAccessible,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

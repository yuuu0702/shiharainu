import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

/// ホームページの活動サマリーセクション
class HomeActivitySummary extends StatelessWidget {
  const HomeActivitySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今月の活動',
            style: AppTheme.headlineSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.spacing16),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.event_outlined,
                  label: '参加イベント',
                  value: '3',
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.payments_outlined,
                  label: '支払い完了',
                  value: '2',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.group_outlined,
                  label: '新しい友人',
                  value: '5',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.mutedForegroundAccessible,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

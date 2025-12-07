import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class DashboardFeatureCards extends StatelessWidget {
  final bool isOrganizer;

  const DashboardFeatureCards({super.key, required this.isOrganizer});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      spacing: 16,
      children: _buildFeatureCards(context),
    );
  }

  List<Widget> _buildFeatureCards(BuildContext context) {
    if (isOrganizer) {
      return [
        _buildFeatureCard(
          context,
          'イベント作成',
          Icons.add_circle_outline,
          AppTheme.primaryColor,
          '新しいイベントを作成',
          () => context.go('/event-creation'),
        ),
        _buildFeatureCard(
          context,
          '支払い管理',
          Icons.payment_outlined,
          AppTheme.successColor,
          '支払い状況を確認',
          () => context.go('/payment-management'),
        ),
        _buildFeatureCard(
          context,
          'イベント管理',
          Icons.event_outlined,
          const Color(0xFF8B5CF6),
          'イベント一覧を確認',
          () => context.go('/events'),
        ),
      ];
    } else {
      return [
        _buildFeatureCard(
          context,
          '参加イベント',
          Icons.event_outlined,
          AppTheme.primaryColor,
          'イベント一覧を確認',
          () => context.go('/events'),
        ),
        _buildFeatureCard(
          context,
          '支払い管理',
          Icons.payment_outlined,
          AppTheme.successColor,
          '支払い状況を確認',
          () => context.go('/payment-management'),
        ),
      ];
    }
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return AppCard.interactive(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

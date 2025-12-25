import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/event_detail/event_detail_badges.dart';

/// イベント詳細ページのヘッダーセクション
class EventDetailHeader extends StatelessWidget {
  final EventModel event;

  const EventDetailHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(event.title, style: AppTheme.headlineLarge)),
              EventDetailBadges.buildStatusBadge(event.status),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(event.description, style: AppTheme.bodyLarge),
          const SizedBox(height: AppTheme.spacing16),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            EventDetailUtils.formatFullDate(event.date),
          ),
          const SizedBox(height: AppTheme.spacing8),
          _buildInfoItem(
            Icons.payments_outlined,
            '総額: ¥${event.totalAmount.toStringAsFixed(0)}',
          ),
          const SizedBox(height: AppTheme.spacing8),
          _buildInfoItem(
            Icons.calculate_outlined,
            event.paymentType == PaymentType.equal ? '均等割り' : '比例配分',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.mutedForeground),
        const SizedBox(width: AppTheme.spacing8),
        Text(
          text,
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.mutedForeground),
        ),
      ],
    );
  }
}

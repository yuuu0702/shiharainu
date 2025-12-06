import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/event_detail/event_detail_badges.dart';

/// イベント詳細ページの情報セクション
class EventDetailInfoSection extends StatelessWidget {
  final EventModel event;
  final List<ParticipantModel> participants;

  const EventDetailInfoSection({
    super.key,
    required this.event,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    final organizerNames = participants
        .where((p) => p.role == ParticipantRole.organizer)
        .map((p) => p.displayName)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('イベント情報', style: AppTheme.headlineMedium),
        const SizedBox(height: AppTheme.spacing16),
        AppCard(
          child: Column(
            children: [
              _buildInfoRow('参加人数', '${participants.length}人'),
              const Divider(),
              _buildInfoRow('総額', '¥${event.totalAmount.toStringAsFixed(0)}'),
              const Divider(),
              _buildInfoRow(
                '主催者',
                organizerNames.isNotEmpty ? organizerNames : '未設定',
              ),
              const Divider(),
              _buildInfoRow(
                '作成日',
                EventDetailUtils.formatFullDate(event.createdAt),
              ),
              const Divider(),
              _buildInfoRow('招待コード', event.inviteCode ?? '未生成'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

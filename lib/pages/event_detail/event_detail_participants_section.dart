import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/event_detail/event_detail_badges.dart';

/// イベント詳細ページの参加者セクション
class EventDetailParticipantsSection extends StatelessWidget {
  final List<ParticipantModel> participants;

  const EventDetailParticipantsSection({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    final paidCount = participants
        .where((p) => p.paymentStatus == PaymentStatus.paid)
        .length;
    final unpaidCount = participants.length - paidCount;

    // 主催者を先頭に、その後は参加者を表示
    final organizers = participants
        .where((p) => p.role == ParticipantRole.organizer)
        .toList();
    final regularParticipants = participants
        .where((p) => p.role == ParticipantRole.participant)
        .toList();
    final sortedParticipants = [...organizers, ...regularParticipants];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('参加者', style: AppTheme.headlineMedium),
            const Spacer(),
            AppBadge(text: '支払済 $paidCount', variant: AppBadgeVariant.default_),
            const SizedBox(width: AppTheme.spacing8),
            AppBadge(
              text: '未払 $unpaidCount',
              variant: AppBadgeVariant.destructive,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        AppCard(
          child: Column(
            children: sortedParticipants.asMap().entries.map((entry) {
              final index = entry.key;
              final participant = entry.value;
              final isOrganizer = participant.role == ParticipantRole.organizer;

              return Column(
                children: [
                  AppProfileCard.standard(
                    name: participant.displayName,
                    subtitle: isOrganizer
                        ? '主催者 - ${EventDetailBadges.getPaymentStatusText(participant.paymentStatus)}'
                        : EventDetailBadges.getPaymentStatusText(
                            participant.paymentStatus,
                          ),
                    initials: EventDetailUtils.getInitials(
                      participant.displayName,
                    ),
                    trailing: isOrganizer
                        ? const AppBadge(
                            text: '主催者',
                            variant: AppBadgeVariant.default_,
                          )
                        : EventDetailBadges.buildPaymentStatusBadge(
                            participant.paymentStatus,
                          ),
                  ),
                  if (index < sortedParticipants.length - 1) const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

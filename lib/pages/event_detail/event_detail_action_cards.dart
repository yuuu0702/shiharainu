import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/widgets/invite_link_dialog.dart';

/// イベント詳細ページのアクションカードセクション
class EventDetailActionCards extends StatelessWidget {
  final String eventId;
  final EventModel event;
  final ParticipantRole role;

  const EventDetailActionCards({
    super.key,
    required this.eventId,
    required this.event,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      spacing: AppTheme.spacing16,
      children: role == ParticipantRole.organizer
          ? _buildOrganizerActions(context)
          : _buildParticipantActions(context),
    );
  }

  List<Widget> _buildOrganizerActions(BuildContext context) {
    return [
      _buildActionCard(
        context,
        '支払い管理',
        Icons.payment_outlined,
        AppTheme.successColor,
        '支払い状況を確認',
        () => context.go('/events/$eventId/payments'),
      ),
      _buildActionCard(
        context,
        '参加者管理',
        Icons.people_outlined,
        AppTheme.primaryColor,
        '参加者を管理',
        () => context.go('/events/$eventId/participants'),
      ),
      _buildActionCard(
        context,
        '招待リンク',
        Icons.share_outlined,
        const Color(0xFF8B5CF6),
        'リンクをシェア',
        () {
          showDialog(
            context: context,
            builder: (context) => InviteLinkDialog(
              eventId: eventId,
              eventTitle: event.title,
            ),
          );
        },
      ),
      _buildActionCard(
        context,
        'イベント編集',
        Icons.edit_outlined,
        AppTheme.warningColor,
        'イベント情報編集',
        () => context.go('/events/$eventId/settings'),
      ),
    ];
  }

  List<Widget> _buildParticipantActions(BuildContext context) {
    return [
      _buildActionCard(
        context,
        '支払い確認',
        Icons.payment_outlined,
        AppTheme.successColor,
        '自分の支払い状況',
        () => context.go('/events/$eventId/payments'),
      ),
      _buildActionCard(
        context,
        '参加者一覧',
        Icons.people_outlined,
        AppTheme.primaryColor,
        '参加者を確認',
        () => context.go('/events/$eventId/participants'),
      ),
    ];
  }

  Widget _buildActionCard(
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
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            description,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.mutedForeground),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

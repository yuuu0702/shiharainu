// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/pages/event_detail/event_detail_header.dart';
import 'package:shiharainu/pages/event_detail/event_detail_action_cards.dart';
import 'package:shiharainu/pages/event_detail/event_detail_info_section.dart';
import 'package:shiharainu/pages/event_detail/event_detail_participants_section.dart';
import 'package:shiharainu/pages/event_detail/after_party_section.dart';

/// イベント詳細ページ
///
/// イベントの詳細情報、参加者一覧、アクション、二次会などを表示します。
class EventDetailPage extends ConsumerWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventStreamProvider(eventId));
    final participantsAsync = ref.watch(
      eventParticipantsStreamProvider(eventId),
    );
    final isOrganizerAsync = ref.watch(isEventOrganizerProvider(eventId));
    final currentParticipantAsync = ref.watch(
      currentUserParticipantProvider(eventId),
    );

    return eventAsync.when(
      data: (event) {
        return participantsAsync.when(
          data: (participants) {
            return isOrganizerAsync.when(
              data: (isOrganizer) {
                return currentParticipantAsync.when(
                  data: (currentParticipant) {
                    return _buildContent(
                      context,
                      event,
                      participants,
                      isOrganizer,
                      currentParticipant,
                    );
                  },
                  loading: () => const AppLoadingState(message: 'データを読み込み中...'),
                  error: (error, stack) => AppErrorState(error: error),
                );
              },
              loading: () => const AppLoadingState(message: 'データを読み込み中...'),
              error: (error, stack) => AppErrorState(error: error),
            );
          },
          loading: () => const AppLoadingState(message: 'データを読み込み中...'),
          error: (error, stack) => AppErrorState(error: error),
        );
      },
      loading: () => const AppLoadingState(message: 'データを読み込み中...'),
      error: (error, stack) => AppErrorState(error: error),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EventModel event,
    List<ParticipantModel> participants,
    bool isOrganizer,
    ParticipantModel? currentParticipant,
  ) {
    final role = isOrganizer
        ? ParticipantRole.organizer
        : ParticipantRole.participant;

    return SimplePage(
      title: event.title,
      actions: isOrganizer
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AppButton.outline(
                  text: '設定',
                  icon: const Icon(Icons.settings_outlined, size: 18),
                  onPressed: () => context.go('/events/$eventId/settings'),
                  size: AppButtonSize.small,
                ),
              ),
            ]
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // イベントヘッダー
            EventDetailHeader(event: event),
            const SizedBox(height: AppTheme.spacing24),

            // アクションカード
            EventDetailActionCards(eventId: eventId, event: event, role: role),
            const SizedBox(height: AppTheme.spacing32),

            // イベント情報
            EventDetailInfoSection(event: event, participants: participants),
            const SizedBox(height: AppTheme.spacing32),

            // 二次会セクション（主催者のみ）
            if (isOrganizer) ...[
              AfterPartySection(eventId: eventId, eventTitle: event.title),
              const SizedBox(height: AppTheme.spacing32),
            ],

            // 参加者セクション
            EventDetailParticipantsSection(participants: participants),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/widgets/invite_link_dialog.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/providers/after_party_providers.dart';

class EventDetailPage extends ConsumerWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventStreamProvider(eventId));
    final participantsAsync = ref.watch(eventParticipantsStreamProvider(eventId));
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
                  loading: () => _buildLoading(),
                  error: (error, stack) => _buildError(error),
                );
              },
              loading: () => _buildLoading(),
              error: (error, stack) => _buildError(error),
            );
          },
          loading: () => _buildLoading(),
          error: (error, stack) => _buildError(error),
        );
      },
      loading: () => _buildLoading(),
      error: (error, stack) => _buildError(error),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildError(Object error) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.destructive),
            const SizedBox(height: AppTheme.spacing16),
            Text('データの取得に失敗しました', style: AppTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              error.toString(),
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: isOrganizer
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton.outline(
                    text: '設定',
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    onPressed: () => context.go('/events/$eventId/settings'),
                  ),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventHeader(event),
            const SizedBox(height: AppTheme.spacing24),
            _buildActionCards(context, role, event),
            const SizedBox(height: AppTheme.spacing32),
            _buildEventInfo(event, participants),
            const SizedBox(height: AppTheme.spacing32),
            if (isOrganizer) ...[
              _AfterPartySection(
                eventId: eventId,
                eventTitle: event.title,
              ),
              const SizedBox(height: AppTheme.spacing32),
            ],
            _buildParticipantsSection(participants),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader(EventModel event) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(event.title, style: AppTheme.headlineLarge)),
              _buildStatusBadge(event.status),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(event.description, style: AppTheme.bodyLarge),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                _formatFullDate(event.date),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                '総額: ¥${event.totalAmount.toStringAsFixed(0)}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                event.paymentType == PaymentType.equal ? '均等割り' : '比例配分',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(
    BuildContext context,
    ParticipantRole role,
    EventModel event,
  ) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      spacing: AppTheme.spacing16,
      children: role == ParticipantRole.organizer
          ? _buildOrganizerActions(context, event)
          : _buildParticipantActions(context),
    );
  }

  List<Widget> _buildOrganizerActions(
    BuildContext context,
    EventModel event,
  ) {
    return [
      _buildActionCard(
        '支払い管理',
        Icons.payment_outlined,
        AppTheme.successColor,
        '支払い状況を確認',
        () => context.go('/events/$eventId/payments'),
      ),
      _buildActionCard(
        '参加者管理',
        Icons.people_outlined,
        AppTheme.primaryColor,
        '参加者を管理',
        () {
          // TODO(Issue #43): 参加者管理機能の実装
          // 参加者一覧・追加・削除機能を持つ画面への遷移を実装予定
        },
      ),
      _buildActionCard(
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
        '支払い確認',
        Icons.payment_outlined,
        AppTheme.successColor,
        '自分の支払い状況',
        () => context.go('/events/$eventId/payments'),
      ),
      _buildActionCard(
        'イベント詳細',
        Icons.info_outlined,
        AppTheme.primaryColor,
        '詳細情報を確認',
        () {
          // TODO: イベント詳細情報画面の実装
          // イベントの詳細情報を表示する画面への遷移を実装予定
        },
      ),
    ];
  }

  Widget _buildActionCard(
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

  Widget _buildEventInfo(
    EventModel event,
    List<ParticipantModel> participants,
  ) {
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
              _buildInfoRow('作成日', _formatFullDate(event.createdAt)),
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

  Widget _buildParticipantsSection(List<ParticipantModel> participants) {
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
                        ? '主催者 - ${_getPaymentStatusText(participant.paymentStatus)}'
                        : _getPaymentStatusText(participant.paymentStatus),
                    initials: _getInitials(participant.displayName),
                    trailing: isOrganizer
                        ? AppBadge(
                            text: '主催者',
                            variant: AppBadgeVariant.default_,
                          )
                        : _buildPaymentStatusBadge(participant.paymentStatus),
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

  Widget _buildStatusBadge(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return AppBadge(text: '企画中', variant: AppBadgeVariant.secondary);
      case EventStatus.active:
        return AppBadge(text: '募集中', variant: AppBadgeVariant.default_);
      case EventStatus.completed:
        return AppBadge(text: '完了', variant: AppBadgeVariant.secondary);
    }
  }

  Widget _buildPaymentStatusBadge(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return AppBadge(text: '支払済', variant: AppBadgeVariant.default_);
      case PaymentStatus.pending:
        return AppBadge(text: '確認中', variant: AppBadgeVariant.warning);
      case PaymentStatus.unpaid:
        return AppBadge(text: '未払', variant: AppBadgeVariant.destructive);
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return '支払い完了';
      case PaymentStatus.pending:
        return '支払い確認中';
      case PaymentStatus.unpaid:
        return '支払い待ち';
    }
  }

  String _getInitials(String name) {
    if (name.length <= 2) return name;
    return name.substring(0, 2);
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}

/// 二次会セクション
class _AfterPartySection extends HookConsumerWidget {
  final String eventId;
  final String eventTitle;

  const _AfterPartySection({
    required this.eventId,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final afterPartiesAsync = ref.watch(afterPartiesProvider(eventId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('二次会', style: AppTheme.headlineMedium),
            const Spacer(),
            AppButton.outline(
              text: '作成',
              icon: const Icon(Icons.add, size: 16),
              size: AppButtonSize.small,
              onPressed: () => _showCreateAfterPartyDialog(context, ref),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        afterPartiesAsync.when(
          data: (afterParties) {
            if (afterParties.isEmpty) {
              return AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.celebration_outlined,
                          size: 48,
                          color: AppTheme.mutedForeground,
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Text(
                          '二次会はまだ作成されていません',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: afterParties.map((afterParty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: AppCard.interactive(
                    onTap: () => context.go('/events/${afterParty.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacing8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                            ),
                            child: Icon(
                              Icons.celebration,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  afterParty.title,
                                  style: AppTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing4),
                                Text(
                                  '¥${afterParty.totalAmount.toStringAsFixed(0)}',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppTheme.mutedForeground,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Text(
                'エラー: $error',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.destructive,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateAfterPartyDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: '$eventTitleの二次会');
    final amountController = TextEditingController();
    PaymentType selectedPaymentType = PaymentType.equal;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('二次会を作成'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppInput(
                  label: '二次会名',
                  controller: titleController,
                  isRequired: true,
                ),
                const SizedBox(height: AppTheme.spacing16),
                AppInput(
                  label: '総支払い金額',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.currency_yen, size: 20),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '支払い方法',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Row(
                      children: [
                        Expanded(
                          child: selectedPaymentType == PaymentType.equal
                              ? AppButton.primary(
                                  text: '均等割り',
                                  icon: const Icon(Icons.balance, size: 16),
                                  size: AppButtonSize.medium,
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentType = PaymentType.equal;
                                    });
                                  },
                                )
                              : AppButton.outline(
                                  text: '均等割り',
                                  icon: const Icon(Icons.balance, size: 16),
                                  size: AppButtonSize.medium,
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentType = PaymentType.equal;
                                    });
                                  },
                                ),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: selectedPaymentType == PaymentType.proportional
                              ? AppButton.primary(
                                  text: '比例割り',
                                  icon: const Icon(Icons.stairs, size: 16),
                                  size: AppButtonSize.medium,
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentType =
                                          PaymentType.proportional;
                                    });
                                  },
                                )
                              : AppButton.outline(
                                  text: '比例割り',
                                  icon: const Icon(Icons.stairs, size: 16),
                                  size: AppButtonSize.medium,
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentType =
                                          PaymentType.proportional;
                                    });
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            AppButton.primary(
              text: '作成',
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    amountController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('必須項目を入力してください'),
                      backgroundColor: AppTheme.destructive,
                    ),
                  );
                  return;
                }

                try {
                  final afterPartyService =
                      ref.read(afterPartyServiceProvider);
                  final afterPartyId = await afterPartyService.createAfterParty(
                    parentEventId: eventId,
                    title: titleController.text.trim(),
                    totalAmount: double.parse(amountController.text.trim()),
                    paymentType: selectedPaymentType,
                  );

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }

                  // Providerを更新
                  ref.invalidate(afterPartiesProvider(eventId));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('二次会を作成しました'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                    // 作成した二次会に遷移
                    context.go('/events/$afterPartyId');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('作成に失敗しました: $e'),
                        backgroundColor: AppTheme.destructive,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

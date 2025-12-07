import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/constants/app_breakpoints.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/services/payment_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class EventPaymentManagementPage extends ConsumerStatefulWidget {
  final String eventId;

  const EventPaymentManagementPage({super.key, required this.eventId});

  @override
  ConsumerState<EventPaymentManagementPage> createState() =>
      _EventPaymentManagementPageState();
}

class _EventPaymentManagementPageState
    extends ConsumerState<EventPaymentManagementPage> {
  int _selectedFilterIndex = 0; // 0: 全員, 1: 支払済, 2: 未払

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventStreamProvider(widget.eventId));
    final participantsAsync =
        ref.watch(eventParticipantsStreamProvider(widget.eventId));
    final isOrganizerAsync =
        ref.watch(isEventOrganizerProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い管理'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: eventAsync.when(
        data: (event) {
          return participantsAsync.when(
            data: (participants) {
              return isOrganizerAsync.when(
                data: (isOrganizer) {
                  return _buildContent(
                    context,
                    event,
                    participants,
                    isOrganizer,
                  );
                },
                loading: () => const AppInlineLoading(message: 'データを読み込み中...'),
                error: (error, stack) => AppErrorState(error: error),
              );
            },
            loading: () => const AppInlineLoading(message: 'データを読み込み中...'),
            error: (error, stack) => AppErrorState(error: error),
          );
        },
        loading: () => const AppInlineLoading(message: 'データを読み込み中...'),
        error: (error, stack) => AppErrorState(error: error),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EventModel event,
    List<ParticipantModel> participants,
    bool isOrganizer,
  ) {
    // フィルタリング
    final filteredParticipants = _filterParticipants(participants);

    // 支払いサマリーを計算
    final paidCount =
        participants.where((p) => p.paymentStatus == PaymentStatus.paid).length;
    final unpaidCount = participants.length - paidCount;
    final paidAmount = participants
        .where((p) => p.paymentStatus == PaymentStatus.paid)
        .fold<double>(0.0, (sum, p) => sum + p.amountToPay);
    final remainingAmount = event.totalAmount - paidAmount;

    return Column(
      children: [
        // 支払いサマリーカード
        _buildPaymentSummaryCard(
          totalParticipants: participants.length,
          paidCount: paidCount,
          unpaidCount: unpaidCount,
          totalAmount: event.totalAmount,
          paidAmount: paidAmount,
          remainingAmount: remainingAmount,
        ),

        // フィルタータブ
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          child: AppSegmentedControl<int>(
            options: const [
              AppSegmentedControlOption(
                value: 0,
                label: '全員',
                icon: Icons.people,
              ),
              AppSegmentedControlOption(
                value: 1,
                label: '支払済',
                icon: Icons.check_circle,
              ),
              AppSegmentedControlOption(
                value: 2,
                label: '未払',
                icon: Icons.pending,
              ),
            ],
            value: _selectedFilterIndex,
            onChanged: (value) {
              setState(() {
                _selectedFilterIndex = value;
              });
            },
          ),
        ),

        // 参加者リスト
        Expanded(
          child: filteredParticipants.isEmpty
              ? Center(
                  child: Text(
                    '該当する参加者がいません',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // レスポンシブグリッド列数の計算
                    // mobileColumns: 1 → tablet: 2, tabletLarge: 3, desktop: 4
                    final width = constraints.maxWidth;
                    final crossAxisCount = AppBreakpoints.getGridCrossAxisCount(
                      width,
                      mobileColumns: 1,
                    );

                    return GridView.builder(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: AppTheme.spacing12,
                        crossAxisSpacing: AppTheme.spacing12,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: filteredParticipants.length,
                      itemBuilder: (context, index) {
                        final participant = filteredParticipants[index];
                        return _buildParticipantPaymentCard(
                          participant,
                          isOrganizer: isOrganizer,
                        );
                      },
                    );
                  },
                ),
        ),

        // 主催者用：金額再計算ボタン
        if (isOrganizer)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: AppButton.primary(
              text: '支払い金額を再計算',
              icon: const Icon(Icons.calculate, size: 20),
              onPressed: () => _handleRecalculatePayments(),
            ),
          ),
      ],
    );
  }

  List<ParticipantModel> _filterParticipants(
    List<ParticipantModel> participants,
  ) {
    switch (_selectedFilterIndex) {
      case 1: // 支払済
        return participants
            .where((p) => p.paymentStatus == PaymentStatus.paid)
            .toList();
      case 2: // 未払
        return participants
            .where((p) => p.paymentStatus != PaymentStatus.paid)
            .toList();
      default: // 全員
        return participants;
    }
  }

  Widget _buildPaymentSummaryCard({
    required int totalParticipants,
    required int paidCount,
    required int unpaidCount,
    required double totalAmount,
    required double paidAmount,
    required double remainingAmount,
  }) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppCardHeader(
              title: '支払いサマリー',
              subtitle: '現在の支払い状況',
            ),
            AppCardContent(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        '参加者',
                        '$totalParticipants人',
                        Icons.people,
                        AppTheme.primaryColor,
                      ),
                      _buildSummaryItem(
                        '支払済',
                        '$paidCount人',
                        Icons.check_circle,
                        AppTheme.successColor,
                      ),
                      _buildSummaryItem(
                        '未払',
                        '$unpaidCount人',
                        Icons.pending,
                        AppTheme.destructive,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  const Divider(),
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmountItem(
                          '総額',
                          totalAmount,
                          AppTheme.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: _buildAmountItem(
                          '回収済',
                          paidAmount,
                          AppTheme.successColor,
                        ),
                      ),
                      Expanded(
                        child: _buildAmountItem(
                          '未回収',
                          remainingAmount,
                          AppTheme.destructive,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(label, style: AppTheme.bodySmall.copyWith(
          color: AppTheme.mutedForeground,
        )),
        const SizedBox(height: AppTheme.spacing4),
        Text(value, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAmountItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          '¥${amount.toStringAsFixed(0)}',
          style: AppTheme.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantPaymentCard(
    ParticipantModel participant, {
    required bool isOrganizer,
  }) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            participant.displayName,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (participant.role == ParticipantRole.organizer) ...[
                            const SizedBox(width: AppTheme.spacing8),
                            AppBadge(
                              text: '主催者',
                              variant: AppBadgeVariant.default_,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        participant.email,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPaymentStatusBadge(participant.paymentStatus),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            const Divider(),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '支払い金額',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      '¥${participant.amountToPay.toStringAsFixed(0)}',
                      style: AppTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (isOrganizer)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppButton.outline(
                        text: participant.paymentStatus == PaymentStatus.paid
                            ? '未払に戻す'
                            : '支払済にする',
                        size: AppButtonSize.small,
                        onPressed: () => _handleTogglePaymentStatus(participant),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<void> _handleTogglePaymentStatus(ParticipantModel participant) async {
    final newStatus = participant.paymentStatus == PaymentStatus.paid
        ? PaymentStatus.unpaid
        : PaymentStatus.paid;

    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.updatePaymentStatus(
        eventId: widget.eventId,
        participantId: participant.id,
        status: newStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == PaymentStatus.paid
                  ? '${participant.displayName}の支払いを完了にしました'
                  : '${participant.displayName}の支払いを未払に戻しました',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('支払いステータスの更新に失敗しました: $e'),
            backgroundColor: AppTheme.destructive,
          ),
        );
      }
    }
  }

  Future<void> _handleRecalculatePayments() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支払い金額を再計算'),
        content: const Text(
          '支払い金額を再計算します。\n'
          '現在の参加者情報と設定に基づいて再計算されます。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          AppButton.primary(
            text: '再計算',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final paymentService = ref.read(paymentServiceProvider);
        await paymentService.calculateAndUpdatePayments(widget.eventId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('支払い金額を再計算しました'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('再計算に失敗しました: $e'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      }
    }
  }
}

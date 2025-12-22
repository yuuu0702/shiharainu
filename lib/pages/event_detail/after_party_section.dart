import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/providers/after_party_providers.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/utils/string_utils.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

/// 二次会セクション
class AfterPartySection extends HookConsumerWidget {
  final String eventId;
  final String eventTitle;

  const AfterPartySection({
    super.key,
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
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                            ),
                            child: const Icon(
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

    // 参加者リストの取得と選択状態の管理
    // ダイアログ表示前に非同期で取得するため、FutureBuilder等は使わず
    // 簡易的にStatefulBuilder内で管理するか、あるいは
    // ここではシンプルにダイアログ内でFutureBuilderを使用する構成にします。

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('二次会を作成'),
            content: SizedBox(
              width: double.maxFinite,
              child: FutureBuilder<List<ParticipantModel>>(
                future: ref.read(eventParticipantsProvider(eventId).future),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final participants = snapshot.data!;
                  // 初期化時に全員選択状態にするためのSet
                  // Note: setStateが呼ばれるたびに再生成されないよう、
                  // 実際にはさらに上位で管理するか、ここでの変数は
                  // build外で保持する必要がありますが、
                  // StatefulBuilderの制約上、内部で管理するためのラッパーウィジェットを作るのが正攻法です。
                  // 今回は簡易化のため、ParticipantSelectorという内部クラスを作って分離するか
                  // あるいはStatefulWidgetを別ファイルに切り出すのがベストですが
                  // ファイル内で完結させるため、StatefulBuilder内で
                  // 初期化済みかどうかを判定するロジックを入れます。

                  return _AfterPartyCreationForm(
                    participants: participants,
                    titleController: titleController,
                    amountController: amountController,
                    initialPaymentType: selectedPaymentType,
                    onSave: (title, amount, paymentType, selectedIds) async {
                      try {
                        final afterPartyService = ref.read(
                          afterPartyServiceProvider,
                        );

                        final afterPartyId = await afterPartyService
                            .createAfterParty(
                              parentEventId: eventId,
                              title: title,
                              totalAmount: amount,
                              paymentType: paymentType,
                              selectedParticipantIds:
                                  selectedIds, // 選択された参加者IDを渡す
                            );

                        ref.invalidate(afterPartiesProvider(eventId));

                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('二次会を作成しました'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AfterPartyCreationForm extends StatefulWidget {
  final List<ParticipantModel> participants;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final PaymentType initialPaymentType;
  final Function(String, double, PaymentType, List<String>) onSave;

  const _AfterPartyCreationForm({
    required this.participants,
    required this.titleController,
    required this.amountController,
    required this.initialPaymentType,
    required this.onSave,
  });

  @override
  State<_AfterPartyCreationForm> createState() =>
      _AfterPartyCreationFormState();
}

class _AfterPartyCreationFormState extends State<_AfterPartyCreationForm> {
  late PaymentType selectedPaymentType;
  late Set<String> selectedParticipantIds;

  @override
  void initState() {
    super.initState();
    selectedPaymentType = widget.initialPaymentType;
    // デフォルトで全員選択（タイムライン的アプローチ）
    selectedParticipantIds = widget.participants.map((p) => p.userId).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppInput(
            label: '二次会名',
            controller: widget.titleController,
            isRequired: true,
          ),
          const SizedBox(height: AppTheme.spacing16),
          AppInput(
            label: '総支払い金額',
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            isRequired: false,
            prefixIcon: const Icon(Icons.currency_yen, size: 20),
          ),
          const SizedBox(height: AppTheme.spacing16),

          // 支払い方法選択
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
                            onPressed: () => setState(
                              () => selectedPaymentType = PaymentType.equal,
                            ),
                          )
                        : AppButton.outline(
                            text: '均等割り',
                            icon: const Icon(Icons.balance, size: 16),
                            size: AppButtonSize.medium,
                            onPressed: () => setState(
                              () => selectedPaymentType = PaymentType.equal,
                            ),
                          ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: selectedPaymentType == PaymentType.proportional
                        ? AppButton.primary(
                            text: '比例割り',
                            icon: const Icon(Icons.stairs, size: 16),
                            size: AppButtonSize.medium,
                            onPressed: () => setState(
                              () => selectedPaymentType =
                                  PaymentType.proportional,
                            ),
                          )
                        : AppButton.outline(
                            text: '比例割り',
                            icon: const Icon(Icons.stairs, size: 16),
                            size: AppButtonSize.medium,
                            onPressed: () => setState(
                              () => selectedPaymentType =
                                  PaymentType.proportional,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing24),

          // 参加者選択セクション
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '参加者 (${selectedParticipantIds.length}/${widget.participants.length})',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (selectedParticipantIds.length ==
                            widget.participants.length) {
                          selectedParticipantIds.clear();
                        } else {
                          selectedParticipantIds = widget.participants
                              .map((p) => p.userId)
                              .toSet();
                        }
                      });
                    },
                    child: Text(
                      selectedParticipantIds.length ==
                              widget.participants.length
                          ? 'すべて解除'
                          : 'すべて選択',
                      style: AppTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.mutedColor),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                height: 200, // 高さを制限してスクロール可能に
                child: ListView.separated(
                  itemCount: widget.participants.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final participant = widget.participants[index];
                    final isSelected = selectedParticipantIds.contains(
                      participant.userId,
                    );

                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedParticipantIds.add(participant.userId);
                          } else {
                            selectedParticipantIds.remove(participant.userId);
                          }
                        });
                      },
                      title: Text(
                        participant.displayName,
                        style: isSelected
                            ? AppTheme.bodyMedium
                            : AppTheme.bodyMedium.copyWith(
                                color: AppTheme.mutedForeground,
                              ),
                      ),
                      secondary: CircleAvatar(
                        radius: 16,
                        backgroundColor: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : AppTheme.mutedColor,
                        child: Text(
                          participant.displayName.isNotEmpty
                              ? participant.displayName[0]
                              : '?',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.mutedForeground,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing24),

          // アクションボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: AppTheme.spacing8),
              AppButton.primary(
                text: '作成',
                onPressed: () {
                  if (widget.titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('イベント名を入力してください'),
                        backgroundColor: AppTheme.destructive,
                      ),
                    );
                    return;
                  }

                  final amountText = widget.amountController.text
                      .trim()
                      .normalizeNumbers();
                  final totalAmount = amountText.isEmpty
                      ? 0.0
                      : double.parse(amountText);

                  widget.onSave(
                    widget.titleController.text.trim(),
                    totalAmount,
                    selectedPaymentType,
                    selectedParticipantIds.toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

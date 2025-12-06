import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/providers/after_party_providers.dart';
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
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
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

                  // Providerを更新（ダイアログを閉じる前に実行）
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

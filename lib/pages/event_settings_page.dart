// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class EventSettingsPage extends HookConsumerWidget {
  final String eventId;

  const EventSettingsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventStreamProvider(eventId));
    final isOrganizerAsync = ref.watch(isEventOrganizerProvider(eventId));

    return SimplePage(
      title: 'イベント設定',
      body: eventAsync.when(
        data: (event) {
          return isOrganizerAsync.when(
            data: (isOrganizer) {
              if (!isOrganizer) {
                return _buildNoPermission();
              }
              return _EventSettingsForm(event: event);
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

  Widget _buildNoPermission() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: AppTheme.mutedForeground),
          const SizedBox(height: AppTheme.spacing16),
          Text('権限がありません', style: AppTheme.headlineMedium),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'イベント設定は主催者のみが編集できます',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EventSettingsForm extends HookConsumerWidget {
  final EventModel event;

  const _EventSettingsForm({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: event.title);
    final descriptionController = useTextEditingController(
      text: event.description,
    );
    final totalAmountController = useTextEditingController(
      text: event.totalAmount.toStringAsFixed(0),
    );
    final selectedEventType = useState<EventType>(event.eventType);
    final selectedPaymentType = useState<PaymentType>(event.paymentType);
    final selectedStatus = useState<EventStatus>(event.status);
    final selectedDate = useState<DateTime>(event.date);
    final isLoading = useState<bool>(false);

    Future<void> handleSave() async {
      if (isLoading.value) return;

      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final totalAmountText = totalAmountController.text.trim();

      if (title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('イベント名を入力してください'),
            backgroundColor: AppTheme.destructive,
          ),
        );
        return;
      }

      if (totalAmountText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('合計金額を入力してください'),
            backgroundColor: AppTheme.destructive,
          ),
        );
        return;
      }

      final totalAmount = double.tryParse(totalAmountText);
      if (totalAmount == null || totalAmount < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('合計金額は0以上の数値を入力してください'),
            backgroundColor: AppTheme.destructive,
          ),
        );
        return;
      }

      isLoading.value = true;

      try {
        final eventService = ref.read(eventServiceProvider);
        await eventService.updateEventFields(
          eventId: event.id,
          title: title,
          description: description,
          eventType: selectedEventType.value,
          date: selectedDate.value,
          totalAmount: totalAmount,
          paymentType: selectedPaymentType.value,
          status: selectedStatus.value,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('イベント情報を更新しました'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('更新エラー'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('以下のエラーが発生しました:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SelectableText(
                        e.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    Future<void> handleDelete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('イベント削除'),
          content: const Text(
            'このイベントを削除しますか?\n\n'
            'この操作は取り消せません。\n'
            'イベント、参加者、支払い記録がすべて削除されます。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            AppButton(
              text: '削除',
              variant: AppButtonVariant.primary,
              isDestructive: true,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        isLoading.value = true;

        try {
          final eventService = ref.read(eventServiceProvider);
          await eventService.deleteEvent(event.id);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('イベントを削除しました'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            context.go('/dashboard');
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('削除に失敗しました: $e'),
                backgroundColor: AppTheme.destructive,
              ),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 基本情報セクション
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppCardHeader(title: '基本情報', subtitle: 'イベントの基本情報を編集'),
                AppCardContent(
                  child: Column(
                    children: [
                      AppInput(
                        label: 'イベント名',
                        controller: titleController,
                        isRequired: true,
                        placeholder: 'イベント名を入力',
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      AppInput(
                        label: '説明',
                        controller: descriptionController,
                        placeholder: 'イベントの説明を入力',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      AppSelect<EventType>(
                        label: 'イベント種別',
                        value: selectedEventType.value,
                        items: [
                          DropdownMenuItem(
                            value: EventType.drinkingParty,
                            child: const Text('飲み会'),
                          ),
                          DropdownMenuItem(
                            value: EventType.welcomeParty,
                            child: const Text('歓送迎会'),
                          ),
                          DropdownMenuItem(
                            value: EventType.yearEndParty,
                            child: const Text('忘年会・新年会'),
                          ),
                          DropdownMenuItem(
                            value: EventType.other,
                            child: const Text('その他'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            selectedEventType.value = value;
                          }
                        },
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null && context.mounted) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                selectedDate.value,
                              ),
                            );
                            if (time != null) {
                              selectedDate.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            }
                          }
                        },
                        child: AppInput(
                          label: '開催日時',
                          controller: TextEditingController(
                            text: _formatDateTime(selectedDate.value),
                          ),
                          readOnly: true,
                          onTap: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacing16),

          // 支払い設定セクション
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppCardHeader(title: '支払い設定', subtitle: '金額と支払い方法'),
                AppCardContent(
                  child: Column(
                    children: [
                      AppInput(
                        label: '合計金額（¥）',
                        controller: totalAmountController,
                        isRequired: true,
                        placeholder: '0',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      AppSelect<PaymentType>(
                        label: '支払い方法',
                        value: selectedPaymentType.value,
                        items: [
                          DropdownMenuItem(
                            value: PaymentType.equal,
                            child: const Text('均等割り'),
                          ),
                          DropdownMenuItem(
                            value: PaymentType.proportional,
                            child: const Text('比例配分（役職・年齢・性別）'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            selectedPaymentType.value = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacing16),

          // ステータス管理セクション
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppCardHeader(title: 'ステータス管理', subtitle: 'イベントの進行状況'),
                AppCardContent(
                  child: AppSelect<EventStatus>(
                    label: 'イベントステータス',
                    value: selectedStatus.value,
                    items: [
                      DropdownMenuItem(
                        value: EventStatus.planning,
                        child: const Text('計画中'),
                      ),
                      DropdownMenuItem(
                        value: EventStatus.active,
                        child: const Text('進行中'),
                      ),
                      DropdownMenuItem(
                        value: EventStatus.completed,
                        child: const Text('完了'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedStatus.value = value;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacing24),

          // 保存ボタン
          AppButton.primary(
            text: '変更を保存',
            icon: const Icon(Icons.check, size: 20),
            onPressed: isLoading.value ? null : handleSave,
            isLoading: isLoading.value,
          ),

          const SizedBox(height: AppTheme.spacing16),

          // 危険なアクション
          const Divider(),

          const SizedBox(height: AppTheme.spacing16),

          Text(
            '危険なアクション',
            style: AppTheme.headlineSmall.copyWith(color: AppTheme.destructive),
          ),

          const SizedBox(height: AppTheme.spacing8),

          Text(
            'イベントを削除すると、すべての参加者情報と支払い記録が失われます。',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.mutedForeground),
          ),

          const SizedBox(height: AppTheme.spacing16),

          AppButton(
            text: 'イベントを削除',
            icon: const Icon(Icons.delete_outline, size: 20),
            variant: AppButtonVariant.outline,
            isDestructive: true,
            onPressed: isLoading.value ? null : handleDelete,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

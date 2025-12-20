// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalAmountController = TextEditingController();

  EventType _eventType = EventType.drinkingParty;
  String _calculationMethod = 'equal';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0); // デフォルト19:00
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  void _handleCreateEvent() async {
    // バリデーション
    final eventName = _eventNameController.text.trim();
    final description = _descriptionController.text.trim();
    final totalAmountText = _totalAmountController.text.trim();

    if (eventName.isEmpty) {
      setState(() {
        _errorMessage = 'イベント名を入力してください';
      });
      return;
    }

    if (totalAmountText.isEmpty) {
      setState(() {
        _errorMessage = '総支払い金額を入力してください';
      });
      return;
    }

    final totalAmount = double.tryParse(totalAmountText);
    if (totalAmount == null || totalAmount <= 0) {
      setState(() {
        _errorMessage = '有効な金額を入力してください';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // EventServiceを使ってイベントを作成
      final container = ProviderScope.containerOf(context);
      final eventService = container.read(eventServiceProvider);

      final paymentType = _calculationMethod == 'equal'
          ? PaymentType.equal
          : PaymentType.proportional;

      // 日付と時刻を組み合わせる
      final eventDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final params = CreateEventParams(
        title: eventName,
        description: description,
        eventType: _eventType,
        date: eventDateTime,
        totalAmount: totalAmount,
        paymentType: paymentType,
      );

      final eventId = await eventService.createEvent(params);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // イベント作成成功ダイアログを表示
        final shouldShowInvite = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.celebration, color: AppTheme.successColor, size: 24),
                const SizedBox(width: AppTheme.spacing8),
                const Text('イベントが作成されました！'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('次に参加者を招待しましょう。'),
                const SizedBox(height: AppTheme.spacing16),
                AppButton.primary(
                  text: '招待リンクを共有',
                  icon: const Icon(Icons.share, size: 18),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('後で招待する'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );

        if (mounted) {
          // イベント詳細ページに遷移
          context.go('/events/$eventId');

          // 招待リンクダイアログを表示する場合
          if (shouldShowInvite == true) {
            // 少し遅延を入れてダイアログを表示
            await Future.delayed(const Duration(milliseconds: 300));
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) =>
                    InviteLinkDialog(eventId: eventId, eventTitle: eventName),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'イベント作成',
      leading: AppButton.icon(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本情報セクション
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppCardHeader(
                    title: '基本情報',
                    subtitle: 'イベントの基本的な情報を入力してください',
                  ),
                  const AppCardContent(child: Column(children: [])),
                  AppInput(
                    label: 'イベント名',
                    placeholder: '例：新年会、歓送迎会',
                    controller: _eventNameController,
                    isRequired: true,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  AppTextarea(
                    label: '詳細説明',
                    placeholder: 'イベントの詳細を入力してください',
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  AppSelect<EventType>(
                    label: 'イベント種別',
                    value: _eventType,
                    isRequired: true,
                    items: const [
                      DropdownMenuItem(
                        value: EventType.drinkingParty,
                        child: Text('飲み会'),
                      ),
                      DropdownMenuItem(
                        value: EventType.welcomeParty,
                        child: Text('歓送迎会'),
                      ),
                      DropdownMenuItem(
                        value: EventType.yearEndParty,
                        child: Text('忘年会・新年会'),
                      ),
                      DropdownMenuItem(
                        value: EventType.other,
                        child: Text('その他'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _eventType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  // 日付・時刻選択
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('イベント日時', style: AppTheme.labelLarge),
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            '*',
                            style: AppTheme.labelLarge.copyWith(
                              color: AppTheme.destructive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Row(
                        children: [
                          // 日付選択
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.inputBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusSmall,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.mutedForeground.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20,
                                      color: AppTheme.mutedForeground,
                                    ),
                                    const SizedBox(width: AppTheme.spacing8),
                                    Expanded(
                                      child: Text(
                                        '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                                        style: AppTheme.bodyMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                      color: AppTheme.mutedForeground,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          // 時刻選択
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (time != null) {
                                  setState(() {
                                    _selectedTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.inputBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusSmall,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.mutedForeground.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 20,
                                      color: AppTheme.mutedForeground,
                                    ),
                                    const SizedBox(width: AppTheme.spacing8),
                                    Expanded(
                                      child: Text(
                                        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                        style: AppTheme.bodyMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                      color: AppTheme.mutedForeground,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),

            // 支払い設定セクション
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppCardHeader(
                    title: '支払い設定',
                    subtitle: '支払い金額と計算方法を設定してください',
                  ),
                  const AppCardContent(child: Column(children: [])),
                  AppInput(
                    label: '総支払い金額',
                    placeholder: '20000',
                    controller: _totalAmountController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    prefixIcon: const Icon(Icons.currency_yen, size: 20),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  const Text('計算方法', style: AppTheme.labelLarge),
                  const SizedBox(height: AppTheme.spacing8),
                  AppSegmentedControl<String>(
                    options: const [
                      AppSegmentedControlOption(
                        value: 'equal',
                        label: '均等割り',
                        icon: Icons.balance,
                      ),
                      AppSegmentedControlOption(
                        value: 'proportional',
                        label: '比例割り',
                        icon: Icons.stairs,
                      ),
                    ],
                    value: _calculationMethod,
                    onChanged: (value) {
                      setState(() {
                        _calculationMethod = value;
                      });
                    },
                  ),
                  if (_calculationMethod == 'proportional') ...[
                    const SizedBox(height: AppTheme.spacing16),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing12),
                      decoration: BoxDecoration(
                        color: AppTheme.infoColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.infoColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppTheme.infoColor,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              '比例割りでは役職、年齢、性別、飲酒状況に基づいて自動計算されます',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.infoColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            // エラーメッセージ表示
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.destructive.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: AppTheme.destructive,
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.destructive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
            ],

            // アクションボタン
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    text: 'キャンセル',
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: AppButton.primary(
                    text: 'イベントを作成',
                    onPressed: _handleCreateEvent,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing32),
          ],
        ),
      ),
    );
  }
}

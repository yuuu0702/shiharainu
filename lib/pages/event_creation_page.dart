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

  String _eventType = 'drinking_party';
  String _calculationMethod = 'equal';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
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

      final params = CreateEventParams(
        title: eventName,
        description: description,
        date: _selectedDate,
        totalAmount: totalAmount,
        paymentType: paymentType,
      );

      final eventId = await eventService.createEvent(params);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('イベントが作成されました！'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // 作成したイベントの詳細ページに遷移
        context.go('/events/$eventId');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント作成'),
        leading: AppButton.icon(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
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
                  AppSelect<String>(
                    label: 'イベント種別',
                    value: _eventType,
                    isRequired: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'drinking_party',
                        child: Text('飲み会'),
                      ),
                      DropdownMenuItem(
                        value: 'welcome_party',
                        child: Text('歓送迎会'),
                      ),
                      DropdownMenuItem(
                        value: 'year_end_party',
                        child: Text('忘年会・新年会'),
                      ),
                      DropdownMenuItem(value: 'other', child: Text('その他')),
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
                  // 日付選択
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
                      InkWell(
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
                          padding: const EdgeInsets.all(AppTheme.spacing12),
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
                              const SizedBox(width: AppTheme.spacing12),
                              Text(
                                '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                                style: AppTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.mutedForeground,
                              ),
                            ],
                          ),
                        ),
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

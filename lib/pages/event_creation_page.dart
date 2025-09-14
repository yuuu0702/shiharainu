import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  void _handleCreateEvent() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate event creation
    await Future.delayed(const Duration(seconds: 2));

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

      context.go('/home');
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
        padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 16),
                  AppTextarea(
                    label: '詳細説明',
                    placeholder: 'イベントの詳細を入力してください',
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                  const SizedBox(height: 16),
                  const Text(
                    '計算方法',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '比例割りでは役職、年齢、性別、飲酒状況に基づいて自動計算されます',
                              style: TextStyle(
                                fontSize: 12,
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
            const SizedBox(height: 32),

            // アクションボタン
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    text: 'キャンセル',
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton.primary(
                    text: 'イベントを作成',
                    onPressed: _handleCreateEvent,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

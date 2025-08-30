import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/user_profile.dart';
import 'package:shiharainu/shared/services/user_service.dart';

class UserProfileSetupPage extends StatefulWidget {
  const UserProfileSetupPage({super.key});

  @override
  State<UserProfileSetupPage> createState() => _UserProfileSetupPageState();
}

class _UserProfileSetupPageState extends State<UserProfileSetupPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedPosition = UserPositions.commonPositions.first;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showPositionSelector() {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // ハンドル
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mutedForeground.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // タイトル
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '役職を選択',
                    style: AppTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // 役職リスト
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: UserPositions.commonPositions.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final position = UserPositions.commonPositions[index];
                  final isSelected = position == _selectedPosition;
                  
                  return ListTile(
                    title: Text(
                      position,
                      style: AppTheme.bodyMedium.copyWith(
                        color: isSelected ? AppTheme.primaryColor : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                    trailing: isSelected 
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(position);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).then((selectedPosition) {
      if (selectedPosition != null) {
        setState(() {
          _selectedPosition = selectedPosition;
        });
      }
    });
  }

  void _handleSaveProfile() async {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    // バリデーション
    if (name.isEmpty) {
      setState(() {
        _errorMessage = '名前を入力してください';
      });
      return;
    }

    if (ageText.isEmpty) {
      setState(() {
        _errorMessage = '年齢を入力してください';
      });
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 1 || age > 150) {
      setState(() {
        _errorMessage = '正しい年齢を入力してください';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final userService = container.read(userServiceProvider);
      
      // UserServiceを使用してFirestoreにユーザー情報を保存
      await userService.saveUserProfile(
        name: name,
        age: age,
        position: _selectedPosition,
      );

      if (mounted) {
        // プロフィール設定完了後、イベント一覧に遷移
        context.go('/events');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール設定'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        automaticallyImplyLeading: false, // 戻るボタンを非表示
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // ページタイトル
              Text(
                'プロフィールを設定',
                style: AppTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'あなたの基本情報を入力して、プロフィールを完成させましょう',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),

              // プロフィール入力フォーム
              AppCard(
                child: Column(
                  children: [
                    AppInput(
                      label: 'お名前',
                      placeholder: '山田 太郎',
                      controller: _nameController,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      label: '年齢',
                      placeholder: '例: 25',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.cake_outlined, size: 20),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 役職選択
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '役職',
                              style: AppTheme.labelMedium,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                color: AppTheme.destructive,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _showPositionSelector,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.inputBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.work_outline,
                                  size: 20,
                                  color: AppTheme.mutedForeground,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedPosition,
                                    style: AppTheme.bodyMedium,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppTheme.mutedForeground,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // エラーメッセージ表示
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.destructive,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.primary(
                        text: 'プロフィール保存',
                        onPressed: _handleSaveProfile,
                        isLoading: _isLoading,
                        size: AppButtonSize.large,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 後で設定するオプション
              Center(
                child: AppButton.link(
                  text: '後で設定する',
                  onPressed: () => context.go('/events'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
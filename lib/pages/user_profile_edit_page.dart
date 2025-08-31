import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/user_profile.dart';
import 'package:shiharainu/shared/services/user_service.dart';

class UserProfileEditPage extends ConsumerStatefulWidget {
  const UserProfileEditPage({super.key});

  @override
  ConsumerState<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends ConsumerState<UserProfileEditPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedPosition = UserPositions.hierarchicalPositions.first;
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final userProfileAsync = ref.read(userProfileProvider);
      
      userProfileAsync.when(
        data: (profile) {
          if (profile != null) {
            _nameController.text = profile.name;
            _ageController.text = profile.age.toString();
            _selectedPosition = profile.position;
          }
          setState(() {
            _isInitializing = false;
          });
        },
        loading: () {
          // ローディング中は初期化状態を維持
        },
        error: (error, stack) {
          setState(() {
            _errorMessage = 'プロフィール情報の読み込みに失敗しました';
            _isInitializing = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'プロフィール情報の読み込みに失敗しました: $e';
        _isInitializing = false;
      });
    }
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
            
            // 役職リスト（説明付き）
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: UserPositions.positionsWithDescription.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final positionData = UserPositions.positionsWithDescription[index];
                  final positionName = positionData['name']!;
                  final description = positionData['description']!;
                  final isSelected = positionName == _selectedPosition;
                  
                  return ListTile(
                    title: Text(
                      positionName,
                      style: AppTheme.bodyMedium.copyWith(
                        color: isSelected ? AppTheme.primaryColor : null,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      description,
                      style: AppTheme.bodySmall.copyWith(
                        color: isSelected 
                            ? AppTheme.primaryColor.withValues(alpha: 0.8)
                            : AppTheme.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                    trailing: isSelected 
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(positionName);
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
      final userService = ref.read(userServiceProvider);
      
      // UserServiceを使用してFirestoreにユーザー情報を保存
      await userService.saveUserProfile(
        name: name,
        age: age,
        position: _selectedPosition,
      );

      if (mounted) {
        // プロバイダーを強制的に更新してキャッシュをクリア
        ref.invalidate(userProfileProvider);
        
        // 少し待ってからナビゲーション（プロバイダーの更新を待つ）
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          // 成功のスナックバー表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('プロフィールを更新しました！'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // アカウント画面に戻る（現在のページを置き換え）
          context.pushReplacement('/account');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
        
        // エラーのスナックバー表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: AppTheme.destructive,
            duration: const Duration(seconds: 4),
          ),
        );
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
    // 初期化中はローディング画面を表示
    if (_isInitializing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール編集'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppTheme.spacing16),
              Text('プロフィール情報を読み込み中...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
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
                'プロフィールを編集',
                style: AppTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '基本情報を変更できます',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),

              // プロフィール編集フォーム
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
                    
                    // 保存・キャンセルボタン
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            text: 'キャンセル',
                            onPressed: _isLoading ? null : () => context.pushReplacement('/account'),
                            size: AppButtonSize.large,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: AppButton.primary(
                            text: _isLoading ? '保存中...' : '変更を保存',
                            onPressed: _isLoading ? null : _handleSaveProfile,
                            isLoading: _isLoading,
                            size: AppButtonSize.large,
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
      ),
    );
  }
}
// Governed by Skill: shiharainu-general-design
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/user_profile.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

class UserProfileSetupPage extends ConsumerStatefulWidget {
  const UserProfileSetupPage({super.key});

  @override
  ConsumerState<UserProfileSetupPage> createState() =>
      _UserProfileSetupPageState();
}

class _UserProfileSetupPageState extends ConsumerState<UserProfileSetupPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedPosition = UserPositions.hierarchicalPositions.first;
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mutedForeground.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
              ),
              child: Row(
                children: [
                  Text('役職を選択', style: AppTheme.headlineMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing24,
                ),
                itemCount: UserPositions.positionsWithDescription.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final positionData =
                      UserPositions.positionsWithDescription[index];
                  final positionName = positionData['name']!;
                  final description = positionData['description']!;
                  final isSelected = positionName == _selectedPosition;

                  return ListTile(
                    title: Text(
                      positionName,
                      style: AppTheme.bodyMedium.copyWith(
                        color: isSelected ? AppTheme.primaryColor : null,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
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

  Future<void> _waitForProfileUpdate() async {
    const maxAttempts = 50;
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final hasProfile = await ref.refresh(hasUserProfileProvider.future);
        if (hasProfile) {
          AppLogger.info('プロフィール情報の更新確認完了', name: 'UserProfileSetup');
          return;
        }
      } catch (e) {
        AppLogger.warning('プロフィール確認中にエラー', name: 'UserProfileSetup', error: e);
      }
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    AppLogger.warning('プロフィール更新の待機タイムアウト（5秒）', name: 'UserProfileSetup');
  }

  void _handleSaveProfile() async {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

    AppLogger.info('=== プロフィール保存開始 ===', name: 'UserProfileSetup');
    if (name.isEmpty) {
      setState(() => _errorMessage = '名前を入力してください');
      return;
    }

    int? age;
    if (!isGuest) {
      if (ageText.isEmpty) {
        setState(() => _errorMessage = '年齢を入力してください');
        return;
      }
      age = int.tryParse(ageText);
      if (age == null || age < 1 || age > 150) {
        setState(() => _errorMessage = '正しい年齢を入力してください');
        return;
      }
    } else {
      // ゲストの場合は年齢不要（または0として保存）
      age = 0;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = false;

    try {
      final userService = ref.read(userServiceProvider);
      await userService.saveUserProfile(
        name: name,
        age: age,
        position: _selectedPosition,
      );

      if (mounted) {
        ref.invalidate(hasUserProfileProvider);
        ref.invalidate(userProfileProvider);
        await _waitForProfileUpdate();

        if (mounted) {
          final state = GoRouterState.of(context);
          final redirect = state.uri.queryParameters['redirect'];

          if (redirect != null) {
            context.go(redirect);
          } else {
            context.go('/home');
          }

          success = true;
        }
      }
    } catch (e) {
      AppLogger.error('エラー発生', name: 'UserProfileSetup', error: e);
      if (mounted) {
        setState(
          () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted && !success) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'プロフィール設定',
      leading: const SizedBox.shrink(), // 戻るボタンを非表示
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacing8),
            Text('プロフィールを設定', style: AppTheme.displayMedium),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'あなたの基本情報を入力して、プロフィールを完成させましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

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
                  const SizedBox(height: AppTheme.spacing16),
                  // 年齢入力 (ゲストの場合は非表示)
                  if (!(FirebaseAuth.instance.currentUser?.isAnonymous ??
                      false)) ...[
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
                    const SizedBox(height: AppTheme.spacing16),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('役職', style: AppTheme.labelMedium),
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            '*',
                            style: TextStyle(color: AppTheme.destructive),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      InkWell(
                        onTap: _showPositionSelector,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppTheme.spacing12),
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
                              const SizedBox(width: AppTheme.spacing12),
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
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppTheme.spacing16),
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
                  const SizedBox(height: AppTheme.spacing24),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.primary(
                      text: _isLoading ? '保存中...' : 'プロフィール保存',
                      onPressed: _isLoading ? null : _handleSaveProfile,
                      isLoading: _isLoading,
                      size: AppButtonSize.large,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Center(
              child: AppButton.link(
                text: '後で設定する',
                onPressed: () => context.go('/events'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

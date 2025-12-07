import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/invite_service.dart';
import 'package:shiharainu/shared/widgets/app_button.dart';
import 'package:shiharainu/shared/widgets/app_input.dart';
import 'package:shiharainu/shared/widgets/app_toast.dart';

/// 参加コードを入力してイベントに参加するダイアログ
class JoinEventDialog extends HookConsumerWidget {
  const JoinEventDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteService = ref.read(inviteServiceProvider);
    final codeController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    // 参加コードを検証してイベントに遷移
    Future<void> handleJoinEvent() async {
      final inviteCode = codeController.text.trim();

      if (inviteCode.isEmpty) {
        errorMessage.value = '参加コードを入力してください';
        return;
      }

      // 基本的な形式チェック (evt_xxxxxxxx)
      if (!inviteCode.startsWith('evt_') || inviteCode.length < 9) {
        errorMessage.value = '無効な参加コードです';
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      try {
        // 招待コード検証
        final isValid = await inviteService.validateInviteCode(inviteCode);
        if (!isValid) {
          errorMessage.value = '無効な参加コードです';
          isLoading.value = false;
          return;
        }

        // ダイアログを閉じて招待受け入れページに遷移
        if (context.mounted) {
          Navigator.of(context).pop();
          context.go('/invite/$inviteCode');
        }
      } catch (e) {
        if (context.mounted) {
          errorMessage.value = '参加コードの確認に失敗しました';
          AppToast.show(
            context,
            message: 'エラーが発生しました: $e',
            type: AppToastType.error,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 24,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'イベントに参加',
                      style: AppTheme.headlineMedium.copyWith(
                        color: AppTheme.foregroundColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppTheme.mutedForeground,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 説明文
            Text(
              '参加コードを入力してイベントに参加しましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),

            // 参加コード入力
            AppInput(
              label: '参加コード',
              placeholder: 'evt_xxxxxxxx',
              controller: codeController,
              isRequired: true,
              prefixIcon: const Icon(Icons.vpn_key_outlined, size: 20),
              errorText: errorMessage.value,
              onChanged: (_) {
                // 入力時にエラーをクリア
                errorMessage.value = null;
              },
            ),
            const SizedBox(height: 8),

            // ヒント
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.infoColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '参加コードは主催者から共有されたものです',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // アクションボタン
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    text: 'キャンセル',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton.primary(
                    text: '参加する',
                    onPressed: isLoading.value ? null : handleJoinEvent,
                    isLoading: isLoading.value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

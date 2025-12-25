import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/invite_service.dart';
import 'package:shiharainu/shared/widgets/app_button.dart';
import 'package:shiharainu/shared/widgets/app_progress.dart';
import 'package:shiharainu/shared/widgets/app_toast.dart';

/// 招待リンクを表示・共有するダイアログ
class InviteLinkDialog extends HookConsumerWidget {
  final String eventId;
  final String eventTitle;

  const InviteLinkDialog({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteService = ref.read(inviteServiceProvider);
    final inviteLink = useState<String?>(null);
    final isLoading = useState(false);
    final isCopied = useState(false);

    // 招待リンクを生成
    Future<void> generateInviteLink() async {
      isLoading.value = true;

      try {
        // 既存の招待コードを取得または新規生成
        final inviteCode = await inviteService.getOrCreateInviteCode(eventId);

        final link = inviteService.generateInviteLink(inviteCode);

        inviteLink.value = link;
      } catch (e) {
        if (context.mounted) {
          AppToast.show(
            context,
            message: '招待リンクの生成に失敗しました: $e',
            type: AppToastType.error,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    // クリップボードにコピー
    Future<void> copyToClipboard() async {
      if (inviteLink.value == null) return;

      try {
        await inviteService.copyInviteLinkToClipboard(inviteLink.value!);

        isCopied.value = true;

        if (context.mounted) {
          AppToast.show(
            context,
            message: '招待リンクをコピーしました',
            type: AppToastType.success,
          );
        }

        // 3秒後にコピー状態をリセット
        Future.delayed(const Duration(seconds: 3), () {
          isCopied.value = false;
        });
      } catch (e) {
        if (context.mounted) {
          AppToast.show(
            context,
            message: 'コピーに失敗しました: $e',
            type: AppToastType.error,
          );
        }
      }
    }

    // シェア
    Future<void> shareLink() async {
      if (inviteLink.value == null) return;

      try {
        await inviteService.shareInviteLink(
          eventTitle: eventTitle,
          inviteLink: inviteLink.value!,
        );

        if (context.mounted) {
          AppToast.show(
            context,
            message: '招待リンクをクリップボードにコピーしました',
            type: AppToastType.success,
          );
        }
      } catch (e) {
        if (context.mounted) {
          AppToast.show(
            context,
            message: '共有に失敗しました: $e',
            type: AppToastType.error,
          );
        }
      }
    }

    // 初回ロード時に招待リンクを生成
    useEffect(() {
      generateInviteLink();
      return null;
    }, []);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '招待リンク',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.foregroundColor,
                  ),
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
            const SizedBox(height: 16),

            // 説明文
            Text(
              'このリンクをシェアして、イベントに招待しましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),

            // ローディング中またはリンク表示
            if (isLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: AppProgress.circular(),
                ),
              )
            else if (inviteLink.value != null) ...[
              // QRコードセクション
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.mutedForeground.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '📱 QRコードをスキャン',
                      style: AppTheme.labelLarge.copyWith(
                        color: AppTheme.foregroundColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // QRコード
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImageView(
                        data: inviteLink.value!,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 参加コードセクション
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.mutedColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.vpn_key_outlined,
                          size: 20,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '参加コード',
                          style: AppTheme.labelLarge.copyWith(
                            color: AppTheme.foregroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // URLから参加コードを抽出 (最後の/以降)
                          inviteLink.value!.split('/').last,
                          style: AppTheme.headlineMedium.copyWith(
                            fontFamily: 'monospace',
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(
                            isCopied.value ? Icons.check_circle : Icons.copy,
                            size: 24,
                            color: isCopied.value
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                          ),
                          onPressed: () async {
                            final inviteCode = inviteLink.value!
                                .split('/')
                                .last;
                            await inviteService.copyInviteLinkToClipboard(
                              inviteCode,
                            );
                            isCopied.value = true;
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                message: '参加コードをコピーしました',
                                type: AppToastType.success,
                              );
                            }
                            Future.delayed(const Duration(seconds: 3), () {
                              isCopied.value = false;
                            });
                          },
                          tooltip: 'コードをコピー',
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // URLリンクセクション（折りたたみ可能）
              Text(
                '🔗 またはリンクをシェア',
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.mutedColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.mutedForeground.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        inviteLink.value!,
                        style: AppTheme.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          color: AppTheme.foregroundColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isCopied.value ? Icons.check : Icons.copy,
                        size: 20,
                        color: isCopied.value
                            ? AppTheme.successColor
                            : AppTheme.mutedForeground,
                      ),
                      onPressed: copyToClipboard,
                      tooltip: 'リンクをコピー',
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // シェアボタン
              AppButton.primary(
                text: 'シェア',
                icon: const Icon(Icons.share, size: 18),
                onPressed: shareLink,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

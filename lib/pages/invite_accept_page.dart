import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/invite_service.dart';
import 'package:shiharainu/shared/widgets/app_button.dart';
import 'package:shiharainu/shared/widgets/app_progress.dart';

/// 招待コードを受け入れてイベントに参加するページ
class InviteAcceptPage extends HookConsumerWidget {
  final String inviteCode;

  const InviteAcceptPage({
    super.key,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteService = ref.read(inviteServiceProvider);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final eventId = useState<String?>(null);
    final eventTitle = useState<String>('イベント');
    final isJoining = useState(false);

    // 招待コードを検証してイベント情報を取得
    Future<void> validateAndLoadEvent() async {
      try {
        // 招待コード検証
        final isValid = await inviteService.validateInviteCode(inviteCode);
        if (!isValid) {
          error.value = '無効な招待コードです';
          isLoading.value = false;
          return;
        }

        // イベントID取得
        final fetchedEventId =
            await inviteService.getEventIdFromInviteCode(inviteCode);
        eventId.value = fetchedEventId;

        // イベント情報取得
        final eventDoc = await FirebaseFirestore.instance
            .collection('events')
            .doc(fetchedEventId)
            .get();

        if (!eventDoc.exists) {
          error.value = 'イベントが見つかりません';
          isLoading.value = false;
          return;
        }

        eventTitle.value = eventDoc.data()!['title'] as String? ?? 'イベント';
        isLoading.value = false;
      } catch (e) {
        error.value = 'エラーが発生しました: $e';
        isLoading.value = false;
      }
    }

    // イベントに参加
    Future<void> joinEvent() async {
      if (eventId.value == null) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        error.value = 'ログインが必要です';
        // ログインページにリダイレクト
        if (context.mounted) {
          context.go('/login');
        }
        return;
      }

      isJoining.value = true;

      try {
        final firestore = FirebaseFirestore.instance;
        final participantsRef = firestore
            .collection('events')
            .doc(eventId.value!)
            .collection('participants');

        // 既に参加済みか確認
        final existingParticipant =
            await participantsRef.where('userId', isEqualTo: user.uid).get();

        if (existingParticipant.docs.isNotEmpty) {
          // 既に参加済みの場合はイベント詳細ページへ
          if (context.mounted) {
            context.go('/events/${eventId.value}');
          }
          return;
        }

        // 参加者情報を作成
        final participantId = firestore.collection('_').doc().id;
        final newParticipant = ParticipantModel(
          id: participantId,
          eventId: eventId.value!,
          userId: user.uid,
          displayName: user.displayName ?? 'ゲスト',
          email: user.email ?? '',
          role: ParticipantRole.participant,
          joinedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Firestoreに保存
        await participantsRef
            .doc(participantId)
            .set(ParticipantModel.toFirestore(newParticipant));

        // 招待コード使用回数を増やす
        await inviteService.incrementUsageCount(inviteCode);

        // イベント詳細ページにリダイレクト
        if (context.mounted) {
          context.go('/events/${eventId.value}');
        }
      } catch (e) {
        error.value = '参加に失敗しました: $e';
      } finally {
        isJoining.value = false;
      }
    }

    // 初回ロード
    useEffect(() {
      validateAndLoadEvent();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: isLoading.value
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppProgress.circular(),
                      SizedBox(height: 16),
                      Text(
                        '招待情報を確認中...',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  )
                : error.value != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppTheme.destructiveColor,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            error.value!,
                            style: AppTheme.headlineMedium.copyWith(
                              color: AppTheme.destructiveColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          AppButton.outline(
                            text: 'ホームに戻る',
                            onPressed: () => context.go('/home'),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '${eventTitle.value}に招待されました',
                            style: AppTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'イベントに参加しますか?',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.mutedForeground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          AppButton.primary(
                            text: isJoining.value ? '参加中...' : 'イベントに参加',
                            onPressed: isJoining.value ? null : joinEvent,
                            isLoading: isJoining.value,
                          ),
                          const SizedBox(height: 16),
                          AppButton.outline(
                            text: 'キャンセル',
                            onPressed: () => context.go('/home'),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

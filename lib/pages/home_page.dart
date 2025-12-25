import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/pages/home/home_data_models.dart';
import 'package:shiharainu/pages/home/home_welcome_section.dart';
import 'package:shiharainu/pages/home/home_quick_actions.dart';
import 'package:shiharainu/pages/home/home_events_section.dart';
import 'package:shiharainu/pages/home/home_activity_summary.dart';
import 'package:shiharainu/pages/home/smart_dashboard.dart';
import 'package:shiharainu/pages/home/smart_dashboard_logic.dart';

/// ホームページ
///
/// アプリのメインダッシュボード。ウェルカムメッセージ、クイックアクション、
/// 通知、イベント、活動サマリーを表示します。
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 犬のアイコンリスト（しはらいぬにちなんで）
  static const List<String> _dogEmojis = ['🐕', '🐶', '🦮', '🐕‍🦺', '🎾🐕'];

  // パフォーマンス最適化：ランダム生成をウィジェット初期化時に実行
  late final String _selectedDogEmoji;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _selectedDogEmoji = _dogEmojis[random.nextInt(_dogEmojis.length)];
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final upcomingEventsAsync = ref.watch(userEventsStreamProvider);
    final myParticipationsAsync = ref.watch(myParticipationsStreamProvider);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return userProfile.when(
      data: (profile) {
        return SimplePage(
          title: 'ホーム',
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
              // StreamProviderは自動更新なのでinvalidate不要だが、念の為
              await Future.delayed(const Duration(milliseconds: 800));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ウェルカムセクション
                  HomeWelcomeSection(
                    userName: profile?.name ?? 'ゲスト',
                    dogEmoji: _selectedDogEmoji,
                  ),
                  const SizedBox(height: AppTheme.spacing16),

                  // Smart Dashboard (文脈に応じたアクション)
                  if (currentUserId != null)
                    upcomingEventsAsync.when(
                      data: (events) {
                        return myParticipationsAsync.when(
                          data: (participations) {
                            final action =
                                SmartDashboardLogic.determinePrimaryAction(
                                  events: events,
                                  myParticipations: participations,
                                  currentUserId: currentUserId,
                                );
                            return Column(
                              children: [
                                SmartDashboard(action: action),
                                const SizedBox(height: AppTheme.spacing24),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(), // Loading...
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                      loading: () =>
                          const Center(child: AppProgress.circular()),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                  // アクションカード（主要機能へのショートカット） - 優先度下げ
                  // const HomeQuickActions(), // Smart Dashboardが機能すれば、ここはシンプルにしてもいいかも
                  // 一旦そのまま残すが、SmartDashboardでカバーされるアクションとの重複を考慮
                  const HomeQuickActions(),
                  const SizedBox(height: AppTheme.spacing24),

                  // 近日中のイベント（3件まで）
                  upcomingEventsAsync.when(
                    data: (events) {
                      // EventModel -> EventData 変換 (表示用)
                      final eventDataList = events.take(3).map((e) {
                        // ここで簡易的に変換
                        return EventData(
                          id: e.id,
                          title: e.title,
                          description: e.description,
                          date: e.date,
                          participantCount:
                              0, // ※ここを正確にするには別途取得が必要だが、一旦0かProviderで
                          role: EventRole.participant, // 仮
                          status: EventStatus.active,
                        );
                      }).toList();

                      // NOTE: home_events_sectionがEventDataを要求するため、簡易変換のみ行う。
                      // 本来的にはHomeEventsSectionをEventModel対応にするべきだが、
                      // 大規模改修を避けるため、一旦既存のUIを維持する。
                      // ただし、これだとparticipantCountなどが正しく出ない。

                      // 今回はSmartDashboardがメインなので、ここのリストは補助的。
                      // TODO: HomeEventsSectionをEventModel対応にリファクタリング推奨
                      final isGuest =
                          FirebaseAuth.instance.currentUser?.isAnonymous ??
                          false;
                      if (isGuest && eventDataList.isEmpty) {
                        return const SizedBox.shrink(); // ゲストでイベントなしならセクションごと非表示
                      }
                      return HomeEventsSection(events: eventDataList);
                    },
                    loading: () => const AppProgress.circular(),
                    error: (err, stack) => Text('イベント読み込みエラー: $err'),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // 今月の活動サマリー
                  // 今月の活動サマリー (ゲスト以外のみ表示)
                  if (!(FirebaseAuth.instance.currentUser?.isAnonymous ??
                      false))
                    const HomeActivitySummary(),

                  // 下部余白
                  const SizedBox(height: AppTheme.spacing32),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => SimplePage(
        title: 'ホーム',
        body: const Center(
          child: AppProgress.circular(
            size: AppProgressSize.large,
            label: 'データを読み込み中...',
          ),
        ),
      ),
      error: (error, stack) {
        return SimplePage(
          title: 'ホーム',
          body: Center(
            child: AppErrorWidget.networkError(
              onRetry: () {
                ref.invalidate(userProfileProvider);
              },
            ),
          ),
        );
      },
    );
  }
}

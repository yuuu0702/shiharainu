import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/pages/login_page.dart';
import 'package:shiharainu/pages/signup_page.dart';
import 'package:shiharainu/pages/user_profile_setup_page.dart';
import 'package:shiharainu/pages/event_creation_page.dart';
import 'package:shiharainu/pages/home_page.dart';
import 'package:shiharainu/pages/events_page.dart';
import 'package:shiharainu/pages/event_detail_page.dart';
import 'package:shiharainu/pages/event_participant_management_page.dart';
import 'package:shiharainu/pages/event_payment_management_page.dart';
import 'package:shiharainu/pages/event_settings_page.dart';
import 'package:shiharainu/pages/account_page.dart';
import 'package:shiharainu/pages/user_profile_edit_page.dart';
import 'package:shiharainu/pages/app_info_page.dart';
import 'package:shiharainu/pages/notifications_page.dart';
import 'package:shiharainu/pages/invite_accept_page.dart';
import 'package:shiharainu/pages/guest_promotion_page.dart';
import 'package:shiharainu/shared/widgets/global_navigation_wrapper.dart';
import 'package:shiharainu/shared/animations/page_transitions.dart';
import 'package:shiharainu/shared/router/app_router_redirect.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Shiharainu - イベント支払い管理',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: _createRouter(ref),
      debugShowCheckedModeBanner: false,
    );
  }

  static GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) =>
          AppRouterRedirect.handleRedirect(context, state, ref),
      refreshListenable: GoRouterRefreshStream([
        ref.read(authServiceProvider).authStateChanges,
        // ignore: deprecated_member_use
        ref.read(hasUserProfileProvider.stream),
      ]),
      routes: [
        // ルートパス（リダイレクト専用）
        GoRoute(
          path: '/',
          name: 'root',
          builder: (context, state) =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
        // ログインページ（ナビゲーション非表示）
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/profile-setup',
          name: 'profile-setup',
          builder: (context, state) => const UserProfileSetupPage(),
        ),
        // 招待リンク受け入れページ（ナビゲーション非表示）
        GoRoute(
          path: '/invite/:inviteCode',
          name: 'invite',
          builder: (context, state) {
            final inviteCode = state.pathParameters['inviteCode']!;
            return InviteAcceptPage(inviteCode: inviteCode);
          },
        ),
        // メイン機能（グローバルナビゲーション表示）
        ShellRoute(
          builder: (context, state, child) {
            return GlobalNavigationWrapper(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const HomePage(),
                    name: 'home',
                    transitionType: PageTransitionType.fade,
                  ),
            ),
            GoRoute(
              path: '/guest/promotion',
              name: 'guest-promotion',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const GuestPromotionPage(),
                    name: 'guest-promotion',
                    transitionType: PageTransitionType.fade,
                  ),
            ),
            GoRoute(
              path: '/events',
              name: 'events',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const EventsPage(),
                    name: 'events',
                    transitionType: PageTransitionType.fade,
                  ),
              routes: [
                GoRoute(
                  path: 'create',
                  name: 'event-creation',
                  pageBuilder: (context, state) =>
                      AppPageTransitions.buildPageWithTransition(
                        child: const EventCreationPage(),
                        name: 'event-creation',
                        transitionType: PageTransitionType.slideUp,
                      ),
                ),
                GoRoute(
                  path: ':eventId',
                  name: 'event-detail',
                  pageBuilder: (context, state) {
                    final eventId = state.pathParameters['eventId']!;
                    return AppPageTransitions.buildPageWithTransition(
                      child: EventDetailPage(eventId: eventId),
                      name: 'event-detail',
                      transitionType: PageTransitionType.slide,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'participants',
                      name: 'event-participants',
                      pageBuilder: (context, state) {
                        final eventId = state.pathParameters['eventId']!;
                        return AppPageTransitions.buildPageWithTransition(
                          child: EventParticipantManagementPage(
                            eventId: eventId,
                          ),
                          name: 'event-participants',
                          transitionType: PageTransitionType.slide,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'payments',
                      name: 'event-payments',
                      pageBuilder: (context, state) {
                        final eventId = state.pathParameters['eventId']!;
                        return AppPageTransitions.buildPageWithTransition(
                          child: EventPaymentManagementPage(eventId: eventId),
                          name: 'event-payments',
                          transitionType: PageTransitionType.slide,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'settings',
                      name: 'event-settings',
                      pageBuilder: (context, state) {
                        final eventId = state.pathParameters['eventId']!;
                        return AppPageTransitions.buildPageWithTransition(
                          child: EventSettingsPage(eventId: eventId),
                          name: 'event-settings',
                          transitionType: PageTransitionType.slideUp,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            // グローバル支払い管理ページ（今後実装予定）
            // 現在は各イベントごとの支払い管理（/events/:eventId/payments）を使用
            GoRoute(
              path: '/payment-management',
              name: 'payment-management',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const Scaffold(
                      body: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.construction,
                                size: 64,
                                color: AppTheme.mutedForeground,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'グローバル支払い管理ページ（準備中）',
                                style: AppTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '各イベントの支払い管理は、イベント詳細ページからアクセスできます。',
                                style: AppTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    name: 'payment-management',
                    transitionType: PageTransitionType.fade,
                  ),
            ),
            // 通知ページ
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const NotificationsPage(),
                    name: 'notifications',
                    transitionType: PageTransitionType.fade,
                  ),
            ),
            // アカウント情報ページ
            GoRoute(
              path: '/account',
              name: 'account',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const AccountPage(),
                    name: 'account',
                    transitionType: PageTransitionType.fade,
                  ),
            ),
            // プロフィール編集ページ
            GoRoute(
              path: '/profile-edit',
              name: 'profile-edit',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const UserProfileEditPage(),
                    name: 'profile-edit',
                    transitionType: PageTransitionType.slideUp,
                  ),
            ),
            // アプリ情報ページ
            GoRoute(
              path: '/app-info',
              name: 'app-info',
              pageBuilder: (context, state) =>
                  AppPageTransitions.buildPageWithTransition(
                    child: const AppInfoPage(),
                    name: 'app-info',
                    transitionType: PageTransitionType.slide,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

// GoRouterのリフレッシュ機能のためのStream変換クラス
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    _subscriptions = streams.map((stream) {
      return stream.listen((_) {
        notifyListeners();
      });
    }).toList();
  }

  late final List<StreamSubscription> _subscriptions;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

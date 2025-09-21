import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/pages/login_page.dart';
import 'package:shiharainu/pages/signup_page.dart';
import 'package:shiharainu/pages/user_profile_setup_page.dart';
import 'package:shiharainu/pages/event_creation_page.dart';
import 'package:shiharainu/pages/component_showcase_page.dart';
import 'package:shiharainu/pages/home_page.dart';
import 'package:shiharainu/pages/events_page.dart';
import 'package:shiharainu/pages/event_detail_page.dart';
import 'package:shiharainu/pages/event_payment_management_page.dart';
import 'package:shiharainu/pages/event_settings_page.dart';
import 'package:shiharainu/pages/account_page.dart';
import 'package:shiharainu/pages/user_profile_edit_page.dart';
import 'package:shiharainu/pages/app_info_page.dart';
import 'package:shiharainu/pages/notifications_page.dart';
import 'package:shiharainu/shared/widgets/global_navigation_wrapper.dart';
import 'package:shiharainu/shared/animations/page_transitions.dart';

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
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isLoggedIn = authState.value != null;
        final currentPath = state.matchedLocation;

        AppLogger.navigation('リダイレクト処理: ログイン状態: $isLoggedIn', route: currentPath);

        // 未ログインの場合
        if (!isLoggedIn) {
          // ログイン・サインアップ以外はログインページにリダイレクト
          if (currentPath != '/login' && currentPath != '/signup') {
            AppLogger.navigation('未ログインのため/loginにリダイレクト', route: currentPath);
            return '/login';
          }
          return null; // ログイン・サインアップページは表示
        }

        // ログイン済みの場合
        AppLogger.navigation('ログイン済み、プロフィール確認中...', route: currentPath);
        final hasProfileAsync = ref.read(hasUserProfileProvider);

        return hasProfileAsync.when(
          data: (hasProfile) {
            AppLogger.navigation('プロフィール存在: $hasProfile', route: currentPath);

            // プロフィールが存在する場合
            if (hasProfile) {
              // ログイン・サインアップ・プロフィール設定ページの場合はホームにリダイレクト
              if (currentPath == '/login' ||
                  currentPath == '/signup' ||
                  currentPath == '/profile-setup' ||
                  currentPath == '/') {
                AppLogger.navigation('プロフィール設定済み、/homeにリダイレクト', route: currentPath);
                return '/home';
              }
              return null; // その他のページは表示
            }
            // プロフィールが存在しない場合
            else {
              // プロフィール設定ページ以外はプロフィール設定にリダイレクト
              if (currentPath != '/profile-setup') {
                AppLogger.navigation('プロフィール未設定、/profile-setupにリダイレクト', route: currentPath);
                return '/profile-setup';
              }
              return null; // プロフィール設定ページは表示
            }
          },
          loading: () {
            AppLogger.navigation('プロフィール情報ローディング中', route: currentPath);
            // ローディング中はログイン・サインアップページ以外はホームに飛ばす
            if (currentPath == '/login' || currentPath == '/signup') {
              return '/home';
            }
            return null;
          },
          error: (error, stack) {
            AppLogger.error('プロフィール情報取得エラー', name: 'Router', error: error);
            // エラー時はホームに飛ばす
            if (currentPath == '/login' ||
                currentPath == '/signup' ||
                currentPath == '/') {
              return '/home';
            }
            return null;
          },
        );
      },
      refreshListenable: GoRouterRefreshStream(
        ref.read(authServiceProvider).authStateChanges,
      ),
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
        // デバッグ用ページ（ナビゲーション非表示）
        GoRoute(
          path: '/components',
          name: 'components',
          builder: (context, state) => const ComponentShowcasePage(),
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
              pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
                child: const HomePage(),
                name: 'home',
                transitionType: PageTransitionType.slideWithFade,
              ),
            ),
            GoRoute(
              path: '/events',
              name: 'events',
              pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
                child: const EventsPage(),
                name: 'events',
                transitionType: PageTransitionType.slideWithFade,
              ),
              routes: [
                GoRoute(
                  path: 'create',
                  name: 'event-creation',
                  pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
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
            // 支払い管理ページ（今後実装）
            GoRoute(
              path: '/payment-management',
              name: 'payment-management',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('支払い管理ページ（準備中）'))),
            ),
            // 通知ページ
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
                child: const NotificationsPage(),
                name: 'notifications',
                transitionType: PageTransitionType.slide,
              ),
            ),
            // アカウント情報ページ
            GoRoute(
              path: '/account',
              name: 'account',
              pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
                child: const AccountPage(),
                name: 'account',
                transitionType: PageTransitionType.slide,
              ),
            ),
            // プロフィール編集ページ
            GoRoute(
              path: '/profile-edit',
              name: 'profile-edit',
              pageBuilder: (context, state) => AppPageTransitions.buildPageWithTransition(
                child: const UserProfileEditPage(),
                name: 'profile-edit',
                transitionType: PageTransitionType.slideUp,
              ),
            ),
            // アプリ情報ページ
            GoRoute(
              path: '/app-info',
              name: 'app-info',
              builder: (context, state) => const AppInfoPage(),
            ),
          ],
        ),
      ],
    );
  }
}

// GoRouterのリフレッシュ機能のためのStream変換クラス
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

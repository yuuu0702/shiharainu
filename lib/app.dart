import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/pages/dashboard_page.dart';
import 'package:shiharainu/pages/login_page.dart';
import 'package:shiharainu/pages/event_creation_page.dart';
import 'package:shiharainu/pages/component_showcase_page.dart';
import 'package:shiharainu/pages/home_page.dart';
import 'package:shiharainu/pages/events_page.dart';
import 'package:shiharainu/pages/event_detail_page.dart';
import 'package:shiharainu/pages/event_payment_management_page.dart';
import 'package:shiharainu/pages/event_settings_page.dart';
import 'package:shiharainu/shared/widgets/global_navigation_wrapper.dart';

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
      initialLocation: '/home',
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isLoggedIn = authState.value != null;
        final isLoginPage = state.matchedLocation == '/login';

        // 未ログインで、ログインページ以外にアクセスしようとした場合はログインページにリダイレクト
        if (!isLoggedIn && !isLoginPage) {
          return '/login';
        }
        
        // ログイン済みで、ログインページにアクセスしようとした場合はホームにリダイレクト
        if (isLoggedIn && isLoginPage) {
          return '/home';
        }

        return null; // リダイレクトなし
      },
      refreshListenable: GoRouterRefreshStream(
        ref.read(authServiceProvider).authStateChanges,
      ),
      routes: [
        // ログインページ（ナビゲーション非表示）
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
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
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/events',
              name: 'events',
              builder: (context, state) => const EventsPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  name: 'event-creation',
                  builder: (context, state) => const EventCreationPage(),
                ),
                GoRoute(
                  path: ':eventId',
                  name: 'event-detail',
                  builder: (context, state) {
                    final eventId = state.pathParameters['eventId']!;
                    return EventDetailPage(eventId: eventId);
                  },
                  routes: [
                    GoRoute(
                      path: 'payments',
                      name: 'event-payments',
                      builder: (context, state) {
                        final eventId = state.pathParameters['eventId']!;
                        return EventPaymentManagementPage(eventId: eventId);
                      },
                    ),
                    GoRoute(
                      path: 'settings',
                      name: 'event-settings',
                      builder: (context, state) {
                        final eventId = state.pathParameters['eventId']!;
                        return EventSettingsPage(eventId: eventId);
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
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('支払い管理ページ（準備中）'),
                ),
              ),
            ),
            // 通知ページ（今後実装）
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('通知ページ（準備中）'),
                ),
              ),
            ),
            // アカウント情報ページ（今後実装）
            GoRoute(
              path: '/account',
              name: 'account',
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('アカウント情報ページ（準備中）'),
                ),
              ),
            ),
            // デバッグ用：既存のダッシュボードを一時保持
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
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

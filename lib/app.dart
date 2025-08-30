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
import 'package:shiharainu/pages/event_list_page.dart';
import 'package:shiharainu/pages/event_detail_page.dart';
import 'package:shiharainu/pages/event_payment_management_page.dart';
import 'package:shiharainu/pages/event_settings_page.dart';

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
      initialLocation: '/events',
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isLoggedIn = authState.value != null;
        final isLoginPage = state.matchedLocation == '/login';

        // 未ログインで、ログインページ以外にアクセスしようとした場合はログインページにリダイレクト
        if (!isLoggedIn && !isLoginPage) {
          return '/login';
        }
        
        // ログイン済みで、ログインページにアクセスしようとした場合はイベント一覧にリダイレクト
        if (isLoggedIn && isLoginPage) {
          return '/events';
        }

        return null; // リダイレクトなし
      },
      refreshListenable: GoRouterRefreshStream(
        ref.read(authServiceProvider).authStateChanges,
      ),
      routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventListPage(),
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
      // デバッグ用：既存のダッシュボードを一時保持
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/components',
        name: 'components',
        builder: (context, state) => const ComponentShowcasePage(),
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

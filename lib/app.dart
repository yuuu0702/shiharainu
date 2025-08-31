import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/pages/dashboard_page.dart';
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
      initialLocation: '/',
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isLoggedIn = authState.value != null;
        final currentPath = state.matchedLocation;
        
        print('[Router] リダイレクト処理: $currentPath, ログイン状態: $isLoggedIn');

        // 未ログインの場合
        if (!isLoggedIn) {
          // ログイン・サインアップ以外はログインページにリダイレクト
          if (currentPath != '/login' && currentPath != '/signup') {
            print('[Router] 未ログインのため/loginにリダイレクト');
            return '/login';
          }
          return null; // ログイン・サインアップページは表示
        }

        // ログイン済みの場合
        print('[Router] ログイン済み、プロフィール確認中...');
        final hasProfileAsync = ref.read(hasUserProfileProvider);
        
        return hasProfileAsync.when(
          data: (hasProfile) {
            print('[Router] プロフィール存在: $hasProfile');
            
            // プロフィールが存在する場合
            if (hasProfile) {
              // ログイン・サインアップ・プロフィール設定ページの場合はホームにリダイレクト
              if (currentPath == '/login' || currentPath == '/signup' || currentPath == '/profile-setup' || currentPath == '/') {
                print('[Router] プロフィール設定済み、/homeにリダイレクト');
                return '/home';
              }
              return null; // その他のページは表示
            } 
            // プロフィールが存在しない場合
            else {
              // プロフィール設定ページ以外はプロフィール設定にリダイレクト
              if (currentPath != '/profile-setup') {
                print('[Router] プロフィール未設定、/profile-setupにリダイレクト');
                return '/profile-setup';
              }
              return null; // プロフィール設定ページは表示
            }
          },
          loading: () {
            print('[Router] プロフィール情報ローディング中');
            // ローディング中はログイン・サインアップページ以外はホームに飛ばす
            if (currentPath == '/login' || currentPath == '/signup') {
              return '/home';
            }
            return null;
          },
          error: (error, stack) {
            print('[Router] プロフィール情報取得エラー: $error');
            // エラー時はホームに飛ばす
            if (currentPath == '/login' || currentPath == '/signup' || currentPath == '/') {
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
          builder: (context, state) => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
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
            // アカウント情報ページ
            GoRoute(
              path: '/account',
              name: 'account',
              builder: (context, state) => const AccountPage(),
            ),
            // プロフィール編集ページ
            GoRoute(
              path: '/profile-edit',
              name: 'profile-edit',
              builder: (context, state) => const UserProfileEditPage(),
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

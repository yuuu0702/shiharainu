import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/services/auth_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

/// アプルーティングのリダイレクトロジック
class AppRouterRedirect {
  /// リダイレクト処理を実行
  static String? handleRedirect(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) {
    final authState = ref.read(authStateProvider);
    final isLoggedIn = authState.value != null;
    final currentPath = state.matchedLocation;

    AppLogger.navigation('リダイレクト処理: ログイン状態: $isLoggedIn', route: currentPath);

    // 未ログインの場合
    if (!isLoggedIn) {
      // ログイン・サインアップ・招待ページ以外はログインページにリダイレクト
      if (currentPath != '/login' &&
          currentPath != '/signup' &&
          !currentPath.startsWith('/invite')) {
        AppLogger.navigation('未ログインのため/loginにリダイレクト', route: currentPath);
        return '/login';
      }
      return null; // ログイン・サインアップ・招待ページは表示
    }

    // ログイン済みの場合
    AppLogger.navigation('ログイン済み、プロフィール確認中...', route: currentPath);
    // ignore: deprecated_member_use
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
          // プロフィール設定ページ、招待ページ以外はプロフィール設定にリダイレクト
          if (currentPath != '/profile-setup' &&
              !currentPath.startsWith('/invite')) {
            AppLogger.navigation(
              'プロフィール未設定、/profile-setupにリダイレクト',
              route: currentPath,
            );
            return '/profile-setup?redirect=${Uri.encodeComponent(currentPath)}';
          }
          return null; // プロフィール設定ページ、招待ページは表示
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
  }
}

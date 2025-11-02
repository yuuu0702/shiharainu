import 'dart:developer' as developer;

/// アプリケーション共通のログユーティリティ
///
/// Effective Dartに準拠し、本番環境では適切にログ出力を制御
class AppLogger {
  static const String _defaultName = 'Shiharainu';

  /// デバッグレベルのログ出力
  ///
  /// [message] ログメッセージ
  /// [name] ログの識別名（デフォルト: 'Shiharainu'）
  /// [error] エラーオブジェクト（オプション）
  /// [stackTrace] スタックトレース（オプション）
  static void debug(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 500, // Debug level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 情報レベルのログ出力
  ///
  /// [message] ログメッセージ
  /// [name] ログの識別名（デフォルト: 'Shiharainu'）
  static void info(
    String message, {
    String? name,
  }) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 800, // Info level
    );
  }

  /// 警告レベルのログ出力
  ///
  /// [message] ログメッセージ
  /// [name] ログの識別名（デフォルト: 'Shiharainu'）
  /// [error] エラーオブジェクト（オプション）
  static void warning(
    String message, {
    String? name,
    Object? error,
  }) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 900, // Warning level
      error: error,
    );
  }

  /// エラーレベルのログ出力
  ///
  /// [message] ログメッセージ
  /// [name] ログの識別名（デフォルト: 'Shiharainu'）
  /// [error] エラーオブジェクト（必須）
  /// [stackTrace] スタックトレース（オプション）
  static void error(
    String message, {
    String? name,
    required Object error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// ナビゲーション関連のログ出力
  ///
  /// [message] ログメッセージ
  /// [route] ルート名（オプション）
  static void navigation(
    String message, {
    String? route,
  }) {
    final logMessage = route != null ? '[$route] $message' : message;
    developer.log(
      logMessage,
      name: '${_defaultName}Navigation',
      level: 800,
    );
  }

  /// 認証関連のログ出力
  ///
  /// [message] ログメッセージ
  /// [userId] ユーザーID（オプション）
  static void auth(
    String message, {
    String? userId,
  }) {
    final logMessage = userId != null ? '[User:$userId] $message' : message;
    developer.log(
      logMessage,
      name: '${_defaultName}Auth',
      level: 800,
    );
  }

  /// データベース関連のログ出力
  ///
  /// [message] ログメッセージ
  /// [operation] オペレーション名（オプション）
  static void database(
    String message, {
    String? operation,
  }) {
    final logMessage = operation != null ? '[$operation] $message' : message;
    developer.log(
      logMessage,
      name: '${_defaultName}Database',
      level: 800,
    );
  }
}
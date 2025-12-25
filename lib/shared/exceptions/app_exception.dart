abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';

  /// ユーザー向けのエラーメッセージを取得
  String get userMessage {
    // 基本的なメッセージを返す。サブクラスでオーバーライド可能。
    return message;
  }
}

/// 通信エラー
class AppNetworkException extends AppException {
  const AppNetworkException([
    super.message = '通信エラーが発生しました',
    dynamic originalError,
  ]) : super(code: 'network_error', originalError: originalError);

  @override
  String get userMessage => 'インターネット接続を確認してください。';
}

/// 認証エラー
class AppAuthException extends AppException {
  const AppAuthException(super.message, {super.code, super.originalError});
}

/// バリデーションエラー
class AppValidationException extends AppException {
  const AppValidationException(
    super.message, {
    String? code,
    super.originalError,
  }) : super(code: code ?? 'validation_error');
}

/// 予期せぬエラー
class AppUnknownException extends AppException {
  const AppUnknownException([
    super.message = '予期せぬエラーが発生しました',
    dynamic originalError,
  ]) : super(code: 'unknown_error', originalError: originalError);

  @override
  String get userMessage => '予期せぬエラーが発生しました。しばらく経ってから再度お試しください。';
}

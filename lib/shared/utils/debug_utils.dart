import 'package:flutter/foundation.dart';

class DebugUtils {
  /// デバッグモードかどうかを判定する
  static bool get isDebugMode => kDebugMode;

  /// テスト用のユーザー認証情報
  static const String testEmail = 'test@test.com';
  static const String testPassword = 'test01';
}

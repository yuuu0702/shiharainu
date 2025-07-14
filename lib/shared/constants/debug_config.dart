import 'package:flutter/foundation.dart';

class DebugConfig {
  static const bool isDebugMode = kDebugMode;
  
  // テストユーザー情報
  static const String testOrganizerEmail = 'organizer@test.com';
  static const String testOrganizerPassword = 'test123456';
  static const String testOrganizerName = 'テスト幹事';
  
  static const String testParticipantEmail = 'participant@test.com';
  static const String testParticipantPassword = 'test123456';
  static const String testParticipantName = 'テスト参加者';
  
  // デバッグ用設定
  static const bool enableAutoLogin = true;
  static const bool skipOnboarding = true;
  static const bool enableMockPayment = true;
  
  // テストイベント情報
  static const String testEventTitle = 'デバッグ用忘年会';
  static const String testEventDescription = 'テスト用のイベントです';
  static const String testEventVenue = 'テスト会場';
  static const double testEventAmount = 5000.0;
}
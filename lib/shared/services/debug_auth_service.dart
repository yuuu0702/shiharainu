import 'package:shiharainu/shared/constants/debug_config.dart';
import 'package:shiharainu/shared/models/user_model.dart';

class DebugAuthService {
  static UserModel? _currentUser;
  
  static UserModel? get currentUser => _currentUser;
  
  static bool get isLoggedIn => _currentUser != null;
  
  /// テスト幹事としてログイン
  static Future<UserModel> loginAsOrganizer() async {
    await Future.delayed(const Duration(milliseconds: 500)); // リアルなログイン時間をシミュレート
    
    _currentUser = UserModel(
      id: 'test_organizer_001',
      name: DebugConfig.testOrganizerName,
      email: DebugConfig.testOrganizerEmail,
      role: UserRole.organizer,
      position: '課長',
      branch: '東京支店',
      age: '35',
      gender: 'male',
      isDrinking: true,
      isGuest: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return _currentUser!;
  }
  
  /// テスト参加者としてログイン
  static Future<UserModel> loginAsParticipant() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = UserModel(
      id: 'test_participant_001',
      name: DebugConfig.testParticipantName,
      email: DebugConfig.testParticipantEmail,
      role: UserRole.participant,
      position: '係長',
      branch: '東京支店',
      age: '28',
      gender: 'female',
      isDrinking: false,
      isGuest: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return _currentUser!;
  }
  
  /// ゲストとしてログイン
  static Future<UserModel> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = UserModel(
      id: 'test_guest_001',
      name: 'ゲストユーザー',
      email: 'guest@test.com',
      role: UserRole.guest,
      isDrinking: true,
      isGuest: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return _currentUser!;
  }
  
  /// 通常のログイン（メール・パスワード）
  static Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // テストユーザーかどうかをチェック
    if (email == DebugConfig.testOrganizerEmail && 
        password == DebugConfig.testOrganizerPassword) {
      return await loginAsOrganizer();
    }
    
    if (email == DebugConfig.testParticipantEmail && 
        password == DebugConfig.testParticipantPassword) {
      return await loginAsParticipant();
    }
    
    // 実際のアプリでは、ここでFirebase Authenticationを使用
    return null;
  }
  
  /// ログアウト
  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
  
  /// ユーザー情報の更新
  static void updateUser(UserModel user) {
    _currentUser = user;
  }
}
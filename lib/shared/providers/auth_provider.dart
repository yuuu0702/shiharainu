import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiharainu/shared/models/user_model.dart';
import 'package:shiharainu/shared/services/debug_auth_service.dart';

// 認証状態を管理するStateNotifier
class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null);
  
  Future<bool> login(String email, String password) async {
    try {
      final user = await DebugAuthService.login(email, password);
      if (user != null) {
        state = user;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> loginAsOrganizer() async {
    final user = await DebugAuthService.loginAsOrganizer();
    state = user;
  }
  
  Future<void> loginAsParticipant() async {
    final user = await DebugAuthService.loginAsParticipant();
    state = user;
  }
  
  Future<void> loginAsGuest() async {
    final user = await DebugAuthService.loginAsGuest();
    state = user;
  }
  
  Future<void> logout() async {
    await DebugAuthService.logout();
    state = null;
  }
  
  void updateUser(UserModel user) {
    DebugAuthService.updateUser(user);
    state = user;
  }
}

// 認証状態のプロバイダー
final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

// 現在のユーザー情報を取得するプロバイダー
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider);
});

// ログイン状態を取得するプロバイダー
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});

// ユーザーの役割を取得するプロバイダー
final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authProvider)?.role;
});

// 幹事かどうかを判定するプロバイダー
final isOrganizerProvider = Provider<bool>((ref) {
  return ref.watch(authProvider)?.role == UserRole.organizer;
});
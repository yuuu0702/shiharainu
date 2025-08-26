import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiharainu/shared/models/user_model.dart';
import 'package:shiharainu/shared/services/debug_auth_service.dart';

// AuthViewModelクラス - 従来のStateNotifierアプローチ
class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  AuthViewModel() : super(const AsyncValue.data(null));

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      final user = await DebugAuthService.login(email, password);
      if (user != null) {
        state = AsyncValue.data(user);
        return true;
      }
      state = const AsyncValue.data(null);
      return false;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<void> loginAsOrganizer() async {
    state = const AsyncValue.loading();
    
    try {
      final user = await DebugAuthService.loginAsOrganizer();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loginAsParticipant() async {
    state = const AsyncValue.loading();
    
    try {
      final user = await DebugAuthService.loginAsParticipant();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loginAsGuest() async {
    state = const AsyncValue.loading();
    
    try {
      final user = await DebugAuthService.loginAsGuest();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    await DebugAuthService.logout();
    state = const AsyncValue.data(null);
  }

  void updateUser(UserModel user) {
    DebugAuthService.updateUser(user);
    state = AsyncValue.data(user);
  }
}

// プロバイダー定義
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  return AuthViewModel();
});

// 便利なプロバイダー
final isLoggedInProvider = Provider<bool>((ref) {
  final asyncUser = ref.watch(authViewModelProvider);
  return asyncUser.valueOrNull != null;
});

final isOrganizerProvider = Provider<bool>((ref) {
  final asyncUser = ref.watch(authViewModelProvider);
  return asyncUser.valueOrNull?.role == UserRole.organizer;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  final asyncUser = ref.watch(authViewModelProvider);
  return asyncUser.valueOrNull?.role;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final asyncUser = ref.watch(authViewModelProvider);
  return asyncUser.valueOrNull;
});
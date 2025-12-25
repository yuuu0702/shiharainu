import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/exceptions/app_exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'このメールアドレスのユーザーは存在しません';
          break;
        case 'wrong-password':
          message = 'パスワードが間違っています';
          break;
        case 'invalid-email':
          message = 'メールアドレスの形式が正しくありません';
          break;
        case 'too-many-requests':
          message = 'ログインの試行回数が多すぎます。しばらく待ってからもう一度お試しください';
          break;
        case 'user-disabled':
          message = 'このアカウントは無効化されています';
          break;
        default:
          message = 'ログインに失敗しました: ${e.message}';
      }
      throw AppAuthException(message, code: e.code, originalError: e);
    } catch (e) {
      throw AppUnknownException('予期しないエラーが発生しました', e);
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }

      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'パスワードが弱すぎます';
          break;
        case 'email-already-in-use':
          message = 'このメールアドレスは既に使用されています';
          break;
        case 'invalid-email':
          message = 'メールアドレスの形式が正しくありません';
          break;
        default:
          message = 'アカウント作成に失敗しました: ${e.message}';
      }
      throw AppAuthException(message, code: e.code, originalError: e);
    } catch (e) {
      throw AppUnknownException('予期しないエラーが発生しました', e);
    }
  }

  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }

      String message;
      switch (e.code) {
        case 'operation-not-allowed':
          message = 'ゲストログインが無効になっています。管理者に連絡してください。';
          break;
        default:
          message = 'ゲストログインに失敗しました: ${e.message}';
      }
      throw AppAuthException(message, code: e.code, originalError: e);
    } catch (e) {
      throw AppUnknownException('予期しないエラーが発生しました', e);
    }
  }

  Future<UserCredential?> linkWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AppAuthException('ユーザーがログインしていません', code: 'not_logged_in');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      return await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }

      String message;
      switch (e.code) {
        case 'credential-already-in-use':
          message = 'このメールアドレスは既に他のアカウントで使用されています';
          break;
        case 'email-already-in-use':
          message = 'このメールアドレスは既に登録されています';
          break;
        case 'invalid-email':
          message = 'メールアドレスの形式が正しくありません';
          break;
        case 'weak-password':
          message = 'パスワードが弱すぎます';
          break;
        default:
          message = 'アカウント連携に失敗しました: ${e.message}';
      }
      throw AppAuthException(message, code: e.code, originalError: e);
    } catch (e) {
      throw AppUnknownException('予期しないエラーが発生しました', e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }
      throw AppUnknownException('ログアウトに失敗しました', e);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw AppNetworkException('ネットワークエラーが発生しました', e);
      }

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'このメールアドレスのユーザーは存在しません';
          break;
        case 'invalid-email':
          message = 'メールアドレスの形式が正しくありません';
          break;
        default:
          message = 'パスワードリセットメールの送信に失敗しました: ${e.message}';
      }
      throw AppAuthException(message, code: e.code, originalError: e);
    } catch (e) {
      throw AppUnknownException('予期しないエラーが発生しました', e);
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

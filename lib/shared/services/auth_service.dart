import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      switch (e.code) {
        case 'user-not-found':
          throw Exception('このメールアドレスのユーザーは存在しません');
        case 'wrong-password':
          throw Exception('パスワードが間違っています');
        case 'invalid-email':
          throw Exception('メールアドレスの形式が正しくありません');
        case 'too-many-requests':
          throw Exception('ログインの試行回数が多すぎます。しばらく待ってからもう一度お試しください');
        case 'network-request-failed':
          throw Exception('ネットワークエラーが発生しました。インターネット接続を確認してください');
        default:
          throw Exception('ログインに失敗しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期しないエラーが発生しました: $e');
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
      switch (e.code) {
        case 'weak-password':
          throw Exception('パスワードが弱すぎます');
        case 'email-already-in-use':
          throw Exception('このメールアドレスは既に使用されています');
        case 'invalid-email':
          throw Exception('メールアドレスの形式が正しくありません');
        default:
          throw Exception('アカウント作成に失敗しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期しないエラーが発生しました: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('ログアウトに失敗しました: $e');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('このメールアドレスのユーザーは存在しません');
        case 'invalid-email':
          throw Exception('メールアドレスの形式が正しくありません');
        default:
          throw Exception('パスワードリセットメールの送信に失敗しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期しないエラーが発生しました: $e');
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
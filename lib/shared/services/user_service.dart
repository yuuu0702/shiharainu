import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:shiharainu/shared/models/user_profile.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';
import 'package:shiharainu/shared/services/cache_service.dart';

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CacheService? _cacheService;

  UserService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    CacheService? cacheService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _cacheService = cacheService;

  Future<void> saveUserProfile({
    required String name,
    required int age,
    required String position,
  }) async {
    try {
      AppLogger.database('保存処理開始', operation: 'saveUserProfile');
      final user = _auth.currentUser;
      if (user == null) {
        AppLogger.auth('エラー: ユーザーがログインしていません');
        throw Exception('ユーザーがログインしていません');
      }

      AppLogger.auth('ログイン中のユーザー', userId: user.uid);
      AppLogger.debug('ユーザーメール: ${user.email}', name: 'UserService');

      final userProfile = UserProfile(
        id: user.uid,
        name: name,
        age: age,
        position: position,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      AppLogger.debug(
        'UserProfile作成完了: ${userProfile.toJson()}',
        name: 'UserService',
      );
      AppLogger.database('Firestoreに保存中...', operation: 'saveUserProfile');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson());

      // キャッシュにも保存
      if (_cacheService != null) {
        await _cacheService.cacheUserProfile(userProfile.toJson());
        AppLogger.debug('ユーザープロフィールをキャッシュに保存', name: 'UserService');
      }

      AppLogger.database('Firestore保存完了', operation: 'saveUserProfile');
    } catch (e) {
      AppLogger.error('エラー発生', name: 'UserService', error: e);
      AppLogger.debug('エラータイプ: ${e.runtimeType}', name: 'UserService');
      throw Exception('ユーザー情報の保存に失敗しました: $e');
    }
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      // まずキャッシュから取得を試行
      if (_cacheService != null) {
        final cachedProfile = await _cacheService.getCachedUserProfile();
        if (cachedProfile != null) {
          AppLogger.debug('キャッシュからユーザープロフィール取得', name: 'UserService');
          return UserProfile.fromJson(cachedProfile);
        }
      }

      // キャッシュにない場合はFirestoreから取得
      AppLogger.database(
        'Firestoreからユーザープロフィール取得',
        operation: 'getUserProfile',
      );
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        return null;
      }

      final profile = UserProfile.fromJson(doc.data()!);

      // 取得したデータをキャッシュに保存
      if (_cacheService != null) {
        await _cacheService.cacheUserProfile(profile.toJson());
        AppLogger.debug('取得したユーザープロフィールをキャッシュに保存', name: 'UserService');
      }

      return profile;
    } catch (e) {
      AppLogger.error('ユーザープロフィール取得エラー', name: 'UserService', error: e);
      throw Exception('ユーザー情報の取得に失敗しました: $e');
    }
  }

  Future<bool> hasUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required int age,
    required String position,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ユーザーがログインしていません');
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'age': age,
        'position': position,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // キャッシュをクリア（次回取得時に最新データを取得するため）
      if (_cacheService != null) {
        await _cacheService.clearCache('cached_user_profile');
        AppLogger.debug('ユーザープロフィール更新によりキャッシュをクリア', name: 'UserService');
      }
    } catch (e) {
      throw Exception('ユーザー情報の更新に失敗しました: $e');
    }
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  // キャッシュサービスを注入（利用可能な場合）
  try {
    final cacheService = ref.watch(cacheServiceInitProvider).value;
    return UserService(cacheService: cacheService);
  } catch (e) {
    // キャッシュサービスが利用できない場合は通常のUserServiceを返す
    return UserService();
  }
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    try {
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  });
});

final hasUserProfileProvider = StreamProvider<bool>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) return false;

    try {
      final doc = await firestore.collection('users').doc(user.uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  });
});

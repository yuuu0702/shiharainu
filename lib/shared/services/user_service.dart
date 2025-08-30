import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:shiharainu/shared/models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> saveUserProfile({
    required String name,
    required int age,
    required String position,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ユーザーがログインしていません');
      }

      final userProfile = UserProfile(
        id: user.uid,
        name: name,
        age: age,
        position: position,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson());
    } catch (e) {
      throw Exception('ユーザー情報の保存に失敗しました: $e');
    }
  }

  Future<UserProfile?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserProfile.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('ユーザー情報の取得に失敗しました: $e');
    }
  }

  Future<bool> hasUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

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

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'age': age,
        'position': position,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('ユーザー情報の更新に失敗しました: $e');
    }
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
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
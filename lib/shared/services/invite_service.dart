import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

/// 招待リンクの生成・管理・共有を行うサービスクラス
class InviteService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  InviteService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// 招待コードを生成してFirestoreに保存
  ///
  /// [eventId] イベントID
  /// Returns: 生成された招待コード (例: evt_a1b2c3d4)
  Future<String> generateInviteCode(String eventId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ログインが必要です');
      }

      // ランダムな8文字の招待コードを生成
      final random = Random.secure();
      final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      final code =
          List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
      final inviteCode = 'evt_$code';

      // Firestoreに招待コード情報を保存
      await _firestore.collection('inviteCodes').doc(inviteCode).set({
        'eventId': eventId,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'usageCount': 0,
      });

      // イベントドキュメントにも招待コードを保存
      await _firestore.collection('events').doc(eventId).update({
        'inviteCode': inviteCode,
      });

      AppLogger.info(
        '招待コード生成成功: inviteCode=$inviteCode, eventId=$eventId',
        name: 'InviteService',
      );

      return inviteCode;
    } catch (e, stackTrace) {
      AppLogger.error('招待コード生成エラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 既存の招待コードを取得、存在しない場合は新規生成
  ///
  /// [eventId] イベントID
  /// Returns: 招待コード
  Future<String> getOrCreateInviteCode(String eventId) async {
    try {
      // イベントドキュメントから既存の招待コードを取得
      final eventDoc =
          await _firestore.collection('events').doc(eventId).get();

      if (!eventDoc.exists) {
        throw Exception('イベントが見つかりません');
      }

      final eventData = eventDoc.data()!;
      final existingCode = eventData['inviteCode'] as String?;

      // 既存の招待コードがあればそれを返す
      if (existingCode != null && existingCode.isNotEmpty) {
        AppLogger.info(
          '既存の招待コード使用: inviteCode=$existingCode',
          name: 'InviteService',
        );
        return existingCode;
      }

      // なければ新規生成
      return await generateInviteCode(eventId);
    } catch (e, stackTrace) {
      AppLogger.error('招待コード取得エラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 招待リンクを生成
  ///
  /// [inviteCode] 招待コード
  /// Returns: 招待リンクURL
  String generateInviteLink(String inviteCode) {
    // 本番環境では実際のドメインに変更
    // TODO: 環境変数から取得するように修正
    const baseUrl = kIsWeb
        ? '' // Webの場合は相対パス
        : 'https://shiharainu.app'; // モバイルの場合は絶対パス

    final link = '$baseUrl/invite/$inviteCode';

    AppLogger.info(
      '招待リンク生成: link=$link',
      name: 'InviteService',
    );

    return link;
  }

  /// 招待リンクをクリップボードにコピー
  ///
  /// [inviteLink] 招待リンク
  Future<void> copyInviteLinkToClipboard(String inviteLink) async {
    try {
      await Clipboard.setData(ClipboardData(text: inviteLink));
      AppLogger.info('クリップボードコピー成功', name: 'InviteService');
    } catch (e, stackTrace) {
      AppLogger.error('クリップボードコピーエラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 招待リンクをシェア（Web/Mobile対応）
  ///
  /// [eventTitle] イベントタイトル
  /// [inviteLink] 招待リンク
  Future<void> shareInviteLink({
    required String eventTitle,
    required String inviteLink,
  }) async {
    try {
      // 将来的にshare_plusパッケージを使用する際のメッセージテンプレート
      // final message = '''
      // $eventTitle に招待されました！
      //
      // 以下のリンクから参加できます：
      // $inviteLink
      //
      // しはらいぬ - イベント支払い管理アプリ
      // ''';

      if (kIsWeb) {
        // Web環境: クリップボードにコピー
        await Clipboard.setData(ClipboardData(text: inviteLink));
        AppLogger.info('Web: クリップボードコピー', name: 'InviteService');

        // Web Share API を使用する場合（将来的に実装）
        // try {
        //   await html.window.navigator.share({
        //     'title': eventTitle,
        //     'text': message,
        //     'url': inviteLink,
        //   });
        // } catch (e) {
        //   // Web Share API非対応の場合はクリップボードコピー
        //   await Clipboard.setData(ClipboardData(text: inviteLink));
        // }
      } else {
        // Mobile環境: 暫定的にクリップボードコピー
        // share_plus パッケージを追加した際は以下に置き換え:
        // await Share.share(message, subject: eventTitle);
        await Clipboard.setData(ClipboardData(text: inviteLink));
        AppLogger.info('Mobile: クリップボードコピー', name: 'InviteService');
      }
    } catch (e, stackTrace) {
      AppLogger.error('シェアエラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 招待コードからイベントIDを取得
  ///
  /// [inviteCode] 招待コード
  /// Returns: イベントID
  Future<String> getEventIdFromInviteCode(String inviteCode) async {
    try {
      final inviteDoc =
          await _firestore.collection('inviteCodes').doc(inviteCode).get();

      if (!inviteDoc.exists) {
        throw Exception('無効な招待コードです');
      }

      final eventId = inviteDoc.data()!['eventId'] as String;

      AppLogger.info(
        '招待コードからイベントID取得: inviteCode=$inviteCode, eventId=$eventId',
        name: 'InviteService',
      );

      return eventId;
    } catch (e, stackTrace) {
      AppLogger.error('イベントID取得エラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 招待コードの使用回数を増やす
  ///
  /// [inviteCode] 招待コード
  Future<void> incrementUsageCount(String inviteCode) async {
    try {
      await _firestore.collection('inviteCodes').doc(inviteCode).update({
        'usageCount': FieldValue.increment(1),
      });

      AppLogger.info(
        '招待コード使用回数をインクリメント: inviteCode=$inviteCode',
        name: 'InviteService',
      );
    } catch (e, stackTrace) {
      AppLogger.error('使用回数更新エラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      // 使用回数の更新失敗は致命的ではないのでログのみ
    }
  }

  /// 招待コードの有効性を検証
  ///
  /// [inviteCode] 招待コード
  /// Returns: 有効な場合true
  Future<bool> validateInviteCode(String inviteCode) async {
    try {
      final inviteDoc =
          await _firestore.collection('inviteCodes').doc(inviteCode).get();

      final isValid = inviteDoc.exists;

      AppLogger.info(
        '招待コード検証: inviteCode=$inviteCode, isValid=$isValid',
        name: 'InviteService',
      );

      return isValid;
    } catch (e, stackTrace) {
      AppLogger.error('招待コード検証エラー',
          name: 'InviteService', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

// Riverpodプロバイダー定義
final inviteServiceProvider = Provider<InviteService>((ref) {
  return InviteService();
});

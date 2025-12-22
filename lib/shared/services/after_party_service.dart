import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiharainu/shared/models/event_model.dart';

/// 二次会管理サービス
class AfterPartyService {
  final FirebaseFirestore _firestore;

  AfterPartyService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 二次会イベントを作成
  Future<String> createAfterParty({
    required String parentEventId,
    required String title,
    String? description,
    required double totalAmount,
    required PaymentType paymentType,
    List<String>? selectedParticipantIds,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('ログインしていません');
    }

    // 親イベントの存在確認
    final parentEventDoc = await _firestore
        .collection('events')
        .doc(parentEventId)
        .get();

    if (!parentEventDoc.exists) {
      throw Exception('親イベントが見つかりません');
    }

    final parentEventData = parentEventDoc.data()!;

    // 二次会イベント作成
    final afterPartyRef = _firestore.collection('events').doc();
    final inviteCode = _generateInviteCode();
    final now = DateTime.now();

    final afterPartyData = {
      'title': title,
      'description': description ?? '${parentEventData['title']}の二次会',
      'date': parentEventData['date'],
      'totalAmount': totalAmount,
      'paymentType': paymentType.name,
      'organizerIds': parentEventData['organizerIds'],
      'status': EventStatus.planning.name,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'inviteCode': inviteCode,
      'parentEventId': parentEventId,
      'isAfterParty': true,
      'childEventIds': [],
    };

    await afterPartyRef.set(afterPartyData);

    // 親イベントに二次会IDを追加
    await _firestore.collection('events').doc(parentEventId).update({
      'childEventIds': FieldValue.arrayUnion([afterPartyRef.id]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 親イベントの参加者を自動的に二次会にも追加
    await _copyParticipantsToAfterParty(
      parentEventId,
      afterPartyRef.id,
      selectedParticipantIds,
    );

    return afterPartyRef.id;
  }

  /// 親イベントの参加者を二次会にコピー
  Future<void> _copyParticipantsToAfterParty(
    String parentEventId,
    String afterPartyId,
    List<String>? selectedParticipantIds,
  ) async {
    final participantsSnapshot = await _firestore
        .collection('events')
        .doc(parentEventId)
        .collection('participants')
        .get();

    if (participantsSnapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final doc in participantsSnapshot.docs) {
      // 選択された参加者リストが指定されていて、かつそのリストに含まれていない場合はスキップ
      if (selectedParticipantIds != null &&
          !selectedParticipantIds.contains(doc.data()['userId'])) {
        continue;
      }
      final participantRef = _firestore
          .collection('events')
          .doc(afterPartyId)
          .collection('participants')
          .doc(doc.id);

      final participantData = doc.data();

      // 主催者（作成者）は「支払い済み」、その他は「未払い」にリセット
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final isOrganizer =
          currentUserId != null && participantData['userId'] == currentUserId;

      participantData['paymentStatus'] = isOrganizer ? 'paid' : 'unpaid';
      participantData['paymentAmount'] = 0.0;
      participantData['joinedAt'] = FieldValue.serverTimestamp();
      participantData['updatedAt'] = FieldValue.serverTimestamp();

      batch.set(participantRef, participantData);
    }

    await batch.commit();
  }

  /// 二次会一覧を取得
  Future<List<EventModel>> getAfterParties(String parentEventId) async {
    final parentEventDoc = await _firestore
        .collection('events')
        .doc(parentEventId)
        .get();

    if (!parentEventDoc.exists) {
      return [];
    }

    final parentEventData = parentEventDoc.data()!;
    final childEventIds = List<String>.from(
      parentEventData['childEventIds'] ?? [],
    );

    if (childEventIds.isEmpty) {
      return [];
    }

    final afterParties = <EventModel>[];

    for (final childId in childEventIds) {
      final afterPartyDoc = await _firestore
          .collection('events')
          .doc(childId)
          .get();

      if (afterPartyDoc.exists) {
        afterParties.add(EventModel.fromFirestore(afterPartyDoc));
      }
    }

    return afterParties;
  }

  /// 招待コードを生成
  String _generateInviteCode() {
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final code = List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return code;
  }
}

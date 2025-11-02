import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/services/cache_service.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

/// 統合データ管理サービス
/// イベント、通知などのアプリデータを効率的に管理し、
/// キャッシュ機能とオフライン対応を提供します。
class DataService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CacheService? _cacheService;

  DataService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    CacheService? cacheService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _cacheService = cacheService;

  /// イベント一覧を取得（キャッシュファーストで最適化）
  Future<List<Map<String, dynamic>>> getEvents({bool forceRefresh = false}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        AppLogger.auth('ユーザーが未ログイン: イベント取得をスキップ');
        return [];
      }

      // キャッシュから取得を試行（強制更新でない場合）
      if (!forceRefresh && _cacheService != null) {
        final cachedEvents = await _cacheService!.getCachedEvents();
        if (cachedEvents != null) {
          AppLogger.debug(
            'キャッシュからイベント取得: ${cachedEvents.length}件',
            name: 'DataService',
          );
          return cachedEvents;
        }
      }

      // Firestoreから取得
      AppLogger.database('Firestoreからイベント取得開始', operation: 'getEvents');

      final query = await _firestore
          .collection('events')
          .where('participants', arrayContains: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final events = query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // キャッシュに保存
      if (_cacheService != null) {
        await _cacheService!.cacheEvents(events);
        AppLogger.debug(
          'イベント一覧をキャッシュに保存: ${events.length}件',
          name: 'DataService',
        );
      }

      AppLogger.database('イベント取得完了: ${events.length}件', operation: 'getEvents');
      return events;

    } catch (e) {
      AppLogger.error('イベント取得エラー', name: 'DataService', error: e);

      // エラー時はキャッシュから取得を試行
      if (_cacheService != null) {
        final cachedEvents = await _cacheService!.getCachedEvents();
        if (cachedEvents != null) {
          AppLogger.info('エラー時キャッシュからイベント取得', name: 'DataService');
          return cachedEvents;
        }
      }

      throw Exception('イベント一覧の取得に失敗しました: $e');
    }
  }

  /// 通知一覧を取得
  Future<List<Map<String, dynamic>>> getNotifications({bool forceRefresh = false}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      // キャッシュから取得を試行
      if (!forceRefresh && _cacheService != null) {
        final cachedNotifications = await _cacheService!.getCachedNotifications();
        if (cachedNotifications != null) {
          AppLogger.debug(
            'キャッシュから通知取得: ${cachedNotifications.length}件',
            name: 'DataService',
          );
          return cachedNotifications;
        }
      }

      // Firestoreから取得
      AppLogger.database('Firestoreから通知取得開始', operation: 'getNotifications');

      final query = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      final notifications = query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // キャッシュに保存
      if (_cacheService != null) {
        await _cacheService!.cacheNotifications(notifications);
        AppLogger.debug(
          '通知一覧をキャッシュに保存: ${notifications.length}件',
          name: 'DataService',
        );
      }

      AppLogger.database('通知取得完了: ${notifications.length}件', operation: 'getNotifications');
      return notifications;

    } catch (e) {
      AppLogger.error('通知取得エラー', name: 'DataService', error: e);

      // エラー時はキャッシュから取得を試行
      if (_cacheService != null) {
        final cachedNotifications = await _cacheService!.getCachedNotifications();
        if (cachedNotifications != null) {
          AppLogger.info('エラー時キャッシュから通知取得', name: 'DataService');
          return cachedNotifications;
        }
      }

      throw Exception('通知一覧の取得に失敗しました: $e');
    }
  }

  /// 特定のイベント詳細を取得
  Future<Map<String, dynamic>?> getEventDetail(String eventId) async {
    try {
      AppLogger.database('イベント詳細取得: $eventId', operation: 'getEventDetail');

      final doc = await _firestore.collection('events').doc(eventId).get();

      if (!doc.exists) {
        AppLogger.warning('イベントが存在しません: $eventId', name: 'DataService');
        return null;
      }

      final data = doc.data()!;
      data['id'] = doc.id;

      AppLogger.database('イベント詳細取得完了: $eventId', operation: 'getEventDetail');
      return data;

    } catch (e) {
      AppLogger.error('イベント詳細取得エラー: $eventId', name: 'DataService', error: e);
      throw Exception('イベント詳細の取得に失敗しました: $e');
    }
  }

  /// データを強制更新（プルリフレッシュ用）
  Future<void> refreshAllData() async {
    try {
      AppLogger.info('全データ強制更新開始', name: 'DataService');

      // キャッシュをクリア
      if (_cacheService != null) {
        await _cacheService!.clearAllCache();
      }

      // データを再取得（forceRefresh = true）
      await Future.wait([
        getEvents(forceRefresh: true),
        getNotifications(forceRefresh: true),
      ]);

      AppLogger.info('全データ強制更新完了', name: 'DataService');
    } catch (e) {
      AppLogger.error('データ強制更新エラー', name: 'DataService', error: e);
      throw Exception('データの更新に失敗しました: $e');
    }
  }

  /// 統計情報を取得（ダッシュボード用）
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {};
      }

      AppLogger.database('ダッシュボード統計取得開始', operation: 'getDashboardStats');

      // 並行でデータを取得
      final results = await Future.wait([
        _firestore
            .collection('events')
            .where('participants', arrayContains: user.uid)
            .where('status', isEqualTo: 'active')
            .count()
            .get(),
        _firestore
            .collection('notifications')
            .where('userId', isEqualTo: user.uid)
            .where('isRead', isEqualTo: false)
            .count()
            .get(),
      ]);

      final stats = {
        'activeEventsCount': results[0].count,
        'unreadNotificationsCount': results[1].count,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      AppLogger.database('ダッシュボード統計取得完了', operation: 'getDashboardStats');
      return stats;

    } catch (e) {
      AppLogger.error('ダッシュボード統計取得エラー', name: 'DataService', error: e);
      return {};
    }
  }

  /// オフライン状態かどうかをチェック
  Future<bool> isOffline() async {
    try {
      // 簡単な接続テスト
      await _firestore.collection('_test').limit(1).get();
      return false;
    } catch (e) {
      AppLogger.warning('オフライン状態を検出', name: 'DataService');
      return true;
    }
  }
}

/// DataService用プロバイダー
final dataServiceProvider = Provider<DataService>((ref) {
  // キャッシュサービスを注入（利用可能な場合）
  try {
    final cacheService = ref.watch(cacheServiceInitProvider).value;
    return DataService(cacheService: cacheService);
  } catch (e) {
    // キャッシュサービスが利用できない場合は通常のDataServiceを返す
    return DataService();
  }
});

/// イベント一覧プロバイダー（キャッシュ対応）
final eventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dataService = ref.watch(dataServiceProvider);
  return await dataService.getEvents();
});

/// 通知一覧プロバイダー（キャッシュ対応）
final notificationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dataService = ref.watch(dataServiceProvider);
  return await dataService.getNotifications();
});

/// ダッシュボード統計プロバイダー
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dataService = ref.watch(dataServiceProvider);
  return await dataService.getDashboardStats();
});
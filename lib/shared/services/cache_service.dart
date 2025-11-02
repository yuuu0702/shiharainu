import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

// SharedPreferencesの代替実装（キャッシュ機能のスタブ）
class SharedPreferences {
  static final Map<String, dynamic> _cache = {};

  static Future<SharedPreferences> getInstance() async {
    return SharedPreferences._();
  }

  SharedPreferences._();

  Future<bool> setString(String key, String value) async {
    _cache[key] = value;
    return true;
  }

  Future<bool> setInt(String key, int value) async {
    _cache[key] = value;
    return true;
  }

  String? getString(String key) {
    return _cache[key] as String?;
  }

  int? getInt(String key) {
    return _cache[key] as int?;
  }

  Set<String> getKeys() {
    return _cache.keys.toSet();
  }

  Future<bool> remove(String key) async {
    _cache.remove(key);
    return true;
  }
}

/// キャッシュ管理サービス
/// アプリ全体のデータキャッシュを効率的に管理し、
/// オフライン対応とパフォーマンス向上を提供します。
class CacheService {
  static const String _userProfileKey = 'cached_user_profile';
  static const String _eventsKey = 'cached_events';
  static const String _notificationsKey = 'cached_notifications';
  static const String _cacheTimestampPrefix = 'cache_timestamp_';

  // キャッシュの有効期限（分）
  static const int _defaultCacheValidityMinutes = 30;
  static const int _userProfileCacheValidityMinutes = 60;
  static const int _eventsCacheValidityMinutes = 15;

  final SharedPreferences _prefs;

  CacheService._(this._prefs);

  static Future<CacheService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheService._(prefs);
  }

  /// データをキャッシュに保存
  Future<void> cache<T>(String key, T data, {int? validityMinutes}) async {
    try {
      final jsonData = json.encode(data);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await _prefs.setString(key, jsonData);
      await _prefs.setInt('$_cacheTimestampPrefix$key', timestamp);

      AppLogger.debug('データをキャッシュに保存: $key', name: 'CacheService');
    } catch (e) {
      AppLogger.error('キャッシュ保存エラー: $key', name: 'CacheService', error: e);
    }
  }

  /// キャッシュからデータを取得
  Future<T?> get<T>(
    String key, {
    required T Function(Map<String, dynamic>) fromJson,
    int? validityMinutes,
  }) async {
    try {
      // キャッシュの有効性を確認
      if (!await _isCacheValid(
        key,
        validityMinutes ?? _defaultCacheValidityMinutes,
      )) {
        AppLogger.debug('キャッシュが無効: $key', name: 'CacheService');
        return null;
      }

      final jsonString = _prefs.getString(key);
      if (jsonString == null) {
        return null;
      }

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final result = fromJson(jsonData);

      AppLogger.debug('キャッシュからデータ取得: $key', name: 'CacheService');
      return result;
    } catch (e) {
      AppLogger.error('キャッシュ取得エラー: $key', name: 'CacheService', error: e);
      return null;
    }
  }

  /// リストデータをキャッシュから取得
  Future<List<T>?> getList<T>(
    String key, {
    required T Function(Map<String, dynamic>) fromJson,
    int? validityMinutes,
  }) async {
    try {
      if (!await _isCacheValid(
        key,
        validityMinutes ?? _defaultCacheValidityMinutes,
      )) {
        return null;
      }

      final jsonString = _prefs.getString(key);
      if (jsonString == null) {
        return null;
      }

      final jsonList = json.decode(jsonString) as List<dynamic>;
      final result = jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

      AppLogger.debug('キャッシュからリストデータ取得: $key', name: 'CacheService');
      return result;
    } catch (e) {
      AppLogger.error('キャッシュリスト取得エラー: $key', name: 'CacheService', error: e);
      return null;
    }
  }

  /// ユーザープロフィール専用キャッシュ
  Future<void> cacheUserProfile(Map<String, dynamic> profile) async {
    await cache(
      _userProfileKey,
      profile,
      validityMinutes: _userProfileCacheValidityMinutes,
    );
  }

  Future<Map<String, dynamic>?> getCachedUserProfile() async {
    return await get<Map<String, dynamic>>(
      _userProfileKey,
      fromJson: (json) => json,
      validityMinutes: _userProfileCacheValidityMinutes,
    );
  }

  /// イベント一覧専用キャッシュ
  Future<void> cacheEvents(List<Map<String, dynamic>> events) async {
    await cache(
      _eventsKey,
      events,
      validityMinutes: _eventsCacheValidityMinutes,
    );
  }

  Future<List<Map<String, dynamic>>?> getCachedEvents() async {
    return await getList<Map<String, dynamic>>(
      _eventsKey,
      fromJson: (json) => json,
      validityMinutes: _eventsCacheValidityMinutes,
    );
  }

  /// 通知一覧専用キャッシュ
  Future<void> cacheNotifications(
    List<Map<String, dynamic>> notifications,
  ) async {
    await cache(_notificationsKey, notifications);
  }

  Future<List<Map<String, dynamic>>?> getCachedNotifications() async {
    return await getList<Map<String, dynamic>>(
      _notificationsKey,
      fromJson: (json) => json,
    );
  }

  /// 特定のキャッシュを削除
  Future<void> clearCache(String key) async {
    try {
      await _prefs.remove(key);
      await _prefs.remove('$_cacheTimestampPrefix$key');
      AppLogger.debug('キャッシュをクリア: $key', name: 'CacheService');
    } catch (e) {
      AppLogger.error('キャッシュクリアエラー: $key', name: 'CacheService', error: e);
    }
  }

  /// すべてのキャッシュをクリア
  Future<void> clearAllCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cacheTimestampPrefix) ||
            key == _userProfileKey ||
            key == _eventsKey ||
            key == _notificationsKey) {
          await _prefs.remove(key);
        }
      }
      AppLogger.info('全キャッシュをクリア', name: 'CacheService');
    } catch (e) {
      AppLogger.error('キャッシュ全クリアエラー', name: 'CacheService', error: e);
    }
  }

  /// ユーザー関連キャッシュのみクリア（ログアウト時）
  Future<void> clearUserCache() async {
    await clearCache(_userProfileKey);
    await clearCache(_eventsKey);
    await clearCache(_notificationsKey);
    AppLogger.info('ユーザーキャッシュをクリア', name: 'CacheService');
  }

  /// キャッシュの有効性を確認
  Future<bool> _isCacheValid(String key, int validityMinutes) async {
    final timestamp = _prefs.getInt('$_cacheTimestampPrefix$key');
    if (timestamp == null) {
      return false;
    }

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime).inMinutes;

    return difference < validityMinutes;
  }

  /// キャッシュサイズを取得（デバッグ用）
  Future<int> getCacheSize() async {
    try {
      int totalSize = 0;
      final keys = [_userProfileKey, _eventsKey, _notificationsKey];

      for (final key in keys) {
        final data = _prefs.getString(key);
        if (data != null) {
          totalSize += data.length;
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

/// CacheService用プロバイダー
final cacheServiceProvider = Provider<CacheService>((ref) {
  throw UnimplementedError('CacheServiceは非同期初期化が必要です');
});

/// 非同期初期化プロバイダー
final cacheServiceInitProvider = FutureProvider<CacheService>((ref) async {
  return await CacheService.create();
});

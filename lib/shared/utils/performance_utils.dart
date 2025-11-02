import 'package:flutter/widgets.dart';

/// パフォーマンス最適化のためのユーティリティクラス
class PerformanceUtils {
  /// ウィジェットのrebuildを避けるためのメモ化された値
  static final Map<String, dynamic> _memoCache = {};

  /// メモ化されたビルダー関数
  ///
  /// [key] キー
  /// [builder] ビルダー関数
  /// [dependencies] 依存関係のリスト（これらが変わった時にキャッシュをクリア）
  static T memoized<T>(
    String key,
    T Function() builder, {
    List<Object?>? dependencies,
  }) {
    final cacheKey = _buildCacheKey(key, dependencies);

    if (_memoCache.containsKey(cacheKey)) {
      return _memoCache[cacheKey] as T;
    }

    final result = builder();
    _memoCache[cacheKey] = result;
    return result;
  }

  /// キャッシュキーの構築
  static String _buildCacheKey(String key, List<Object?>? dependencies) {
    if (dependencies == null || dependencies.isEmpty) {
      return key;
    }

    final depString = dependencies.map((dep) => dep.hashCode).join('-');
    return '$key-$depString';
  }

  /// キャッシュのクリア
  static void clearCache([String? key]) {
    if (key != null) {
      _memoCache.removeWhere((k, v) => k.startsWith(key));
    } else {
      _memoCache.clear();
    }
  }

  /// ウィジェットツリーの深さを最適化するためのヘルパー
  static Widget optimizedChild({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Decoration? decoration,
  }) {
    Widget result = child;

    if (padding != null) {
      result = Padding(padding: padding, child: result);
    }

    if (decoration != null || margin != null) {
      result = Container(margin: margin, decoration: decoration, child: result);
    }

    return result;
  }

  /// リストの最適化のためのヘルパー
  static Widget optimizedListView<T>({
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    Widget Function(BuildContext, int)? separatorBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (separatorBuilder != null) {
      return ListView.separated(
        controller: controller,
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]),
        separatorBuilder: separatorBuilder,
      );
    }

    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

/// イベント詳細ページで使用するバッジウィジェット
class EventDetailBadges {
  /// イベントステータスバッジ
  static Widget buildStatusBadge(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return const AppBadge(text: '企画中', variant: AppBadgeVariant.secondary);
      case EventStatus.active:
        return const AppBadge(text: '募集中', variant: AppBadgeVariant.default_);
      case EventStatus.completed:
        return const AppBadge(text: '完了', variant: AppBadgeVariant.secondary);
    }
  }

  /// 支払いステータスバッジ
  static Widget buildPaymentStatusBadge(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return const AppBadge(text: '支払済', variant: AppBadgeVariant.default_);
      case PaymentStatus.pending:
        return const AppBadge(text: '確認中', variant: AppBadgeVariant.warning);
      case PaymentStatus.unpaid:
        return const AppBadge(text: '未払', variant: AppBadgeVariant.destructive);
    }
  }

  /// 支払いステータステキスト取得
  static String getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return '支払い完了';
      case PaymentStatus.pending:
        return '支払い確認中';
      case PaymentStatus.unpaid:
        return '支払い待ち';
    }
  }
}

/// ユーティリティ関数
class EventDetailUtils {
  /// イニシャル取得
  static String getInitials(String name) {
    if (name.length <= 2) return name;
    return name.substring(0, 2);
  }

  /// 日付フォーマット
  static String formatFullDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}

// ホームページで使用するデータモデル

// イベントデータ
class EventData {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int participantCount;
  final EventRole role;
  final EventStatus status;

  const EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.participantCount,
    required this.role,
    required this.status,
  });
}

enum EventRole { organizer, participant }

enum EventStatus { planning, active, completed }

// 通知データ
class NotificationData {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? eventTitle;
  final DateTime createdAt;
  final bool isRead;

  const NotificationData({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.eventTitle,
    required this.createdAt,
    required this.isRead,
  });
}

enum NotificationType { invitation, paymentReminder, general }

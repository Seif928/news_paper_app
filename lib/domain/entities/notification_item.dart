// domain/entities/notification_item.dart
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { breakingNews, article, system }

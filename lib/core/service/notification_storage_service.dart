import 'package:hive_flutter/adapters.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';

class NotificationStorageService {
  static const String _boxName = 'notifications_box';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  Map<String, dynamic> _toMap(NotificationItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'body': item.body,
      'time': DateUtilsApp.formatDate(item.time),
      'type': item.type.index,
      'isRead': item.isRead,
    };
  }

  NotificationItem _fromMap(Map map) {
    return NotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      time: DateUtilsApp.parseDate(map['time'] as String) ?? DateTime.now(),
      type: NotificationType.values[map['type'] as int],
      isRead: map['isRead'] as bool,
    );
  }

  Future<List<NotificationItem>> getAll() async {
    final box = await _openBox();
    final items =
        box.values.map((e) => _fromMap(e as Map)).toList()
          ..sort((a, b) => b.time.compareTo(a.time));
    return items;
  }

  Future<void> add(NotificationItem item) async {
    final box = await _openBox();
    await box.put(item.id, _toMap(item));
  }

  Future<void> markAsRead(String id) async {
    final box = await _openBox();
    final map = box.get(id);
    if (map != null) {
      final updated = Map<String, dynamic>.from(map as Map);
      updated['isRead'] = true;
      await box.put(id, updated);
    }
  }

  Future<void> markAllAsRead() async {
    final box = await _openBox();
    for (final key in box.keys) {
      final map = Map<String, dynamic>.from(box.get(key) as Map);
      map['isRead'] = true;
      await box.put(key, map);
    }
  }

  Future<void> dismiss(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}

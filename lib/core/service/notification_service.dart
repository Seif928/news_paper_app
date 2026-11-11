import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/service/notification_storage_service.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Hive.initFlutter();
  await _saveMessageToStorage(message);
  debugPrint('Background message: ${message.messageId}');
}

Future<void> _saveMessageToStorage(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final item = NotificationItem(
    id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
    title: notification.title ?? '',
    body: notification.body ?? '',
    time: DateTime.now(),
    type: _typeFromData(message.data),
    isRead: false,
  );

  await NotificationStorageService().add(item);
}

NotificationType _typeFromData(Map<String, dynamic> data) {
  switch (data['type']) {
    case 'breaking_news':
      return NotificationType.breakingNews;
    case 'article':
      return NotificationType.article;
    default:
      return NotificationType.system;
  }
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final navigatorKey = GlobalKey<NavigatorState>();
  static const int _inactivityReminderId = 999999;

  Future<void> scheduleInactivityReminder() async {
    await _localNotifications.cancel(_inactivityReminderId);

    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));
    debugPrint(
      'Scheduled for: $scheduledDate, now: ${tz.TZDateTime.now(tz.local)}',
    );

    await _localNotifications.zonedSchedule(
      _inactivityReminderId,
      'Al Akhbar',
      'You missed the latest news — come check what\'s new!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Important Notifications',
          channelDescription: 'Used for important news notifications.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    debugPrint('Schedule call finished');
  }

  Future<void> cancelInactivityReminder() async {
    await _localNotifications.cancel(_inactivityReminderId);
  }

  static const _channelId = 'high_importance_channel';

  static const _channel = AndroidNotificationChannel(
    _channelId,
    'Important Notifications',
    description: 'Used for important news notifications.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    final androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen((message) async {
      await _saveMessageToStorage(message);
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap();
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap();
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap();
      },
    );
  }

  void _showLocalNotification({required String title, required String body}) {
    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _handleNotificationTap() {
    navigatorKey.currentState?.pushNamed(AppRoutes.notificationPageRoute);
  }

  Future<String?> getToken() => _firebaseMessaging.getToken();

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    _showLocalNotification(title: title, body: body);
    await NotificationStorageService().add(
      NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        time: DateTime.now(),
        type: NotificationType.system,
        isRead: false,
      ),
    );
  }
}

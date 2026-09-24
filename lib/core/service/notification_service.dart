// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('Background message: ${message.messageId}');
// }

// class NotificationService {
//   NotificationService._internal();
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;

//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();

//   static const _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'Important Notifications',
//     description: 'Used for important news notifications.',
//     importance: Importance.high,
//   );

//   Future<void> initialize() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     await _initLocalNotifications();

//     _localNotifications
//         .resolvePlatformSpecificImplementation
//             AndroidFlutterLocalNotificationsPlugin>()
//         .createNotificationChannel(_channel);

//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification != null) {
//         _showLocalNotification(
//           title: notification.title ?? '',
//           body: notification.body ?? '',
//         );
//       }
//     });

//     // المستخدم دوس على الإشعار والتطبيق كان في الخلفية
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleNotificationTap(message.data);
//     });

//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotificationTap(initialMessage.data);
//     }
//   }

//   Future<void> _initLocalNotifications() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (response) {
//       },
//     );
//   }

//   void _showLocalNotification({required String title, required String body}) {
//     _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channel.id,
//           _channel.name,
//           channelDescription: _channel.description,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }

//   void _handleNotificationTap(Map<String, dynamic> data) {
  
//     debugPrint('Notification tapped with data: $data');
//   }

//   Future<String?> getToken() => _firebaseMessaging.getToken();

//   Future<void> showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     _showLocalNotification(title: title, body: body);
//   }
// }
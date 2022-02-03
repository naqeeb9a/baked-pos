//
// import 'package:baked_pos/utils/config.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationsService {
//   LocalNotificationsService._();
//
//   static final instance = LocalNotificationsService._();
//
//   static const _chatNotificationChannel = AndroidNotificationDetails(
//     'chat_messages',
//     'Chat messages',
//     color: myYellow,
//     playSound: true,
//     importance: Importance.max,
//     priority: Priority.high,
//     enableVibration: true,
//     channelShowBadge: true,
//   );
//
//   late final FlutterLocalNotificationsPlugin _notificationsPlugin;
//
//   Future<void> initialize() async {
//     _notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     const androidSettings = AndroidInitializationSettings(
//       "@mipmap/ic_launcher",
//     );
//
//     const iosSettings = IOSInitializationSettings();
//
//     const initializationSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: selectNotification,
//     );
//   }
//
//   Future selectNotification(String? payload) {
//     // ignore: todo
//     // TODO: handle this and redirect to the correct page
//     throw UnimplementedError();
//   }
//
//   Future<void> showChatNotification({
//     required String title,
//     required String body,
//   }) async {
//     await _notificationsPlugin.show(
//       0,
//       title,
//       body,
//       const NotificationDetails(
//         android: _chatNotificationChannel,
//       ),
//     );
//   }
// }

import 'package:covid_getx_app/services/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{

  FlutterLocalNotificationsPlugin fltNotification = new FlutterLocalNotificationsPlugin();

  static const String channelId = 'group channel id';
  static const String channelName = 'group channel name';
  static const String channelDescription = 'group channel description';

  static AndroidNotificationDetails androidDetails = AndroidNotificationDetails(channelId, channelName, channelDescription);

  static IOSNotificationDetails iosDetails = IOSNotificationDetails();

  NotificationDetails generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

  void showNotification(RemoteMessage message) async {
    await fltNotification.cancelAll();

    String title = message.notification!.title ?? "title";
    String body = message.notification!.body ?? "body";

    int notificationCount = await LocalPreferences.incNotificationCount();

    String notifications = notificationCount.toString() + " people sent you hello";

    await fltNotification.show(0, title, notifications, generalNotificationDetails);
  }

}
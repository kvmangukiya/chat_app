import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();
  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotification() {
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    ));
  }

  simpleNotification(
      {required int userId, required String title, required String subTitle}) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      userId.toString(),
      "RNW",
      icon: "@mipmap/ic_launcher",
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      subtitle: subTitle,
    );

    flutterLocalNotificationsPlugin
        .show(
      userId,
      title,
      subTitle,
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      ),
    )
        .then((value) {
      log("Notification displayed !!");
    }).catchError((error) {
      log("ERROR: $error");
    });
  }
}

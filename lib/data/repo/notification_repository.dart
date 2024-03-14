import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http_client/http_client.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationRepository {
  final DioHttpClient dioHttpClient;

  NotificationRepository({required this.dioHttpClient});
  String? tokens = '';
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> sendNotification({required String title, required String token, required String body}) async {
    await dioHttpClient.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA9jk7No4:APA91bGg0kSTD8CN4KIuO-gJ71qJpkR24W0eK9Rp6w1WrhEerK5iLhtNtM3kyLfxyJ6_1zK5Y9l2Ks7DPFyMF7KjKGEVrG9RHC9BUpSQpX5woBFScwSqWe1ikoUhVq3xlxU_9_qG3tNU',
        },
        body: jsonEncode(<String, dynamic>{
          "priority": "high",
          "data": <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "status": "done",
            'title': title,
            'body': body,
          },
          'topic': 'Daily Reminder',
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": "channelId",
          },
          "to": token,
        }));
    tokens = token;
  }

  Future<void> zonedScheduleNotification({
    required String title,
    required String body,
    required String dateTime,
  }) async {
    await flutterLocalNotificationsPlugin!.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(DateTime.parse(dateTime), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'channelDescription',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleNotification(
      {required String title, required String token, required String body, required String dateTime}) async {
    await dioHttpClient.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA9jk7No4:APA91bGg0kSTD8CN4KIuO-gJ71qJpkR24W0eK9Rp6w1WrhEerK5iLhtNtM3kyLfxyJ6_1zK5Y9l2Ks7DPFyMF7KjKGEVrG9RHC9BUpSQpX5woBFScwSqWe1ikoUhVq3xlxU_9_qG3tNU',
      },
      body: jsonEncode(
        <String, dynamic>{
          "priority": "high",
          "data": <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "status": "done",
            'title': title,
            'body': body,
            'time': dateTime,
          },
          'topic': 'Daily Reminder',
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "time": dateTime,
            "android_channel_id": "channelId",
          },
          "to": token,
        },
      ),
    );
  }
}

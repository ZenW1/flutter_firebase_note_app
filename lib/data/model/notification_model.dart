// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  String? priority;
  Data? data;
  Notification? notification;
  String? to;

  NotificationModel({
    this.priority,
    this.data,
    this.notification,
    this.to,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        priority: json["priority"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        notification: json["notification"] == null ? null : Notification.fromJson(json["notification"]),
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "priority": priority,
        "data": data?.toJson(),
        "notification": notification?.toJson(),
        "to": to,
      };
}

class Data {
  String? clickAction;
  String? status;
  String? title;
  String? body;

  Data({
    this.clickAction,
    this.status,
    this.title,
    this.body,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clickAction: json["click_action"],
        status: json["status"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "click_action": clickAction,
        "status": status,
        "title": title,
        "body": body,
      };
}

class Notification {
  String? title;
  String? body;
  String? androidChannelId;

  Notification({
    this.title,
    this.body,
    this.androidChannelId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
        androidChannelId: json["android_channel_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "android_channel_id": androidChannelId,
      };
}

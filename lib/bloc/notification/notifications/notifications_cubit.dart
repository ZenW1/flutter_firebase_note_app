import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/widget/custom_page_transition.dart';
import '../../../test/test.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.context) : super(const NotificationsState(token: ''));

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  BuildContext context;

  void initMessage() async {
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initialize = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin!.initialize(initialize, onDidReceiveNotificationResponse: (payload) {
      if (payload != null) {
        print('payload: $payload');
        Navigator.of(context).push(
          CustomPageTransitionAnimation(
            widget: const TestWidgetScreen(),
            direction: AxisDirection.right,
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((event) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        event.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: event.notification!.title,
        htmlFormatContentTitle: true,
        summaryText: 'summary',
        htmlFormatSummaryText: true,
      );

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'channelDescription',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        playSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin!
          .show(0, event.notification!.title, event.notification!.body, notificationDetails, payload: event.notification!.body);
    });
  }

  void initializePermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      authorized();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      provisional();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      unauthorized();
    } else {
      requestPermission();
    }
  }

  void requestPermission() async {
    emit(state.copyWith(status: NotificationsStatus.notDetermined));
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Allow access to gallery and photos'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => openAppSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void authorized() {
    firebaseMessaging.getInitialMessage();
    firebaseMessaging.getToken().then((token) {
      print('Token: $token');
      print('Token: $token');
      print('Token: $token');
      print('Token: $token');
      print('Token: $token');
      emit(state.copyWith(status: NotificationsStatus.authorized, token: token!));
    });
  }

  void unauthorized() {
    emit(state.copyWith(status: NotificationsStatus.unauthorized));
    Fluttertoast.showToast(msg: 'Please enable notifications');
  }

  void provisional() {
    emit(state.copyWith(status: NotificationsStatus.provisional));
  }
}

import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_client/http_client.dart';
import 'package:jong_jam/data/repo/app_storage.dart';
import 'package:jong_jam/data/repo/database_repo.dart';
import 'package:jong_jam/data/repo/notification_repository.dart';
import 'package:jong_jam/data/repo/todo_repository.dart';
import 'package:jong_jam/data/repo/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/view/app.dart';
import 'bootstrap.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  FirebaseMessaging.onBackgroundMessage((message) async {
    firebaseMessageHandler(message);
  });
  bootstrap((shardPreferences) async {
    final httpClient = DioHttpClient(
      dio: Dio(),
      baseUrl: '',
    );

    final SharedPreferences shardPreferences = await SharedPreferences.getInstance();
    PersistentStorage persistentStorage = PersistentStorage(
      sharedPreferences: shardPreferences,
    );
    final UserRepository userRepository = UserRepository();
    final DatabaseRepository databaseRepository = DatabaseRepository(uid: '1');
    final TodoRepository todoRepository = TodoRepository();
    final NotificationRepository notificationRepository = NotificationRepository(
      dioHttpClient: httpClient,
    );
    final AppStorage appStorage = AppStorage(storage: persistentStorage);
    return AppNote(
      dioHttpClient: httpClient,
      databaseRepository: databaseRepository,
      userRepository: userRepository,
      todoRepository: todoRepository,
      notificationRepository: notificationRepository,
      appStorage: appStorage,
    );
  });
}

void firebaseMessageHandler(RemoteMessage message) {
  print('background message ${message.notification!.body}');
}

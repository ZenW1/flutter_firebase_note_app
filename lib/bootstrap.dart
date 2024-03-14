import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jong_jam/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Bloc.observer = const AppBlocObserver();
  await Firebase.initializeApp(name: 'Flutter Note App', options: DefaultFirebaseOptions.currentPlatform);

  // run app with zone
  await runZonedGuarded(
    () async => runApp(
      await builder(sharedPreferences),
    ),
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    },
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  @override
  // ignore: avoid_void_async
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    log('onEvent(${bloc.runtimeType}, $event)');
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    log('onCreate(${bloc.runtimeType})');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    log('onClose(${bloc.runtimeType})');
    super.onClose(bloc);
  }

  void onTrasition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    log('onTransition(${bloc.runtimeType}, $transition)');
    super.onTransition(bloc, transition);
  }
}

typedef AppBuilder = Future<Widget> Function(
  SharedPreferences sharedPreferences,
);

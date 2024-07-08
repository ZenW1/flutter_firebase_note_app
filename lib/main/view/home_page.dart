import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:jong_jam/bloc/authentication/authentication_bloc.dart';
import 'package:jong_jam/bloc/language/language_cubit.dart';
import 'package:jong_jam/bloc/notification/send_notification_bloc.dart';
import 'package:jong_jam/bloc/user_info/user_info_cubit.dart';
import 'package:jong_jam/bloc/user_record/user_record_bloc.dart';
import 'package:jong_jam/chart/chart_page.dart';
import 'package:jong_jam/data/repo/app_storage.dart';
import 'package:jong_jam/l10n/l10n.dart';
import 'package:jong_jam/main/view/google_map_page.dart';
import 'package:jong_jam/main/view/home_main_page.dart';
import 'package:jong_jam/main/view/test_page.dart';
import 'package:jong_jam/profile/view/profile_page.dart';
import 'package:jong_jam/shared/constant/custom_alert_dialog.dart';
import 'package:jong_jam/shared/widget/custom_page_transition.dart';
import 'package:jong_jam/shared/widget/global_text_field.dart';
import 'package:jong_jam/test/test.dart';
import 'package:jong_jam/todo/view/todo_create_page.dart';
import 'package:http/http.dart' as http;

import '../../bloc/notification/notifications/notifications_cubit.dart';
import '../../data/repo/user_repository.dart';
import '../../settings/view/setting_page.dart';
import '../widget/list_user_record.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routePath = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthenticationBloc _authenticationBloc;
  late UserRepository _userRepository;
  dynamic fcmToken;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();

  int activeIndex = 0;

  String? selectedCode = 'en';

  final List<Widget> _widgetOptions = <Widget>[
    const HomeMainPage(),
    const SettingPage(),
    const SettingPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    context.read<LanguageCubit>().load();

    _userRepository = UserRepository();
    _authenticationBloc.add(const AppStarted());
    // messagingRequestPermission();

    context.read<NotificationsCubit>().initMessage();
    context.read<NotificationsCubit>().initializePermission();
    context.read<NotificationsCubit>().requestPermission();

    // getFcmToken();
    // initInfo();
    super.initState();
  }

  //
  // Future<void> messagingRequestPermission() async {
  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.denied) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Notification permission denied'),
  //       ),
  //     );
  //   } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Notification permission granted'),
  //       ),
  //     );
  //   } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Notification permission not determined'),
  //       ),
  //     );
  //   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Notification permission provisional'),
  //       ),
  //     );
  //   }
  // }

  // Future<void> getFcmToken() async {
  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   firebaseMessaging.getToken().then((value) {
  //     setState(() {
  //       fcmToken = value!;
  //       context.read<UserRecordBloc>().add(UserGetFcmTokenDevice(fcmToken));
  //       print('My token is $fcmToken');
  //     });
  //   });
  // }

  // void initInfo() async {
  //   const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initailize = InitializationSettings(android: androidInitialize);
  //   flutterLocalNotificationsPlugin!.initialize(initailize, onDidReceiveNotificationResponse: (payload) {
  //     if (payload != null) {
  //       print('payload: $payload');
  //       Navigator.of(context).push(
  //         CustomPageTransitionAnimation(
  //           widget: const TestWidgetScreen(),
  //           direction: AxisDirection.right,
  //         ),
  //       );
  //     }
  //   });
  //
  //   FirebaseMessaging.onMessage.listen((event) async {
  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //       event.notification!.body.toString(),
  //       htmlFormatBigText: true,
  //       contentTitle: event.notification!.title,
  //       htmlFormatContentTitle: true,
  //       summaryText: 'summary',
  //       htmlFormatSummaryText: true,
  //     );
  //
  //     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //       'channelId',
  //       'channelName',
  //       channelDescription: 'channelDescription',
  //       importance: Importance.high,
  //       styleInformation: bigTextStyleInformation,
  //       playSound: true,
  //     );
  //
  //     NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  //
  //     await flutterLocalNotificationsPlugin!
  //         .show(0, event.notification!.title, event.notification!.body, notificationDetails, payload: event.notification!.body);
  //   });
  // }

  Future<void> sendMessage({required String token, required String body, required String title}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
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
        "notification": <String, dynamic>{
          "title": title,
          "body": body,
          "android_channel_id": "channelId",
        },
        "to": fcmToken,
      }),
    );
  }

  @override
  void didChangeDependencies() {
    context.read<NotificationsCubit>().initMessage();
    context.read<NotificationsCubit>().initializePermission();
    context.read<NotificationsCubit>().requestPermission();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) {
        if (current.user != null) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state.status == NotificationsStatus.authorized) {
              context.read<UserRecordBloc>().add(UserGetFcmTokenDevice(state.token));
            }
          },
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).hello),
                actions: [
                  BlocBuilder<LanguageCubit, LanguageState>(
                    builder: (context, state) {
                      return DropdownButton(
                        onChanged: (value) {
                          context.read<LanguageCubit>().changeLanguage(value.toString());
                        },
                        items: const [
                          DropdownMenuItem(
                            child: Text('English'),
                            value: 'en',
                          ),
                          DropdownMenuItem(
                            child: Text('Khmer'),
                            value: 'km',
                          ),
                        ],
                      );
                    },
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialogWidget(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    context.read<AuthenticationBloc>().add(const AppLoggedOut());
                                  },
                                );
                              });
                        },
                        child: const Text('Logout')),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                children: [
                                  GlobalTextField(
                                    controller: _taskTitleController,
                                    hintText: 'Title',
                                    textInputType: TextInputType.text,
                                  ),
                                  GlobalTextField(
                                    controller: _taskDescriptionController,
                                    hintText: 'Description',
                                    textInputType: TextInputType.text,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      // get user token from

                                      // find token
                                      DocumentSnapshot snapshot = await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(context.read<UserInfoCubit>().uid)
                                          .get();

                                      print('snapshot ${snapshot['userFcmToken']}');
                                      // sendMessage(
                                      //     token: snapshot['userFcmToken'],
                                      //     body: _taskDescriptionController.text,
                                      //     title: _taskTitleController.text);

                                      context.read<SendNotificationBloc>().add(
                                            SendNotificationInitialEvent(
                                              title: _taskTitleController.text,
                                              token: snapshot['userFcmToken'],
                                              body: _taskDescriptionController.text,
                                            ),
                                          );
                                    },
                                    child: const Text('Send Message'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
              body: _widgetOptions[activeIndex],

              // add sub menu to floating action button
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showBottomMenu();
                },
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: const [
                  Icons.home,
                  Icons.settings,
                  Icons.notifications,
                  Icons.person,
                ],
                activeIndex: activeIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.softEdge,
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                onTap: (index) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showBottomMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Create Todo'),
                  onTap: () {
                    context.go(TodoCreatePage.routePath);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Google Map '),
                  onTap: () {
                    Navigator.of(context).pop();
                     Navigator.of(context).push(
                      CustomPageTransitionAnimation(
                        widget: const GoogleMapPage(),
                        direction: AxisDirection.right,
                      ),
                     );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Test page lg ng hah '),
                  onTap: () {
                    Navigator.of(context).push(
                      CustomPageTransitionAnimation(
                        widget: const TestPageLgLg(),
                        direction: AxisDirection.right,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Chart'),
                  onTap: () {
                    Navigator.of(context).push(
                      CustomPageTransitionAnimation(
                        widget: const ChartPage(),
                        direction: AxisDirection.right,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.data_exploration_sharp),
                  title: const Text('Explore'),
                  onTap: () {
                    Navigator.of(context).push(
                      CustomPageTransitionAnimation(
                        widget: const TestWidgetScreen(),
                        direction: AxisDirection.right,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http_client/http_client.dart';
import 'package:jong_jam/authentication/view/login_screen.dart';
import 'package:jong_jam/bloc/language/language_cubit.dart';
import 'package:jong_jam/bloc/notification/notifications/notifications_cubit.dart';
import 'package:jong_jam/bloc/notification/send_notification_bloc.dart';
import 'package:jong_jam/bloc/register/register_opt/register_opt_bloc.dart';
import 'package:jong_jam/bloc/todo/todo_status/todo_status_bloc.dart';
import 'package:jong_jam/data/repo/notification_repository.dart';
import 'package:jong_jam/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:jong_jam/bloc/authentication/authentication_bloc.dart';
import 'package:jong_jam/bloc/login/login_bloc.dart';
import 'package:jong_jam/bloc/register/register_bloc.dart';
import 'package:jong_jam/bloc/user_record/user_record_bloc.dart';
import 'package:jong_jam/data/repo/database_repo.dart';
import 'package:jong_jam/data/repo/todo_repository.dart';
import 'package:jong_jam/data/repo/user_repository.dart';
import 'package:jong_jam/shared/constant/app_color.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/todo/doing_status/doing_status_bloc.dart';
import '../../bloc/todo/todo_bloc.dart';
import '../../bloc/user_info/user_info_cubit.dart';
import '../../data/repo/app_storage.dart';
import '../../routes/app_route.dart';
import '../../shared/widget/global_overlay_config.dart';

class AppNote extends StatelessWidget {
  const AppNote({
    super.key,
    required DioHttpClient dioHttpClient,
    required UserRepository userRepository,
    required DatabaseRepository databaseRepository,
    required TodoRepository todoRepository,
    required NotificationRepository notificationRepository,
    required AppStorage appStorage,
  })  : _dioHttpClient = dioHttpClient,
        _userRepository = userRepository,
        _databaseRepository = databaseRepository,
        _todoRepository = todoRepository,
        _notificationRepository = notificationRepository,
        _appStorage = appStorage,
        super();

  final DioHttpClient _dioHttpClient;
  final DatabaseRepository _databaseRepository;
  final UserRepository _userRepository;
  final TodoRepository _todoRepository;
  final NotificationRepository _notificationRepository;

  final AppStorage _appStorage;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _databaseRepository),
        RepositoryProvider.value(value: _todoRepository),
        RepositoryProvider.value(value: _notificationRepository),
        RepositoryProvider.value(value: _appStorage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              _userRepository,
            )..add(const AppStarted()),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              _userRepository,
            ),
          ),
          BlocProvider<UserInfoCubit>(
            create: (context) => UserInfoCubit(
              _userRepository,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(_userRepository),
          ),
          BlocProvider<RegisterOptBloc>(
            create: (context) => RegisterOptBloc(_userRepository),
          ),
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(
              _appStorage,
            ),
          ),
          BlocProvider<NotificationsCubit>(
            create: (context) => NotificationsCubit(
              context,
            ),
          ),
          BlocProvider<SendNotificationBloc>(
            create: (context) => SendNotificationBloc(_notificationRepository),
          ),
          BlocProvider<UserRecordBloc>(
            create: (context) => UserRecordBloc(
              _databaseRepository,
              _userRepository,
            ),
          ),
          BlocProvider<TodoBloc>(
            create: (context) => TodoBloc(
              _todoRepository,
            ),
          ),
          BlocProvider<TodoStatusBloc>(
            create: (context) => TodoStatusBloc(
              _todoRepository,
            ),
          ),
          BlocProvider(
            create: (context) => DoingStatusBloc(
              _todoRepository,
            ),
          ),
        ],
        child: const RegisterAppBloc(),
      ),
    );
  }
}

class RegisterAppBloc extends StatelessWidget {
  const RegisterAppBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationInitial) {
              context.loaderOverlay.show();
            } else if (state is Authenticated) {
              context.read<UserInfoCubit>().getUserInfo();
            } else if (state is Unauthenticated) {
              context.loaderOverlay.show();
              context.loaderOverlay.hide();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.loaderOverlay.hide();
              context.read<AuthenticationBloc>().add(
                    const AppLoggedIn(),
                  );
            } else if (state is LoginFailure) {
              context.loaderOverlay.hide();
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else if (state is LoginLoadingState) {
              context.loaderOverlay.show();
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailed) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Register failed'), Icon(Icons.error)],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            } else if (state is RegisterInitial) {
              context.loaderOverlay.show();
            } else if (state is RegisterSuccess) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Register success'), Icon(Icons.check)],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              GoRouter.of(context).goNamed('/');
            }
          },
        ),
      ],
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        builder: (context, state) {
          return const RootWidget();
        },
      ),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return BlocSelector<LanguageCubit, LanguageState, Locale>(
        selector: (state) {
          if (state.locale == null) {
            return const Locale('en');
          }
          return state.locale!;
        },
        builder: (context, state) {
          return MaterialApp.router(
            theme: ThemeData(
              fontFamily: 'Kantumruy Pro',
              appBarTheme: const AppBarTheme(
                color: Colors.white,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
                background: Colors.white,
                primary: AppColors.bgColor,
              ),
              useMaterial3: true,
            ),
            locale: state,
            supportedLocales: const [
              Locale('en'),
              Locale('km'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            routerConfig: AppRoute.router,
            builder: (context, child) {
              return GlobalOverLayWidget(
                child: ShowCaseWidget(
                  blurValue: 1,
                  autoPlay: false,
                  builder: Builder(
                    builder: (context) => child!,
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}

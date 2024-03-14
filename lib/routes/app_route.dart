import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jong_jam/authentication/view/register_screen.dart';
import 'package:jong_jam/chart/chart_page.dart';
import 'package:jong_jam/main/view/first_screen.dart';
import 'package:jong_jam/main/widget/list_user_record.dart';
import 'package:jong_jam/main/view/home_page.dart';
import 'package:jong_jam/todo/view/todo_create_page.dart';
import 'package:showcaseview/showcaseview.dart';

import '../authentication/view/login_screen.dart';
import '../bloc/authentication/authentication_bloc.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: BlocProvider.of<AuthenticationBloc>(context),
            builder: (context, state) {
              if (state is Authenticated) {
                return const HomePage();
              } else {
                return const LoginScreen();
              }
            },
          );
        },
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: HomePage.routePath,
        builder: (context, state) => ShowCaseWidget(
          builder: Builder(
            builder: (context) => HomePage(),
          ),
          autoPlay: true,
        ),
      ),
      GoRoute(
        path: RegisterScreen.routePath,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: ListUserRecord.routePath,
        builder: (context, state) => const ListUserRecord(),
      ),
      GoRoute(
        path: TodoCreatePage.routePath,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: TodoCreatePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
        ),
      ),
      // use my custompagetransitionAnimation here
      GoRoute(
        path: ChartPage.routePath,
        builder: (context, state) => const ChartPage(),
      ),
    ],
  );
}

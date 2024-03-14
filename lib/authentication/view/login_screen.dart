import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:jong_jam/authentication/view/reset_password_screen.dart';
import 'package:jong_jam/shared/constant/social_button_widget.dart';
import 'package:jong_jam/authentication/view/register_screen.dart';
import 'package:jong_jam/bloc/authentication/authentication_bloc.dart';
import 'package:jong_jam/bloc/login/login_bloc.dart';
import 'package:jong_jam/data/repo/user_repository.dart';
import 'package:jong_jam/shared/constant/app_text.dart';
import 'package:jong_jam/shared/constant/dimensions.dart';
import 'package:jong_jam/shared/widget/custom_buttom_widget.dart';
import 'package:jong_jam/shared/widget/global_text_field.dart';

import '../../main/view/home_page.dart';
import '../../shared/constant/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routePath = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late AuthenticationBloc _authenticationBloc;
  late UserRepository _userRepository;
  late LoginBloc _loginBloc;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _userRepository = UserRepository();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.dispose();
  }

  void formValidation() async {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault()),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const Text(
                    'Log In',
                    style: AppText.titleExtraLarge,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Email',
                    style: AppText.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextField(
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: 'Email',
                    focusNode: _emailFocusNode,
                    onSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Password',
                    style: AppText.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextField(
                    textInputType: TextInputType.text,
                    controller: passwordController,
                    hintText: 'Password',
                    focusNode: _passwordFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButtonWidget(
                      text: 'Log In',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                                LoginSubmitEvent(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                          _userRepository.isSignedIn();

                          FirebaseAuth.instance.authStateChanges().listen((User? user) {
                            if (user == null || user.emailVerified == false) {
                            } else {
                              Fluttertoast.showToast(
                                msg: "User found",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0,
                              );
                            }
                          });
                        }
                      }),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go(RegisterScreen.routePath);
                    },
                    child: const Text(
                      'Don\'t have an account?',
                      style: AppText.titleMedium,
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault()),
                  const Center(
                    child: Text(
                      'or',
                      style: TextStyle(color: AppColors.tBlackColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SocialButtonWidget(
                          // facebook logo
                          text: 'https://i.pinimg.com/736x/42/75/49/427549f6f22470ff93ca714479d180c2.jpg',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.paddingSizeDefault(),
                      ),
                      Expanded(
                        child: SocialButtonWidget(
                          text:
                              'https://banner2.cleanpng.com/20180423/gkw/kisspng-google-logo-logo-logo-5ade7dc753b015.9317679115245306313428.jpg',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Forgot Password?',
                        style: AppText.titleMedium.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jong_jam/authentication/view/opt_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:jong_jam/authentication/view/login_screen.dart';
import 'package:jong_jam/bloc/register/register_bloc.dart';
import 'package:jong_jam/data/repo/user_repository.dart';
import 'package:jong_jam/shared/constant/app_text.dart';
import 'package:jong_jam/shared/constant/dimensions.dart';
import 'package:jong_jam/shared/widget/custom_buttom_widget.dart';
import 'package:jong_jam/shared/widget/global_text_field.dart';

import '../../bloc/register/register_opt/register_opt_bloc.dart';
import '../../main/view/home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String routePath = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final UserRepository _userRepository = UserRepository();
  double passwordStrength = 0;

  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        passwordStrength = 1 / 4; //string length less then 6 character
      });
    } else if (_password.length < 8) {
      setState(() {
        passwordStrength = 2 / 4; //string length greater then 6 & less then 8
      });
    } else {
      if (passValid.hasMatch(_password)) {
        // regular expression to check password valid or not
        setState(() {
          passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    // _userRepository = UserRepository();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).go('/');
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
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

                GoRouter.of(context).go(HomePage.routePath);
              }
            },
          ),
          BlocListener<RegisterOptBloc, RegisterOptState>(
            listener: (context, state) {
              if (state is RegisterOptFailed) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(state.message), const Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              } else if (state is RegisterOptLoading) {
                context.loaderOverlay.show();
              } else if (state is RegisterOptSuccess) {
                context.loaderOverlay.hide();
                // GoRouter.of(context).go(
                //   OptScreen.routePath,
                //   parameters: {'phone': phoneNumberController.text},
                // );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTPScreen(
                      smsPhoneNumber: phoneNumberController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      name: fullNameController.text,
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<RegisterBloc, RegisterState>(
          bloc: BlocProvider.of<RegisterBloc>(context),
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault()),
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
                        'Register',
                        style: AppText.titleExtraLarge,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your Full Name',
                        style: AppText.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      GlobalTextField(
                        textInputType: TextInputType.name,
                        controller: fullNameController,
                        hintText: 'Full Name',
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
                        onChanged: (value) {
                          validatePassword(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          } else {
                            //call function to check password
                            bool result = validatePassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return " Password should contain Capital, small letter & Number & Special";
                            }
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: LinearProgressIndicator(
                          value: passwordStrength,
                          backgroundColor: Colors.grey[300],
                          minHeight: 5,
                          color: passwordStrength <= 1 / 4
                              ? Colors.red
                              : passwordStrength == 2 / 4
                                  ? Colors.yellow
                                  : passwordStrength == 3 / 4
                                      ? Colors.blue
                                      : Colors.green,
                        ),
                      ),
                      const Text(
                        'Phone Number',
                        style: AppText.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      GlobalTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length < 9) {
                            return 'Phone number must be at least 9 characters';
                          }
                          return null;
                        },
                        textInputType: TextInputType.number,
                        controller: phoneNumberController,
                        hintText: 'Phone Number',
                      ),
                      const SizedBox(height: 20),
                      CustomButtonWidget(
                        text: 'Register your account',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterOptBloc>().add(
                                  RegisterPhoneOtpEvent(phone: '+855${phoneNumberController.text}'),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).go('/');
                        },
                        child: const Text(
                          'Already have an account?',
                          style: AppText.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jong_jam/authentication/view/register_after_otp.dart';
import 'package:jong_jam/authentication/view/register_screen.dart';
import 'package:jong_jam/bloc/authentication/authentication_bloc.dart';
import 'package:jong_jam/shared/constant/app_color.dart';
import 'package:jong_jam/shared/widget/app_bar.dart';
import 'package:jong_jam/shared/widget/custom_buttom_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pinput.dart';

import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_opt/register_opt_bloc.dart';
import '../../data/repo/user_repository.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.smsPhoneNumber, this.email, this.password, this.name});

  final String smsPhoneNumber;
  String? email = '';
  String? password = '';
  String? name = '';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController controller = TextEditingController();
  late UserRepository _userRepository;

  // String sms = '088******3333';
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller = TextEditingController();
    super.dispose();
  }

  final pinputDefaultTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'OTP',
        showButton: false,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
      ),
      body: BlocListener<RegisterOptBloc, RegisterOptState>(
        listener: (context, state) {
          if (state is RegisterOptSuccess) {
            context.read<RegisterBloc>().add(RegisterSubmitEvent(
                  widget.email!,
                  widget.password!,
                  widget.name!,
                  '+855${widget.smsPhoneNumber}',
                ));
            context.read<AuthenticationBloc>().add(const AppStarted());
          } else if (state is RegisterOptFailed) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.bgColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else if (state is RegisterLoadingState) {
            context.loaderOverlay.show();
          } else if (state is RegisterOptInitial) {
            context.loaderOverlay.show();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Your \nVerification Code',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Pinput(
                  defaultPinTheme: pinputDefaultTheme,
                  controller: controller,
                  showCursor: false,
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  length: 6,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  onSubmitted: (String pin) {
                    context.read<RegisterOptBloc>().add(VerifyOtpEvent(otp: pin));
                  },
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'We will send notification codes to your Sms',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'We will send notification codes to your Sms  ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.smsPhoneNumber.toString(),
                        style: const TextStyle(
                          color: AppColors.bgColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<RegisterOptBloc>().add(
                          RegisterPhoneOtpEvent(
                            phone: '+855${widget.smsPhoneNumber}',
                          ),
                        );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Didn\'t receive the code?',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: AppColors.bgColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomButtonWidget(
          text: 'Verify',
          onTap: () {
            context.read<RegisterOptBloc>().add(VerifyOtpEvent(otp: controller.text));
          },
        ),
      ),
    );
  }
}

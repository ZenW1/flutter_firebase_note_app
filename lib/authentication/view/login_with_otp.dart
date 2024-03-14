// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jong_jam/authentication/view/opt_screen.dart';
//
// import '../../bloc/register/register_opt/register_opt_bloc.dart';
// import '../../shared/constant/app_text.dart';
// import '../../shared/widget/custom_buttom_widget.dart';
// import '../../shared/widget/global_text_field.dart';
//
// class LoginWithOtp extends StatefulWidget {
//   const LoginWithOtp({super.key});
//
//   static const routePath = '/login-with-otp';
//
//   @override
//   State<LoginWithOtp> createState() => _LoginWithOtpState();
// }
//
// class _LoginWithOtpState extends State<LoginWithOtp> {
//   final TextEditingController _phoneNumberController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Log In',
//               style: AppText.titleExtraLarge,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Enter your phone number to receive a verification code via SMS.',
//               style: AppText.titleMedium.copyWith(
//                 fontSize: 13,
//               ),
//             ),
//             const SizedBox(height: 20),
//             GlobalTextField(
//               textInputType: TextInputType.number,
//               controller: _phoneNumberController,
//               hintText: 'Phone Number',
//               onSubmitted: (value) {},
//             ),
//             const SizedBox(height: 20),
//             CustomButtonWidget(
//               text: 'Send Verification Code',
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => OTPScreen(
//                       smsPhoneNumber: _phoneNumberController.text,
//                     ),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

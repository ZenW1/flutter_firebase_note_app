// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jong_jam/authentication/view/login_screen.dart';
// import 'package:jong_jam/authentication/view/login_with_otp.dart';
//
// import '../../shared/constant/app_text.dart';
//
// class FirstScreen extends StatelessWidget {
//   const FirstScreen({super.key});
//
//   static String routePath = '/';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             const Text(
//               'Continue With Us To Login',
//               style: AppText.titleExtraLarge,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const LoginScreen(),
//                   ),
//                 );
//               },
//               child: const Text('Login With Email'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const LoginWithOtp(),
//                   ),
//                 );
//               },
//               child: const Text('Login With OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

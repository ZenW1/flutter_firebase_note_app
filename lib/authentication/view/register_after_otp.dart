// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jong_jam/authentication/view/opt_screen.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:jong_jam/authentication/view/login_screen.dart';
// import 'package:jong_jam/bloc/register/register_bloc.dart';
// import 'package:jong_jam/data/repo/user_repository.dart';
// import 'package:jong_jam/shared/constant/app_text.dart';
// import 'package:jong_jam/shared/constant/dimensions.dart';
// import 'package:jong_jam/shared/widget/custom_buttom_widget.dart';
// import 'package:jong_jam/shared/widget/global_text_field.dart';
//
// import '../../bloc/authentication/authentication_bloc.dart';
// import '../../bloc/register/register_opt/register_opt_bloc.dart';
// import '../../main/view/home_page.dart';
//
// class RegisterAfterOTPScreen extends StatefulWidget {
//   const RegisterAfterOTPScreen({super.key, required this.phoneNumber});
//
//   static String routePath = '/register-after-otp';
//
//   final String phoneNumber;
//
//   @override
//   State<RegisterAfterOTPScreen> createState() => _RegisterAfterOTPScreenState();
// }
//
// class _RegisterAfterOTPScreenState extends State<RegisterAfterOTPScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   final UserRepository _userRepository = UserRepository();
//   double passwordStrength = 0;
//
//   @override
//   void initState() {
//     // _userRepository = UserRepository();
//     emailController = TextEditingController();
//     fullNameController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     fullNameController = TextEditingController();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: const Icon(Icons.arrow_back_ios_new),
//         ),
//       ),
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<RegisterBloc, RegisterState>(
//             listener: (context, state) {
//               if (state is RegisterFailed) {
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     const SnackBar(
//                       content: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [Text('Register failed'), Icon(Icons.error)],
//                       ),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//               } else if (state is RegisterInitial) {
//                 context.loaderOverlay.show();
//               } else if (state is RegisterSuccess) {
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     const SnackBar(
//                       content: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [Text('Register success'), Icon(Icons.check)],
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 context.read<AuthenticationBloc>().add(const AppStarted());
//
//                 GoRouter.of(context).go(HomePage.routePath);
//               }
//             },
//           ),
//         ],
//         child: BlocBuilder<RegisterBloc, RegisterState>(
//           bloc: BlocProvider.of<RegisterBloc>(context),
//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault()),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                           width: 100,
//                           height: 100,
//                         ),
//                       ),
//                       const Text(
//                         'Register',
//                         style: AppText.titleExtraLarge,
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Your Full Name',
//                         style: AppText.titleMedium,
//                       ),
//                       const SizedBox(height: 20),
//                       GlobalTextField(
//                         textInputType: TextInputType.name,
//                         controller: fullNameController,
//                         hintText: 'Full Name',
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Your Email',
//                         style: AppText.titleMedium,
//                       ),
//                       const SizedBox(height: 20),
//                       GlobalTextField(
//                         textInputType: TextInputType.emailAddress,
//                         controller: emailController,
//                         hintText: 'Email',
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your email';
//                           } else if (!value.contains('@') || !value.contains('.')) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       CustomButtonWidget(
//                         text: 'Register your account',
//                         onTap: () async {
//                           context.read<RegisterBloc>().add(
//                                 RegisterSubmitEvent(
//                                   emailController.text,
//                                   '123456',
//                                   fullNameController.text,
//                                   widget.phoneNumber,
//                                 ),
//                               );
//                           context.read<AuthenticationBloc>().add(const AppStarted());
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

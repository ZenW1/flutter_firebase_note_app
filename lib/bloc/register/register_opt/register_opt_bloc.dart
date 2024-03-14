import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repo/user_repository.dart';

part 'register_opt_event.dart';
part 'register_opt_state.dart';

class RegisterOptBloc extends Bloc<RegisterOptEvent, RegisterOptState> {
  final UserRepository userReposity;
  RegisterOptBloc(this.userReposity) : super(RegisterOptInitial()) {
    on<RegisterPhoneOtpEvent>(registerPhoneOtp);
    on<VerifyOtpEvent>(verifyOtp);
  }

  Future<void> registerPhoneOtp(RegisterPhoneOtpEvent event, Emitter<RegisterOptState> emit) async {
    emit(RegisterOptLoading());
    try {
      await userReposity.phoneAuthetication(phoneNumber: event.phone);
      emit(const RegisterOptSuccess('Register Successful'));
    } catch (e) {
      emit(RegisterOptFailed(e.toString()));
    }
  }

  Future<void> verifyOtp(VerifyOtpEvent event, Emitter<RegisterOptState> emit) async {
    emit(RegisterOptLoading());
    try {
      await userReposity.verifyOtp(otp: event.otp);
      // if (userReposity.verifyOtp(otp: event.otp) == false) {
      //   emit(RegisterOptFailed('Invalid OTP, Please try again'));
      // } else if (userReposity.verifyOtp(otp: event.otp) == true) {
      //   emit(const RegisterOptSuccess('Register Successful'));
      // }
      emit(const RegisterOptSuccess('Register Successful'));
    } catch (e) {
      emit(RegisterOptFailed(e.toString()));
    }
  }
}

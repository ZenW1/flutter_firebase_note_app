part of 'register_opt_bloc.dart';

abstract class RegisterOptEvent extends Equatable {
  const RegisterOptEvent();
}

class RegisterPhoneOtpEvent extends RegisterOptEvent {
  final String phone;

  const RegisterPhoneOtpEvent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class VerifyOtpEvent extends RegisterOptEvent {
  final String otp;

  const VerifyOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

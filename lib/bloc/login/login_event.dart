part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginSubmitEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitEvent(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

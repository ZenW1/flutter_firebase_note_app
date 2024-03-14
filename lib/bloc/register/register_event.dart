part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterSubmitEvent extends RegisterEvent {
  final String email;
  final String password;

  final String name;

  final String phone;

  const RegisterSubmitEvent(this.email, this.password, this.name, this.phone);

  @override
  List<Object> get props => [email, password, name];
}

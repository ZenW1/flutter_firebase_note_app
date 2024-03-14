part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterLoadingState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends RegisterState {
  final String message;

  const RegisterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterFailed extends RegisterState {
  final String message;

  const RegisterFailed(this.message);

  @override
  List<Object> get props => [message];
}

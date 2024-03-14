part of 'register_opt_bloc.dart';

abstract class RegisterOptState extends Equatable {
  const RegisterOptState();
}

class RegisterOptInitial extends RegisterOptState {
  @override
  List<Object> get props => [];
}

class RegisterOptLoading extends RegisterOptState {
  @override
  List<Object> get props => [];
}

class RegisterOptSuccess extends RegisterOptState {
  final String message;

  const RegisterOptSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterOptFailed extends RegisterOptState {
  final String message;

  const RegisterOptFailed(this.message);

  @override
  List<Object> get props => [message];
}

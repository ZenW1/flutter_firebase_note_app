part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final User displayUserName;

  const Authenticated({required this.displayUserName});
  @override
  List<Object> get props => [displayUserName];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

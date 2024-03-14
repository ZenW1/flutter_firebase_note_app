part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  const AppStarted();
  @override
  List<Object> get props => [];
}

class AppLoggedIn extends AuthenticationEvent {
  const AppLoggedIn();
  @override
  List<Object> get props => [];
}

class AppLoggedOut extends AuthenticationEvent {
  const AppLoggedOut();
  @override
  List<Object> get props => [];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../data/repo/user_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginInitial()) {
    on<LoginEvent>(submitLogin);
  }

  Future<void> submitLogin(LoginEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      if (event is LoginSubmitEvent) {
        await _userRepository.loginUser(
          email: event.email,
          password: event.password,
        );
        emit(const LoginSuccess('Login Successful'));
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const LoginFailure('User not found'));
      } else if (e.code == 'wrong-password') {
        emit(const LoginFailure('Wrong password'));
      } else if (e.code == 'invalid-email') {
        emit(const LoginFailure('Invalid email'));
      } else if (e.code == 'user-disabled') {
        emit(const LoginFailure('User disabled'));
      } else if (e.code == 'too-many-requests') {
        emit(const LoginFailure('Too many requests'));
      } else {
        emit(const LoginFailure('Login failed'));
      }
    }
  }
}

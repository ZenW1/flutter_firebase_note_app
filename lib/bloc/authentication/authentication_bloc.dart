import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repo/user_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc(this._userRepository) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>(mapAuthenticationState);
  }

  // @override
  // AuthenticationState get initialState => Uninitialized();

  Future<void> mapAuthenticationState(AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    try {
      if (event is AppStarted) {
        final isSignIn = await _userRepository.isSignedIn();
        if (isSignIn) {
          final user = await _userRepository.getUser();
          emit(Authenticated(displayUserName: user));
        } else {
          emit(Unauthenticated());
        }
      } else if (event is AppLoggedIn) {
        final user = await _userRepository.getUser();
        emit(Authenticated(displayUserName: user));
      } else if (event is AppLoggedOut) {
        await _userRepository.signOut();
        emit(Unauthenticated());
      }
    } catch (err) {
      emit(Unauthenticated());
    }
  }
}

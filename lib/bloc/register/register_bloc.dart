import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repo/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc(this._userRepository) : super(RegisterLoadingState()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegisterLoadingState());
      try {
        if (event is RegisterSubmitEvent) {
          await _userRepository.signUpUser(email: event.email, password: event.password, name: event.name, phone: event.phone);
        }
        emit(const RegisterSuccess('Register Successful'));
      } catch (e) {
        emit(RegisterFailed(e.toString()));
      }
    });
  }
}

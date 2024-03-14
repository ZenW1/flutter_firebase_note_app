import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repo/user_repository.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit(this._userRepository) : super(const UserInfoState());

  final UserRepository _userRepository;

  String? uid;

  Future<void> getUserInfo() async {
    emit(state.copyWith(status: UserInfoStatus.loading));
    try {
      final user = await _userRepository.getUser();
      emit(state.copyWith(status: UserInfoStatus.success, user: user));
      uid = user.uid;
    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: UserInfoStatus.failure));
    }
  }
}

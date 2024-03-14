import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../data/model/user_info_model.dart';
import '../../data/repo/database_repo.dart';
import '../../data/repo/user_repository.dart';

part 'user_record_event.dart';
part 'user_record_state.dart';

class UserRecordBloc extends Bloc<UserRecordEvent, UserRecordState> {
  final DatabaseRepository _databaseRepository;
  final UserRepository _useRepository;
  UserRecordBloc(this._databaseRepository, this._useRepository) : super(UserRecordInitial()) {
    on<UserRecordEvent>(getUserRecord);
    on<UserGetFcmTokenDevice>(getUserFcmTokenDevice);
    // on<UserRecordUpdateEvent>(userRecordUpdate);
  }
  Future<void> getUserRecord(UserRecordEvent event, Emitter<UserRecordState> emit) async {
    emit(UserRecordLoading());
    try {
      final res = await _databaseRepository.getUserRecord().first;
      emit(UserRecordLoaded(res));
    } on FirebaseException catch (e) {
      emit(UserRecordFailed(e.toString()));
    } catch (e) {
      emit(UserRecordFailed(e.toString()));
    }
  }

  // Future<void> userRecordUpdate(UserRecordUpdateEvent event, Emitter<UserRecordState> emit) async {
  //   emit(UserRecordLoading());
  //   try {
  //     await _databaseRepository.updateUserRecord(
  //       token: event.token,
  //     );
  //   } on FirebaseException catch (e) {
  //     emit(UserRecordFailed(e.toString()));
  //   } catch (e) {
  //     emit(UserRecordFailed(e.toString()));
  //   }
  // }

  Future<void> getUserFcmTokenDevice(UserGetFcmTokenDevice event, Emitter<UserRecordState> emit) async {
    emit(UserRecordLoading());
    try {
      await _useRepository.getFcmToken(token: event.fcmTokenDevice);
    } on FirebaseException catch (e) {
      emit(UserRecordFailed(e.toString()));
    } catch (e) {
      emit(UserRecordFailed(e.toString()));
    }
  }

  // Future<void> updateUserRecord(UserRecordUpdateEvent event, Emitter<UserRecordState> emit) async {
  //   emit(UserRecordLoading());
  //   try {
  //     await _useRepository.userInfo(name: event.name, age: event.age, nickName: event.nickName);
  //   } on FirebaseException catch (e) {
  //     emit(UserRecordFailed(e.toString()));
  //   } catch (e) {
  //     emit(UserRecordFailed(e.toString()));
  //   }
  // }
}

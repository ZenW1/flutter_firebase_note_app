part of 'user_record_bloc.dart';

abstract class UserRecordState extends Equatable {
  const UserRecordState();
}

class UserRecordInitial extends UserRecordState {
  @override
  List<Object> get props => [];
}

class UserRecordLoading extends UserRecordState {
  @override
  List<Object> get props => [];
}

class UserRecordLoaded extends UserRecordState {
  final List<UserInfoModel> userInfoModel;

  const UserRecordLoaded(this.userInfoModel);

  @override
  List<Object> get props => [userInfoModel];
}

class UserRecordFailed extends UserRecordState {
  final String message;

  const UserRecordFailed(this.message);

  @override
  List<Object> get props => [message];
}

class UserFcmTokenDevice extends UserRecordState {
  const UserFcmTokenDevice();

  @override
  List<Object> get props => [];
}

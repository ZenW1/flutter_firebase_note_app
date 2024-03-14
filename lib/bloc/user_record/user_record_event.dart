part of 'user_record_bloc.dart';

abstract class UserRecordEvent extends Equatable {
  const UserRecordEvent();
}

class UserRecordLoadEvent extends UserRecordEvent {
  @override
  List<Object> get props => [];
}

class UserGetFcmTokenDevice extends UserRecordEvent {
  final String fcmTokenDevice;
  const UserGetFcmTokenDevice(this.fcmTokenDevice);
  @override
  List<Object> get props => [fcmTokenDevice];
}

class UserRecordUpdateEvent extends UserRecordEvent {
  final String name;
  final String age;
  final String nickName;
  const UserRecordUpdateEvent(this.name, this.age, this.nickName);
  @override
  List<Object> get props => [name, age, nickName];
}

part of 'user_info_cubit.dart';

enum UserInfoStatus { loading, success, failure }

class UserInfoState extends Equatable {
  const UserInfoState({
    this.status = UserInfoStatus.loading,
    this.message = '',
    this.user,
  });

  final UserInfoStatus status;
  final String message;
  final User? user;

  UserInfoState copyWith({
    UserInfoStatus? status,
    String? message,
    User? user,
  }) {
    return UserInfoState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, message];
}

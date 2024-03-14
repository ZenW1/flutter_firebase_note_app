part of 'notifications_cubit.dart';

enum NotificationsStatus { authorized, unauthorized, notDetermined, provisional, scheduled }

class NotificationsState extends Equatable {
  const NotificationsState({this.status = NotificationsStatus.notDetermined, this.message = '', required this.token});

  final NotificationsStatus status;
  final String message;
  final String token;

  NotificationsState copyWith({NotificationsStatus? status, String? token = ''}) {
    return NotificationsState(
      status: status ?? this.status,
      message: message,
      token: token!,
    );
  }

  @override
  List<Object> get props => [status, message, token];
}

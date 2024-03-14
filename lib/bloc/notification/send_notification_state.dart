part of 'send_notification_bloc.dart';

abstract class SendNotificationState extends Equatable {
  const SendNotificationState();
}

class SendNotificationInitial extends SendNotificationState {
  @override
  List<Object> get props => [];
}

class SendNotificationLoading extends SendNotificationState {
  @override
  List<Object> get props => [];
}

class SendNotificationLoaded extends SendNotificationState {
  final String message;

  const SendNotificationLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class SendNotificationError extends SendNotificationState {
  final String message;

  const SendNotificationError(this.message);

  @override
  List<Object> get props => [message];
}

class SendNotificationSuccess extends SendNotificationState {
  final String message;

  const SendNotificationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

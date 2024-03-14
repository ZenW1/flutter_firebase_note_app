part of 'send_notification_bloc.dart';

abstract class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();
}

class SendNotificationInitialEvent extends SendNotificationEvent {
  final String title;
  final String body;
  final String token;

  const SendNotificationInitialEvent({required this.title, required this.body, required this.token});
  @override
  List<Object> get props => [title, body, token];
}

class SendScheduleNotificationEvent extends SendNotificationEvent {
  final String title;
  final String body;
  final String token;
  final String dateTime;

  const SendScheduleNotificationEvent({required this.title, required this.body, required this.token, required this.dateTime});
  @override
  List<Object> get props => [title, body, token, dateTime];
}

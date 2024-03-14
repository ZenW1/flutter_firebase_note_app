import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/notification_repository.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';

class SendNotificationBloc extends Bloc<SendNotificationEvent, SendNotificationState> {
  final NotificationRepository _notificationRepository;
  SendNotificationBloc(this._notificationRepository) : super(SendNotificationInitial()) {
    on<SendNotificationInitialEvent>(onSendNotificationInitialEvent);
    on<SendScheduleNotificationEvent>(onScheduleNotificationEvent);
  }

  Future<void> onSendNotificationInitialEvent(SendNotificationInitialEvent event, Emitter<SendNotificationState> emit) async {
    emit(SendNotificationLoading());
    try {
      await _notificationRepository.sendNotification(title: event.title, token: event.token, body: event.body);
      emit(const SendNotificationSuccess('Notification sent successfully'));
    } catch (e) {
      emit(SendNotificationError(e.toString()));
    }
  }

  Future<void> onScheduleNotificationEvent(SendScheduleNotificationEvent event, Emitter<SendNotificationState> emit) async {
    emit(SendNotificationLoading());
    try {
      await _notificationRepository.zonedScheduleNotification(title: event.title, body: event.body, dateTime: event.dateTime);
      emit(const SendNotificationSuccess('Notification scheduled successfully'));
    } catch (e) {
      emit(SendNotificationError(e.toString()));
    }
  }
}

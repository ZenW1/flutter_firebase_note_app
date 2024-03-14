part of 'doing_status_bloc.dart';

abstract class DoingStatusEvent extends Equatable {
  const DoingStatusEvent();
}

class DoingStatusFetchEvent extends DoingStatusEvent {
  const DoingStatusFetchEvent();
  @override
  List<Object?> get props => [];
}

class DoingUpdateEvent extends DoingStatusEvent {
  final TodoModel todo;

  const DoingUpdateEvent({required this.todo});

  @override
  List<Object?> get props => [todo];
}

class DoingDeleteEvent extends DoingStatusEvent {
  final String todoID;

  const DoingDeleteEvent({required this.todoID});

  @override
  List<Object?> get props => [todoID];
}

class DoingAddEvent extends DoingStatusEvent {
  final TodoModel todoModel;

  const DoingAddEvent({required this.todoModel});

  @override
  List<Object?> get props => [todoModel];
}

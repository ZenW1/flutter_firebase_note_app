part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoInitialEvent extends TodoEvent {
  @override
  List<Object> get props => [];
}

class TodoGetEvent extends TodoEvent {
  const TodoGetEvent();
  @override
  List<Object?> get props => [];
}

class TodoAddEvent extends TodoEvent {
  final TodoModel todoModel;

  const TodoAddEvent({required this.todoModel});

  @override
  List<Object?> get props => [todoModel];
}

class TodoUpdateEvent extends TodoEvent {
  final TodoModel todo;

  const TodoUpdateEvent({required this.todo});

  @override
  List<Object?> get props => [todo];
}

class TodoDeleteEvent extends TodoEvent {
  final String todoID;

  const TodoDeleteEvent({required this.todoID});

  @override
  List<Object?> get props => [todoID];
}

part of 'todo_status_bloc.dart';

abstract class TodoStatusEvent extends Equatable {
  const TodoStatusEvent();
}

class TodoStatusGetEvent extends TodoStatusEvent {
  @override
  List<Object> get props => [];
}

class TodoStatusAddEvent extends TodoStatusEvent {
  final TodoModel todoModel;
  const TodoStatusAddEvent({required this.todoModel});
  @override
  List<Object> get props => [todoModel];
}

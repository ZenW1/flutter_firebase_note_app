part of 'todo_status_bloc.dart';

abstract class TodoStatusState extends Equatable {
  const TodoStatusState();
}

class TodoStatusInitial extends TodoStatusState {
  @override
  List<Object> get props => [];
}

class TodoStatusLoading extends TodoStatusState {
  @override
  List<Object> get props => [];
}

class TodoStatusLoaded extends TodoStatusState {
  final List<TodoModel> todoStatusList;
  const TodoStatusLoaded({required this.todoStatusList});
  @override
  List<Object> get props => [todoStatusList];
}

class TodoStatusSuccess extends TodoStatusState {
  final String message;
  const TodoStatusSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class TodoStatusFailure extends TodoStatusState {
  final String message;
  const TodoStatusFailure({required this.message});
  @override
  List<Object> get props => [message];
}

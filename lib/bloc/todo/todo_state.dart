part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoaded extends TodoState {
  final List<TodoModel> todoList;

  const TodoLoaded({required this.todoList});

  @override
  List<Object> get props => [todoList];
}

class TodoSuccess extends TodoState {
  final String message;

  const TodoSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TodoFailure extends TodoState {
  final String message;

  const TodoFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class TodoDeleteSuccess extends TodoState {
  final String message;

  const TodoDeleteSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TodoUpdateSuccess extends TodoState {
  final String message;

  const TodoUpdateSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

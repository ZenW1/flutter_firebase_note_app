import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jong_jam/data/model/Todo_Model.dart';

import '../../../data/repo/todo_repository.dart';

part 'todo_status_event.dart';
part 'todo_status_state.dart';

class TodoStatusBloc extends Bloc<TodoStatusEvent, TodoStatusState> {
  final TodoRepository todoRepository;
  TodoStatusBloc(this.todoRepository) : super(TodoStatusInitial()) {
    on<TodoStatusAddEvent>(addTodoStatus);
  }

  Future<void> addTodoStatus(TodoStatusAddEvent event, Emitter<TodoStatusState> emit) async {
    try {
      emit(TodoStatusLoading());
      await todoRepository.addTodoListSave(todoModel: event.todoModel);
      emit(const TodoStatusSuccess(message: 'Todo Status Added'));
    } catch (e) {
      emit(TodoStatusFailure(message: e.toString()));
    }
  }
}

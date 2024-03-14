import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/Todo_Model.dart';
import '../../data/repo/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<TodoAddEvent>(addTodo);
    on<TodoGetEvent>(getTodo);
    on<TodoDeleteEvent>(deleteTodo);
    on<TodoUpdateEvent>(updateTodo);
  }

  Future<void> addTodo(TodoAddEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await todoRepository.addTodoList(todoModel: event.todoModel);
      emit(const TodoSuccess(message: 'Todo Added'));
    } catch (e) {
      emit(TodoFailure(message: e.toString()));
    }
  }

  Future<void> getTodo(TodoGetEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      final res = await todoRepository.getTodoList();
      emit(TodoLoaded(todoList: res));
    } catch (e) {
      emit(TodoFailure(message: e.toString()));
    }
  }

  Future<void> deleteTodo(
    TodoDeleteEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());
      await todoRepository.deleteTodoList(todoID: event.todoID);
      emit(const TodoDeleteSuccess(message: 'Todo Deleted'));
    } catch (e) {
      emit(TodoFailure(message: e.toString()));
    }
  }

  Future<void> updateTodo(
    TodoUpdateEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());
      await todoRepository.updateTodoList(todo: event.todo);
      emit(const TodoUpdateSuccess(message: 'Todo Updated'));
    } catch (e) {
      emit(TodoFailure(message: e.toString()));
    }
  }
}

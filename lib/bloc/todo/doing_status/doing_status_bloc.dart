import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/Todo_Model.dart';
import '../../../data/repo/todo_repository.dart';

part 'doing_status_event.dart';
part 'doing_status_state.dart';

class DoingStatusBloc extends Bloc<DoingStatusEvent, DoingStatusState> {
  final TodoRepository todoRepository;
  DoingStatusBloc(this.todoRepository) : super(DoingStatusInitial()) {
    on<DoingStatusFetchEvent>(onDoingStatusFetch);
    on<DoingDeleteEvent>(onDoingDelete);
    on<DoingUpdateEvent>(onDoingUpdate);
    on<DoingAddEvent>(onDoingStatusAdding);
  }

  Future<void> onDoingStatusAdding(DoingAddEvent event, Emitter<DoingStatusState> emit) async {
    try {
      emit(DoingStatusLoading());
      await todoRepository.addDoingList(todoModel: event.todoModel);
      emit(const DoingAddedSuccess(message: 'Doing List Added'));
    } catch (e) {
      emit(DoingFailure(message: e.toString()));
    }
  }

  Future<void> onDoingStatusFetch(DoingStatusFetchEvent event, Emitter<DoingStatusState> emit) async {
    try {
      emit(DoingStatusLoading());
      final res = await todoRepository.getDoingList();
      emit(DoingStatusLoaded(doingList: res));
    } catch (e) {
      emit(DoingFailure(message: e.toString()));
    }
  }

  Future<void> onDoingDelete(DoingDeleteEvent event, Emitter<DoingStatusState> emit) async {
    try {
      emit(DoingStatusLoading());
      await todoRepository.deleteDoingList(todoID: event.todoID);
      emit(const DoingDeleteSuccess(message: 'Doing List Deleted'));
    } catch (e) {
      emit(DoingFailure(message: e.toString()));
    }
  }

  Future<void> onDoingUpdate(DoingUpdateEvent event, Emitter<DoingStatusState> emit) async {
    try {
      emit(DoingStatusLoading());
      await todoRepository.updateDoingList(todo: event.todo);
      emit(const DoingUpdateSuccess(message: 'Doing List Updated'));
    } catch (e) {
      emit(DoingFailure(message: e.toString()));
    }
  }
}

part of 'doing_status_bloc.dart';

abstract class DoingStatusState extends Equatable {
  const DoingStatusState();
}

class DoingStatusInitial extends DoingStatusState {
  @override
  List<Object> get props => [];
}

class DoingStatusLoading extends DoingStatusState {
  @override
  List<Object> get props => [];
}

class DoingStatusLoaded extends DoingStatusState {
  final List<TodoModel> doingList;

  const DoingStatusLoaded({required this.doingList});

  @override
  List<Object> get props => [doingList];
}

class DoingDeleteSuccess extends DoingStatusState {
  final String message;

  const DoingDeleteSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DoingUpdateSuccess extends DoingStatusState {
  final String message;

  const DoingUpdateSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DoingFailure extends DoingStatusState {
  final String message;

  const DoingFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class DoingAddedSuccess extends DoingStatusState {
  final String message;

  const DoingAddedSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

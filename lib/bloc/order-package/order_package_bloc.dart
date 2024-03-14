
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_package_event.dart';
part 'order_package_state.dart';

class OrderPackageBloc extends Bloc<OrderPackageEvent, OrderPackageState> {
  OrderPackageBloc() : super(OrderPackageInitial()) {
    on<OrderPackageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

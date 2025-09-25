import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_my_orders_usecase.dart';
import '../../../domain/usecases/get_order_details_usecase.dart';
import '../../../domain/usecases/cancel_order_usecase.dart';
import '../../../domain/usecases/return_order_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrdersUseCase getMyOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final ReturnOrderUseCase returnOrderUseCase;

  OrdersCubit({
    required this.getMyOrdersUseCase,
    required this.getOrderDetailsUseCase,
    required this.cancelOrderUseCase,
    required this.returnOrderUseCase,
  }) : super(OrdersInitial());

  Future<void> getMyOrders() async {
    emit(OrdersLoading());

    final result = await getMyOrdersUseCase();
    result.fold((failure) => emit(OrdersError(message: failure.message)), (
      orders,
    ) {
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders: orders));
      }
    });
  }

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());

    final result = await getOrderDetailsUseCase(orderId);
    result.fold(
      (failure) => emit(OrderDetailsError(message: failure.message)),
      (orderDetails) => emit(OrderDetailsLoaded(orderDetails: orderDetails)),
    );
  }

  Future<void> cancelOrder(int orderId) async {
    emit(OrderActionLoading());

    final result = await cancelOrderUseCase(orderId);
    result.fold(
      (failure) => emit(OrderActionError(message: failure.message)),
      (message) => emit(OrderActionSuccess(message: message)),
    );
  }

  Future<void> returnOrder(int orderId) async {
    emit(OrderActionLoading());

    final result = await returnOrderUseCase(orderId);
    result.fold(
      (failure) => emit(OrderActionError(message: failure.message)),
      (message) => emit(OrderActionSuccess(message: message)),
    );
  }

  void resetToInitial() {
    emit(OrdersInitial());
  }
}

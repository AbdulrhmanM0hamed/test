import 'package:equatable/equatable.dart';
import '../../../domain/entities/order_item.dart';
import '../../../domain/entities/order_details.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderItem> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrdersEmpty extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Order Details States
class OrderDetailsLoading extends OrdersState {}

class OrderDetailsLoaded extends OrdersState {
  final OrderDetails orderDetails;

  const OrderDetailsLoaded({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}

class OrderDetailsError extends OrdersState {
  final String message;

  const OrderDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Order Action States (Cancel/Return)
class OrderActionLoading extends OrdersState {}

class OrderActionSuccess extends OrdersState {
  final String message;

  const OrderActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderActionError extends OrdersState {
  final String message;

  const OrderActionError({required this.message});

  @override
  List<Object?> get props => [message];
}

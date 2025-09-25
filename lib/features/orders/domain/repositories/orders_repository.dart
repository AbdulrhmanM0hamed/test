import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/order_details.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> checkout(OrderEntity order);
  Future<Either<Failure, List<OrderItem>>> getMyOrders();
  Future<Either<Failure, OrderDetails>> getOrderDetails(int orderId);
}

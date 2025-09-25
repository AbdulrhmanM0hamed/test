import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_item.dart';
import '../repositories/orders_repository.dart';

class GetMyOrdersUseCase {
  final OrdersRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderItem>>> call() async {
    return await repository.getMyOrders();
  }
}

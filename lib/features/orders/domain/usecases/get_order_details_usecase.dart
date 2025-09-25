import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_details.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<Either<Failure, OrderDetails>> call(int orderId) async {
    return await repository.getOrderDetails(orderId);
  }
}

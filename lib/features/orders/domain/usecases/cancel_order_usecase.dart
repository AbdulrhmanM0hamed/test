import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId) async {
    return await repository.cancelOrder(orderId);
  }
}

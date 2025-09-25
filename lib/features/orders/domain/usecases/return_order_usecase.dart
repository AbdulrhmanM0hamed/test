import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/orders_repository.dart';

class ReturnOrderUseCase {
  final OrdersRepository repository;

  ReturnOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId) async {
    return await repository.returnOrder(orderId);
  }
}

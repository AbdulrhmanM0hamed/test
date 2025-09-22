import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class CheckoutUseCase {
  final OrdersRepository repository;

  CheckoutUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(CheckoutParams params) async {
    return await repository.checkout(params.order);
  }
}

class CheckoutParams extends Equatable {
  final OrderEntity order;

  const CheckoutParams({required this.order});

  @override
  List<Object> get props => [order];
}

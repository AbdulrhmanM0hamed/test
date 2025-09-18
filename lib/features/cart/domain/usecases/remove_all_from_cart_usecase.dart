import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

class RemoveAllFromCartUseCase {
  final CartRepository repository;

  RemoveAllFromCartUseCase(this.repository);
  Future<Either<Failure, String>> call() async {
    return await repository.removeAllFromCart();
  }
}

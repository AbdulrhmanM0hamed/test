import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_to_cart_request.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, String>> call(AddToCartRequest params) async {
    return await repository.addToCart(params);
  }
}

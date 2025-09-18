import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';
 
class RemoveFromCartUseCase{
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);
  Future<Either<Failure, String>> call(int cartItemId) async {
    return await repository.removeFromCart(cartItemId);
  }
}

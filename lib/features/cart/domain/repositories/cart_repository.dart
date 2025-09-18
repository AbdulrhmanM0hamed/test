import '../../../../core/error/failures.dart';
import '../entities/cart.dart';
import '../entities/add_to_cart_request.dart';
import 'package:dartz/dartz.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, String>> addToCart(AddToCartRequest request);
  Future<Either<Failure, String>> removeFromCart(int cartItemId);
  Future<Either<Failure, String>> removeAllFromCart();
}

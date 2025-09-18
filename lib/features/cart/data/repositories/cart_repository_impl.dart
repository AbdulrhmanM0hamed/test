import 'package:dartz/dartz.dart';
import 'package:test/core/services/network/network_info.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/add_to_cart_request.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Cart>> getCart() async {
    if (await networkInfo.isConnected) {
      try {
        final cartModel = await remoteDataSource.getCart();
        return Right(cartModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, String>> addToCart(AddToCartRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.addToCart(request);
        return Right(message);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, String>> removeFromCart(int cartItemId) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.removeFromCart(cartItemId);
        return Right(message);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, String>> removeAllFromCart() async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.removeAllFromCart();
        return Right(message);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}

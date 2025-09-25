import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> checkout(OrderEntity order) async {
    if (await networkInfo.isConnected) {
      final orderModel = OrderModel(
        id: order.id,
        userAddressId: order.userAddressId,
        promoCodeId: order.promoCodeId,
        orderFrom: order.orderFrom,
        paymentType: order.paymentType,
        totalAmount: order.totalAmount,
        discountAmount: order.discountAmount,
        status: order.status,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      );
      
      final response = await remoteDataSource.checkout(orderModel);
      if (response.success && response.data != null) {
        // Create a new OrderEntity with the returned order ID
        final createdOrder = order.copyWith(
          id: int.tryParse(response.data!),
          status: 'pending',
        );
        return Right(createdOrder);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderItem>>> getMyOrders() async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.getMyOrders();
      if (response.success && response.data != null) {
        return Right(response.data!.data);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderDetails>> getOrderDetails(int orderId) async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.getOrderDetails(orderId);
      if (response.success && response.data != null) {
        return Right(response.data!.data);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

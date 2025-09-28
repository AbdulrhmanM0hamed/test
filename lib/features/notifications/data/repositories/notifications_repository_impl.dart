import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/core/services/network/network_info.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNotifications();
        if (response.success) {
          return Right(response.data!.notifications);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, NotificationDetailsEntity>> getNotificationDetails(
    int notificationId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNotificationDetails(
          notificationId,
        );
        if (response.success) {
          return Right(response.data!.notification);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}

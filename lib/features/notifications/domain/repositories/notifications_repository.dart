import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, NotificationDetailsEntity>> getNotificationDetails(int notificationId);
  Future<Either<Failure, void>> deleteAllNotifications();
}

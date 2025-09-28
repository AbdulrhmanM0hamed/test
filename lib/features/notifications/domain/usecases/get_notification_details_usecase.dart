import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationDetailsUseCase {
  final NotificationsRepository repository;

  GetNotificationDetailsUseCase(this.repository);
  Future<Either<Failure, NotificationDetailsEntity>> call(
    int notificationId,
  ) async {
    return await repository.getNotificationDetails(notificationId);
  }
}

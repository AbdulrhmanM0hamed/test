import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../repositories/notifications_repository.dart';

class DeleteAllNotificationsUseCase {
  final NotificationsRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAllNotifications();
  }
}

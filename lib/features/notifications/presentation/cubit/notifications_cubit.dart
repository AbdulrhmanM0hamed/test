import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_notification_details_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
  }) : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());

    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.seen).length;
        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  void refreshNotifications() {
    getNotifications();
  }
}

class NotificationDetailsCubit extends Cubit<NotificationDetailsState> {
  final GetNotificationDetailsUseCase getNotificationDetailsUseCase;

  NotificationDetailsCubit({
    required this.getNotificationDetailsUseCase,
  }) : super(NotificationDetailsInitial());

  Future<void> getNotificationDetails(int notificationId) async {
    emit(NotificationDetailsLoading());

    final result = await getNotificationDetailsUseCase(notificationId);
    result.fold(
      (failure) => emit(NotificationDetailsError(failure.message)),
      (notification) => emit(NotificationDetailsLoaded(notification)),
    );
  }
}

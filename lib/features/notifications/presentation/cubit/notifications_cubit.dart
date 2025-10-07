import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_notification_details_usecase.dart';
import '../../domain/usecases/delete_all_notifications_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.deleteAllNotificationsUseCase,
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

  Future<void> deleteAllNotifications() async {
    emit(NotificationsLoading());

    final result = await deleteAllNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) {
        // After successful deletion, reload notifications and emit success state
        emit(NotificationsDeletedSuccessfully('تم حذف جميع الإشعارات بنجاح'));
        getNotifications();
      },
    );
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

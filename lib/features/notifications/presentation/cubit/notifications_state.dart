import 'package:equatable/equatable.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationsDeletedSuccessfully extends NotificationsState {
  final String message;

  const NotificationsDeletedSuccessfully(this.message);

  @override
  List<Object?> get props => [message];
}

// Notification Details States
abstract class NotificationDetailsState extends Equatable {
  const NotificationDetailsState();

  @override
  List<Object?> get props => [];
}

class NotificationDetailsInitial extends NotificationDetailsState {}

class NotificationDetailsLoading extends NotificationDetailsState {}

class NotificationDetailsLoaded extends NotificationDetailsState {
  final NotificationDetailsEntity notification;

  const NotificationDetailsLoaded(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationDetailsError extends NotificationDetailsState {
  final String message;

  const NotificationDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    super.orderId,
    required super.title,
    required super.description,
    required super.type,
    required super.seen,
    required super.createdAt,
    super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      orderId: json['order_id']?.toString(),
      title: json['title'] as String,
      description: json['desc'] as String,
      type: json['type'] as String,
      seen: json['seen'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'title': title,
      'desc': description,
      'type': type,
      'seen': seen ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class NotificationDetailsModel extends NotificationDetailsEntity {
  const NotificationDetailsModel({
    required super.id,
    super.orderId,
    required super.title,
    required super.description,
    required super.type,
    required super.seen,
    required super.updatedAt,
  });

  factory NotificationDetailsModel.fromJson(Map<String, dynamic> json) {
    return NotificationDetailsModel(
      id: json['id'] as int,
      orderId: json['order_id']?.toString(),
      title: json['title'] as String,
      description: json['desc'] as String,
      type: json['type'] as String,
      seen: json['seen'] == 1,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class NotificationsResponseModel {
  final List<NotificationModel> notifications;

  const NotificationsResponseModel({
    required this.notifications,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'] as List<dynamic>;
    final notifications = data
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return NotificationsResponseModel(
      notifications: notifications,
    );
  }
}

class NotificationDetailsResponseModel {
  final NotificationDetailsModel notification;
  final String message;

  const NotificationDetailsResponseModel({
    required this.notification,
    required this.message,
  });

  factory NotificationDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationDetailsResponseModel(
      notification: NotificationDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}

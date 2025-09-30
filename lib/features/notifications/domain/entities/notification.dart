class NotificationEntity {
  final int id;
  final int orderId;
  final String title;
  final String description;
  final String type;
  final bool seen;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const NotificationEntity({
    required this.id,
    required this.orderId,
    required this.title,
    required this.description,
    required this.type,
    required this.seen,
    required this.createdAt,
    this.updatedAt,
  });

  NotificationEntity copyWith({
    int? id,
    int? orderId,
    String? title,
    String? description,
    String? type,
    bool? seen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      seen: seen ?? this.seen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class NotificationDetailsEntity {
  final int id;
  final int orderId;
  final String title;
  final String description;
  final String type;
  final bool seen;
  final DateTime? updatedAt;

  const NotificationDetailsEntity({
    required this.id,
    required this.orderId,
    required this.title,
    required this.description,
    required this.type,
    required this.seen,
    this.updatedAt,
  });
}

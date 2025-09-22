import '../../domain/entities/promo_code.dart';

class PromoCodeModel extends PromoCode {
  const PromoCodeModel({
    required super.id,
    required super.code,
    required super.from,
    required super.to,
    required super.maximumTimesOfUse,
    required super.numberOfTimesUsed,
    required super.dedicatedTo,
    required super.type,
    required super.status,
    required super.value,
    required super.adminId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id'] as String,
      code: json['code'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      maximumTimesOfUse: json['maximum_times_of_use'] as int,
      numberOfTimesUsed: json['number_of_times_used'] as int,
      dedicatedTo: json['dedicated_to'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      value: (json['value'] as num).toDouble(),
      adminId: json['admin_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'from': from,
      'to': to,
      'maximum_times_of_use': maximumTimesOfUse,
      'number_of_times_used': numberOfTimesUsed,
      'dedicated_to': dedicatedTo,
      'type': type,
      'status': status,
      'value': value,
      'admin_id': adminId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// For checking promo code
  Map<String, dynamic> toCheckJson() {
    return {'code': code};
  }
}

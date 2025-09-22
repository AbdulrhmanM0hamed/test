import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    required super.userAddressId,
    super.promoCodeId,
    required super.orderFrom,
    required super.paymentType,
    required super.totalAmount,
    super.discountAmount,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      userAddressId: json['user_address_id'] as int,
      promoCodeId: json['promo_code_id'] as String?,
      orderFrom: json['order_from'] as String,
      paymentType: json['payment_type'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      discountAmount: json['discount_amount'] != null
          ? (json['discount_amount'] as num).toDouble()
          : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_address_id': userAddressId,
      'promo_code_id': promoCodeId,
      'order_from': orderFrom,
      'payment_type': paymentType,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// For checkout request
  Map<String, dynamic> toCheckoutJson() {
    return {
      'user_address_id': userAddressId,
      if (promoCodeId != null) 'promo_code_id': promoCodeId,
      'order_from': orderFrom,
      'payment_type': paymentType,
    };
  }
}

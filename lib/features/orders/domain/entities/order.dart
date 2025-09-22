import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int? id;
  final int userAddressId;
  final String? promoCodeId;
  final String orderFrom; // 'WEB', 'IOS', 'ANDROID'
  final String paymentType; // 'cash_on_delivery', 'online'
  final double totalAmount;
  final double? discountAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const OrderEntity({
    this.id,
    required this.userAddressId,
    this.promoCodeId,
    required this.orderFrom,
    required this.paymentType,
    required this.totalAmount,
    this.discountAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Create order for checkout
  OrderEntity copyWith({
    int? id,
    int? userAddressId,
    String? promoCodeId,
    String? orderFrom,
    String? paymentType,
    double? totalAmount,
    double? discountAmount,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userAddressId: userAddressId ?? this.userAddressId,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      orderFrom: orderFrom ?? this.orderFrom,
      paymentType: paymentType ?? this.paymentType,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userAddressId,
    promoCodeId,
    orderFrom,
    paymentType,
    totalAmount,
    discountAmount,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Enum for order platforms
enum OrderPlatform {
  web('WEB'),
  ios('IOS'),
  android('ANDROID');

  const OrderPlatform(this.value);
  final String value;
}

/// Enum for payment types
enum PaymentType {
  cashOnDelivery('cash_on_delivery'),
  online('online');

  const PaymentType(this.value);
  final String value;
}

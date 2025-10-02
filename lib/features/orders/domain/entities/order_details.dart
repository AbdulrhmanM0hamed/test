import 'package:equatable/equatable.dart';

import 'order_item.dart';
import 'order_product_item.dart';

/// Entity representing detailed order information
class OrderDetails extends Equatable {
  final int id;
  final Currency currency;
  final String orderNumber;
  final String status;
  final String statusColor;
  final String customerEmail;
  final String customerAddress;
  final String customerPhone;
  final double shipping;
  final String? customerPromoCodeTitle;
  final double customerPromoCodeValue;
  final String? customerPromoCodeType;
  final double promoCodeDiscountAmount;
  final double totalTax;
  final double totalProductPrice;
  final int quantity;
  final double totalPrice;
  final String issueDate;
  final List<OrderProductItem> orderProducts;
  final double totalOrderPrice;
  final List<dynamic> extras;
  final double? refunded;

  const OrderDetails({
    required this.id,
    required this.currency,
    required this.orderNumber,
    required this.status,
    required this.statusColor,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerPhone,
    required this.shipping,
    this.customerPromoCodeTitle,
    required this.customerPromoCodeValue,
    this.customerPromoCodeType,
    required this.promoCodeDiscountAmount,
    required this.totalTax,
    required this.totalProductPrice,
    required this.quantity,
    required this.totalPrice,
    required this.issueDate,
    required this.orderProducts,
    required this.totalOrderPrice,
    required this.extras,
    this.refunded,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    try {
      return OrderDetails(
        id: json['id'] as int,
        currency: Currency.fromJson(json['currancy'] as Map<String, dynamic>),
        orderNumber: json['order_number'] as String,
        status: json['status'] as String,
        statusColor: json['status_color'] as String,
        customerEmail: json['customer_email'] as String,
        customerAddress: json['customer_address'] as String,
        customerPhone: json['customer_phone'] as String,
        shipping: _parseDouble(json['shipping']),
        customerPromoCodeTitle: json['customer_promo_code_title'] as String?,
        customerPromoCodeValue: _parseDouble(json['customer_promo_code_value']),
        customerPromoCodeType: json['customer_promo_code_type'] as String?,
        promoCodeDiscountAmount: _parseDouble(
          json['promo_code_discount_amount'],
        ),
        totalTax: _parseDouble(json['total_tax']),
        totalProductPrice: _parseDouble(json['total_product_price']),
        quantity: json['quantity'] as int,
        totalPrice: _parseDouble(json['total_price']),
        issueDate: json['issue_date'] as String,
        orderProducts: (json['orderProducts'] as List<dynamic>)
            .map(
              (item) => OrderProductItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        totalOrderPrice: json['total_order_price'] != null
            ? _parseDouble(json['total_order_price'])
            : _parseDouble(json['total_price']), // fallback to total_price
        extras: json['extras'] as List<dynamic>? ?? [],
        refunded: json['refunded'] != null
            ? _parseDouble(json['refunded'])
            : null,
      );
    } catch (e) {
      print('❌ Error parsing OrderDetails: $e');
      print('📥 JSON data: $json');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return 0.0;
      // Remove thousands separators (commas) before parsing
      String cleanValue = value.replaceAll(',', '');
      return double.parse(cleanValue);
    }
    throw FormatException('Cannot parse $value to double');
  }

  OrderDetails copyWith({
    int? id,
    Currency? currency,
    String? orderNumber,
    String? status,
    String? statusColor,
    String? customerEmail,
    String? customerAddress,
    String? customerPhone,
    double? shipping,
    String? customerPromoCodeTitle,
    double? customerPromoCodeValue,
    String? customerPromoCodeType,
    double? promoCodeDiscountAmount,
    double? totalTax,
    double? totalProductPrice,
    int? quantity,
    double? totalPrice,
    String? issueDate,
    List<OrderProductItem>? orderProducts,
    double? totalOrderPrice,
    List<dynamic>? extras,
    double? refunded,
  }) {
    return OrderDetails(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      customerPhone: customerPhone ?? this.customerPhone,
      shipping: shipping ?? this.shipping,
      customerPromoCodeTitle:
          customerPromoCodeTitle ?? this.customerPromoCodeTitle,
      customerPromoCodeValue:
          customerPromoCodeValue ?? this.customerPromoCodeValue,
      customerPromoCodeType:
          customerPromoCodeType ?? this.customerPromoCodeType,
      promoCodeDiscountAmount:
          promoCodeDiscountAmount ?? this.promoCodeDiscountAmount,
      totalTax: totalTax ?? this.totalTax,
      totalProductPrice: totalProductPrice ?? this.totalProductPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      issueDate: issueDate ?? this.issueDate,
      orderProducts: orderProducts ?? this.orderProducts,
      totalOrderPrice: totalOrderPrice ?? this.totalOrderPrice,
      extras: extras ?? this.extras,
      refunded: refunded ?? this.refunded,
    );
  }

  @override
  List<Object?> get props => [
    id,
    currency,
    orderNumber,
    status,
    statusColor,
    customerEmail,
    customerAddress,
    customerPhone,
    shipping,
    customerPromoCodeTitle,
    customerPromoCodeValue,
    customerPromoCodeType,
    promoCodeDiscountAmount,
    totalTax,
    totalProductPrice,
    quantity,
    totalPrice,
    issueDate,
    orderProducts,
    totalOrderPrice,
    extras,
    refunded,
  ];
}

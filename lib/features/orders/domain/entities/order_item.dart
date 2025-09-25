import 'package:equatable/equatable.dart';

/// Entity representing a basic order item from the orders list
class OrderItem extends Equatable {
  final int id;
  final String orderNumber;
  final String status;
  final String statusColor;
  final double totalPrice;
  final Currency currency;
  final bool? refunded;

  const OrderItem({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusColor,
    required this.totalPrice,
    required this.currency,
    this.refunded,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    try {
      return OrderItem(
        id: json['id'] as int,
        orderNumber: json['order_number'] as String,
        status: json['status'] as String,
        statusColor: json['status_color'] as String,
        totalPrice: double.parse(json['total_price'].toString()),
        currency: Currency.fromJson(json['currancy'] as Map<String, dynamic>),
        refunded: json['refunded'] as bool?,
      );
    } catch (e) {
      print('❌ Error parsing OrderItem: $e');
      print('📥 JSON data: $json');
      rethrow;
    }
  }

  OrderItem copyWith({
    int? id,
    String? orderNumber,
    String? status,
    String? statusColor,
    double? totalPrice,
    Currency? currency,
    bool? refunded,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      refunded: refunded ?? this.refunded,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    statusColor,
    totalPrice,
    currency,
    refunded,
  ];
}

/// Currency information for orders
class Currency extends Equatable {
  final String en;
  final String ar;

  const Currency({required this.en, required this.ar});

  factory Currency.fromJson(Map<String, dynamic> json) {
    try {
      return Currency(en: json['en'] as String, ar: json['ar'] as String);
    } catch (e) {
      print('❌ Error parsing Currency: $e');
      print('📥 JSON data: $json');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [en, ar];
}

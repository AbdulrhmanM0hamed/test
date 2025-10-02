import 'package:equatable/equatable.dart';

/// Entity representing a product item within an order
class OrderProductItem extends Equatable {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final double totalPricePerItem;
  final List<dynamic> taxes;
  final double totalAfterTaxesPerItem;

  const OrderProductItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPricePerItem,
    required this.taxes,
    required this.totalAfterTaxesPerItem,
  });

  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    try {
      return OrderProductItem(
        id: json['id'] as int,
        productName: json['product_name'] as String,
        quantity: json['quantity'] as int,
        price: _parseDouble(json['price']),
        totalPricePerItem: _parseDouble(json['total_price_per_item']),
        taxes: json['taxes'] as List<dynamic>? ?? [],
        totalAfterTaxesPerItem: _parseDouble(
          json['total_after_taxes_per_item'],
        ),
      );
    } catch (e) {
      print('❌ Error parsing OrderProductItem: $e');
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

  OrderProductItem copyWith({
    int? id,
    String? productName,
    int? quantity,
    double? price,
    double? totalPricePerItem,
    List<dynamic>? taxes,
    double? totalAfterTaxesPerItem,
  }) {
    return OrderProductItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPricePerItem: totalPricePerItem ?? this.totalPricePerItem,
      taxes: taxes ?? this.taxes,
      totalAfterTaxesPerItem:
          totalAfterTaxesPerItem ?? this.totalAfterTaxesPerItem,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productName,
    quantity,
    price,
    totalPricePerItem,
    taxes,
    totalAfterTaxesPerItem,
  ];
}

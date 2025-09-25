import '../../domain/entities/order_item.dart';

/// Response model for my-orders API endpoint
class MyOrdersResponse {
  final int status;
  final String message;
  final List<OrderItem> data;

  const MyOrdersResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MyOrdersResponse(
        status: json['status'] as int,
        message: json['message'] as String,
        data: (json['data'] as List<dynamic>)
            .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('❌ Error parsing MyOrdersResponse: $e');
      print('📥 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data
          .map(
            (item) => {
              'id': item.id,
              'order_number': item.orderNumber,
              'status': item.status,
              'status_color': item.statusColor,
              'total_price': item.totalPrice,
              'currancy': {'en': item.currency.en, 'ar': item.currency.ar},
              'refunded': item.refunded,
            },
          )
          .toList(),
    };
  }
}

import '../../domain/entities/order_details.dart';

/// Response model for order-details API endpoint
class OrderDetailsResponse {
  final int status;
  final String message;
  final OrderDetails data;

  const OrderDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: OrderDetails.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'id': data.id,
        'currancy': {
          'en': data.currency.en,
          'ar': data.currency.ar,
        },
        'order_number': data.orderNumber,
        'status': data.status,
        'status_color': data.statusColor,
        'customer_email': data.customerEmail,
        'customer_address': data.customerAddress,
        'customer_phone': data.customerPhone,
        'shipping': data.shipping,
        'customer_promo_code_title': data.customerPromoCodeTitle,
        'customer_promo_code_value': data.customerPromoCodeValue,
        'customer_promo_code_type': data.customerPromoCodeType,
        'promo_code_discount_amount': data.promoCodeDiscountAmount,
        'total_tax': data.totalTax,
        'total_product_price': data.totalProductPrice,
        'quantity': data.quantity,
        'total_price': data.totalPrice,
        'issue_date': data.issueDate,
        'orderProducts': data.orderProducts.map((product) => {
          'id': product.id,
          'product_name': product.productName,
          'quantity': product.quantity,
          'price': product.price,
          'total_price_per_item': product.totalPricePerItem,
          'taxes': product.taxes,
          'total_after_taxes_per_item': product.totalAfterTaxesPerItem,
        }).toList(),
        'total_order_price': data.totalOrderPrice,
        'extras': data.extras,
        'refunded': data.refunded,
      },
    };
  }
}

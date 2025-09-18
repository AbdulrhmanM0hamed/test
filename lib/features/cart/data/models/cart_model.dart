import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';

class CartModel extends Cart {
  const CartModel({
    required super.items,
    required super.totalProductPrice,
    required super.totalTaxAmount,
    required super.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cartData = json['data'] ?? {};
    
    return CartModel(
      items: (cartData['cart'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      totalProductPrice: cartData['totalProductPrice']?.toString() ?? '0',
      totalTaxAmount: cartData['totalTaxAmount']?.toString() ?? '0',
      totalPrice: cartData['totalPrice']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'cart': items.map((item) => (item as CartItemModel).toJson()).toList(),
        'totalProductPrice': totalProductPrice,
        'totalTaxAmount': totalTaxAmount,
        'totalPrice': totalPrice,
      }
    };
  }

  Cart toEntity() {
    return Cart(
      items: items,
      totalProductPrice: totalProductPrice,
      totalTaxAmount: totalTaxAmount,
      totalPrice: totalPrice,
    );
  }
}

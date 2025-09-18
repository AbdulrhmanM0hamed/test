class AddToCartRequest {
  final List<CartItemRequest> items;

  const AddToCartRequest({
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class CartItemRequest {
  final int productId;
  final int productSizeColorId;
  final int quantity;

  const CartItemRequest({
    required this.productId,
    required this.productSizeColorId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_size_color_id': productSizeColorId,
      'quantity': quantity,
    };
  }
}

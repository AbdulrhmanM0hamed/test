import 'cart_item.dart';

class Cart {
  final List<CartItem> items;
  final String totalProductPrice;
  final String totalTaxAmount;
  final String totalPrice;

  const Cart({
    required this.items,
    required this.totalProductPrice,
    required this.totalTaxAmount,
    required this.totalPrice,
  });

  int get itemCount => items.length;
  
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isEmpty => items.isEmpty;
  
  bool get isNotEmpty => items.isNotEmpty;
  
  double get totalPriceAsDouble => double.tryParse(totalPrice) ?? 0.0;
  
  double get totalProductPriceAsDouble => double.tryParse(totalProductPrice) ?? 0.0;
  
  double get totalTaxAmountAsDouble => double.tryParse(totalTaxAmount) ?? 0.0;
  
  CartItem? getItemById(int itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
  
  bool hasProduct(int productId) {
    return items.any((item) => item.product.id == productId);
  }
  
  CartItem? getItemByProductId(int productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }
}

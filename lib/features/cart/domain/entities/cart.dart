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

  double get totalPriceAsDouble => _parsePrice(totalPrice);

  double get totalProductPriceAsDouble => _parsePrice(totalProductPrice);

  double get totalTaxAmountAsDouble => _parsePrice(totalTaxAmount);

  /// Helper method to parse price strings that may contain commas
  static double _parsePrice(String priceString) {
    if (priceString.isEmpty) return 0.0;

    // Remove commas and any currency symbols
    String cleanPrice = priceString
        .replaceAll(',', '')
        .replaceAll('EGP', '')
        .replaceAll('ج.م', '')
        .replaceAll('£', '')
        .trim();

    return double.tryParse(cleanPrice) ?? 0.0;
  }

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

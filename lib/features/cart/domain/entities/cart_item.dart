class CartItem {
  final int id;
  final int quantity;
  final CartProduct product;
  final List<CartTax> taxes;
  final int productSizeColorId;
  final int countOfAvailable;

  const CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    required this.taxes,
    required this.productSizeColorId,
    required this.countOfAvailable,
  });

  double get totalPrice => _parsePrice(product.realPrice) * quantity;

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

  bool get isAvailable => countOfAvailable > 0;

  String get availabilityText {
    if (countOfAvailable > 10) return 'متوفر';
    if (countOfAvailable > 0) return 'قطع قليلة متبقية';
    return 'غير متوفر';
  }
}

class CartProduct {
  final int id;
  final String name;
  final String image;
  final double star;
  final int numOfUserReview;
  final String realPrice;
  final double fakePrice;
  final int discount;
  final String status;
  final int? colorId;
  final String? colorCode;
  final int? sizeId;
  final String? sizeName;
  final int stock;
  final int limitation;

  const CartProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.star,
    required this.numOfUserReview,
    required this.realPrice,
    required this.fakePrice,
    required this.discount,
    required this.status,
    this.colorId,
    this.colorCode,
    this.sizeId,
    this.sizeName,
    required this.stock,
    required this.limitation,
  });

  bool get hasDiscount => discount > 0;

  bool get isAvailable => stock > 0;

  String get discountText => hasDiscount ? '$discount%' : '';
}

class CartTax {
  final String name;
  final double amount;

  const CartTax({required this.name, required this.amount});
}

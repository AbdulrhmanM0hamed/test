import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.quantity,
    required super.product,
    required super.taxes,
    required super.productSizeColorId,
    required super.countOfAvailable,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      product: CartProductModel.fromJson(json['product'] ?? {}),
      taxes:
          (json['taxes'] as List<dynamic>?)
              ?.map((tax) => CartTaxModel.fromJson(tax))
              .toList() ??
          [],
      productSizeColorId: json['product_size_color_id'] ?? 0,
      countOfAvailable: json['countOfAvailable'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product': (product as CartProductModel).toJson(),
      'taxes': taxes.map((tax) => (tax as CartTaxModel).toJson()).toList(),
      'product_size_color_id': productSizeColorId,
      'countOfAvailable': countOfAvailable,
    };
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      quantity: quantity,
      product: product,
      taxes: taxes,
      productSizeColorId: productSizeColorId,
      countOfAvailable: countOfAvailable,
    );
  }
}

class CartProductModel extends CartProduct {
  const CartProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.star,
    required super.numOfUserReview,
    required super.realPrice,
    required super.fakePrice,
    required super.discount,
    required super.status,
    super.colorId,
    super.colorCode,
    super.sizeId,
    super.sizeName,
    required super.stock,
    required super.limitation,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      star: (json['star'] ?? 0).toDouble(),
      numOfUserReview: json['num_of_user_review'] ?? 0,
      realPrice: json['real_price']?.toString() ?? '0',
      fakePrice: (json['fake_price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      status: json['status'] ?? '',
      colorId: json['color_id'],
      colorCode: json['color_code'],
      sizeId: json['size_id'],
      sizeName: json['size_name'],
      stock: json['stock'] ?? 0,
      limitation: json['limitation'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'star': star,
      'num_of_user_review': numOfUserReview,
      'real_price': realPrice,
      'fake_price': fakePrice,
      'discount': discount,
      'status': status,
      'color_id': colorId,
      'color_code': colorCode,
      'size_id': sizeId,
      'size_name': sizeName,
      'stock': stock,
      'limitation': limitation,
    };
  }
}

class CartTaxModel extends CartTax {
  const CartTaxModel({required super.name, required super.amount});

  factory CartTaxModel.fromJson(Map<String, dynamic> json) {
    return CartTaxModel(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount};
  }
}

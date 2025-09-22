import 'package:test/features/categories/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.image,
    required super.realPrice,
    super.fakePrice,
    required super.discount,
    required super.star,
    required super.numOfUserReview,
    required super.stock,
    required super.isFav,
    required super.isBest,
    required super.brandName,
    required super.brandLogo,
    required super.limitation,
    required super.countOfAvailable,
    required super.countOfReviews,
    super.currency,
    super.quantityInCart,
    super.productSizeColorId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      realPrice: double.parse(
        json['real_price'].toString().replaceAll(',', ''),
      ),
      fakePrice: json['fake_price'] != null && json['fake_price'] != 0
          ? double.parse(json['fake_price'].toString().replaceAll(',', ''))
          : null,
      discount: json['discount'] as int,
      star: (json['star'] as num).toDouble(),
      numOfUserReview: json['num_of_user_review'] as int,
      stock: json['stock'] as int,
      isFav: json['is_fav'] == "1",
      isBest: json['isBest'] ?? false,
      brandName: json['brand_name'] as String,
      brandLogo: json['brand_logo'] as String,
      limitation: json['limitation'] as int,
      countOfAvailable: json['countOfAvailable'] as int,
      countOfReviews: json['countOfReviews'] ?? json['num_of_user_review'] ?? 0,
      currency: 'ج.م',
      quantityInCart: json['quantity_in_cart'] as int?,
      productSizeColorId: json['product_size_color_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'real_price': realPrice.toString(),
      'fake_price': fakePrice?.toString(),
      'discount': discount,
      'star': star,
      'num_of_user_review': numOfUserReview,
      'stock': stock,
      'is_fav': isFav ? "1" : "0",
      'isBest': isBest,
      'brand_name': brandName,
      'brand_logo': brandLogo,
      'limitation': limitation,
      'countOfAvailable': countOfAvailable,
      'countOfReviews': countOfReviews,
      'quantity_in_cart': quantityInCart,
      'product_size_color_id': productSizeColorId,
    };
  }
}

class ProductsResponseModel extends ProductsResponse {
  const ProductsResponseModel({required super.data, required super.pagination});

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ProductsResponseModel(
      data:
          (data['data'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .toList() ??
          [],
      pagination: ProductsPaginationModel.fromJson(data['meta']),
    );
  }
}

class ProductsPaginationModel extends ProductsPagination {
  const ProductsPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.total,
    required super.perPage,
    super.nextPageUrl,
    super.prevPageUrl,
  });

  factory ProductsPaginationModel.fromJson(Map<String, dynamic> json) {
    return ProductsPaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 10,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

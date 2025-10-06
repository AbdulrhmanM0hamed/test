import 'package:test/features/home/domain/entities/sub_category.dart';
import 'package:test/features/home/data/models/home_product_model.dart';
import 'package:test/features/home/data/models/sub_category_product_model.dart';

class SubCategoryModel extends SubCategory {
  const SubCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.summary,
    super.description,
    required super.image,
    required super.icon,
    required super.home,
    super.metaDescription,
    required super.metaKeywords,
    required super.products,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'],
      description: json['description'],
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      home: json['home'] ?? false,
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'] != null 
          ? List<String>.from(json['meta_keywords'])
          : [],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((product) => SubCategoryProductModel.fromJson(product).toHomeProduct())
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'summary': summary,
      'description': description,
      'image': image,
      'icon': icon,
      'home': home,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
      'products': products.map((product) => (product as HomeProductModel).toJson()).toList(),
    };
  }
}

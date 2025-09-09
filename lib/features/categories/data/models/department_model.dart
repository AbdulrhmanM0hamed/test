import 'package:test/features/categories/domain/entities/department.dart';

class DepartmentModel extends Department {
  const DepartmentModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.image,
    required super.icon,
    required super.countOfProduct,
    required super.categories,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      countOfProduct: json['count_of_product'] ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((category) => CategoryModel.fromJson(category))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'icon': icon,
      'count_of_product': countOfProduct,
      'categories': categories.map((category) => (category as CategoryModel).toJson()).toList(),
    };
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.summary,
    required super.description,
    required super.image,
    required super.icon,
    required super.subCategories,
    required super.home,
    super.metaDescription,
    required super.metaKeywords,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>?)
              ?.map((subCategory) => SubCategoryModel.fromJson(subCategory))
              .toList() ??
          [],
      home: json['home'] ?? false,
      metaDescription: json['meta_description'],
      metaKeywords: (json['meta_keywords'] as List<dynamic>?)
              ?.map((keyword) => keyword.toString())
              .toList() ??
          [],
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
      'sub_categories': subCategories.map((subCategory) => (subCategory as SubCategoryModel).toJson()).toList(),
      'home': home,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }
}

class SubCategoryModel extends SubCategory {
  const SubCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.summary,
    required super.description,
    required super.image,
    required super.icon,
    required super.subCategories,
    required super.home,
    super.metaDescription,
    required super.metaKeywords,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>?)
              ?.map((subCategory) => SubCategoryModel.fromJson(subCategory))
              .toList() ??
          [],
      home: json['home'] ?? false,
      metaDescription: json['meta_description'],
      metaKeywords: (json['meta_keywords'] as List<dynamic>?)
              ?.map((keyword) => keyword.toString())
              .toList() ??
          [],
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
      'sub_categories': subCategories.map((subCategory) => (subCategory as SubCategoryModel).toJson()).toList(),
      'home': home,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }
}

import 'package:test/features/home/domain/entities/main_category.dart';

class MainCategoryModel extends MainCategory {
  const MainCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.summary,
    super.description,
    required super.image,
    required super.icon,
    required super.subCategories,
    required super.home,
    super.metaDescription,
    required super.metaKeywords,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'],
      description: json['description'],
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>?)
              ?.map((subCat) => SubCategoryModel.fromJson(subCat))
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
      'sub_categories': subCategories.map((subCat) => (subCat as SubCategoryModel).toJson()).toList(),
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
    super.summary,
    super.description,
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
      summary: json['summary'],
      description: json['description'],
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>?)
              ?.map((subCat) => SubCategoryModel.fromJson(subCat))
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
      'sub_categories': subCategories.map((subCat) => (subCat as SubCategoryModel).toJson()).toList(),
      'home': home,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }
}

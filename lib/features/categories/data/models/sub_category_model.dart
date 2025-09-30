import 'package:test/features/categories/domain/entities/sub_category.dart';

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
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String,
      icon: json['icon'] as String,
      home: json['home'] as bool,
      metaDescription: json['meta_description'] as String?,
      metaKeywords: (json['meta_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
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
      'home': home,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }

  SubCategory toEntity() {
    return SubCategory(
      id: id,
      name: name,
      slug: slug,
      summary: summary,
      description: description,
      image: image,
      icon: icon,
      home: home,
      metaDescription: metaDescription,
      metaKeywords: metaKeywords,
    );
  }
}

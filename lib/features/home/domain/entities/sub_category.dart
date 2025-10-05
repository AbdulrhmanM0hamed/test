import 'package:test/features/home/domain/entities/home_product.dart';

class SubCategory {
  final int id;
  final String name;
  final String slug;
  final String? summary;
  final String? description;
  final String image;
  final String icon;
  final bool home;
  final String? metaDescription;
  final List<String> metaKeywords;
  final List<HomeProduct> products;

  const SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.summary,
    this.description,
    required this.image,
    required this.icon,
    required this.home,
    this.metaDescription,
    required this.metaKeywords,
    required this.products,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

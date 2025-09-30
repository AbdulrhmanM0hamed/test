import 'package:equatable/equatable.dart';

class SubCategory extends Equatable {
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
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        summary,
        description,
        image,
        icon,
        home,
        metaDescription,
        metaKeywords,
      ];
}

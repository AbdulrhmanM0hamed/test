class MainCategory {
  final int id;
  final String name;
  final String slug;
  final String? summary;
  final String? description;
  final String image;
  final String icon;
  final List<SubCategory> subCategories;
  final bool home;
  final String? metaDescription;
  final List<String> metaKeywords;

  const MainCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.summary,
    this.description,
    required this.image,
    required this.icon,
    required this.subCategories,
    required this.home,
    this.metaDescription,
    required this.metaKeywords,
  });
}

class SubCategory {
  final int id;
  final String name;
  final String slug;
  final String? summary;
  final String? description;
  final String image;
  final String icon;
  final List<SubCategory> subCategories;
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
    required this.subCategories,
    required this.home,
    this.metaDescription,
    required this.metaKeywords,
  });
}

class Department {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String icon;
  final int countOfProduct;
  final List<Category> categories;

  const Department({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.icon,
    required this.countOfProduct,
    required this.categories,
  });
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String summary;
  final String description;
  final String image;
  final String icon;
  final List<SubCategory> subCategories;
  final bool home;
  final String? metaDescription;
  final List<String> metaKeywords;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.summary,
    required this.description,
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
  final String summary;
  final String description;
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
    required this.summary,
    required this.description,
    required this.image,
    required this.icon,
    required this.subCategories,
    required this.home,
    this.metaDescription,
    required this.metaKeywords,
  });
}

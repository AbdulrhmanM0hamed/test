class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String icon;
  final int itemsCount;
  final bool isPopular;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.icon,
    required this.itemsCount,
    this.isPopular = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      icon: json['icon'],
      itemsCount: json['items_count'],
      isPopular: json['is_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'icon': icon,
      'items_count': itemsCount,
      'is_popular': isPopular,
    };
  }
}

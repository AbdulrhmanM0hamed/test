class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final int itemsCount;
  final bool isPopular;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.itemsCount,
    this.isPopular = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      itemsCount: json['items_count'],
      isPopular: json['is_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'items_count': itemsCount,
      'is_popular': isPopular,
    };
  }
} 
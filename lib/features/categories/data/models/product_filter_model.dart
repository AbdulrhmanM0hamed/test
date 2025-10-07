import 'package:test/features/categories/domain/entities/product_filter.dart';

class ProductFilterModel extends ProductFilter {
  const ProductFilterModel({
    super.mainCategoryId,
    super.subCategoryId,
    super.price,
    super.rate,
    super.departmentId,
    super.brandId,
    super.platform,
    super.colorId,
    super.sizeId,
    super.keyword,
    super.regionId,
    super.tags,
    super.page,
  });

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) {
    List<double>? priceList;
    if (json['price'] != null && json['price'] is List) {
      priceList = (json['price'] as List).map((e) => (e as num).toDouble()).toList();
    }
    
    return ProductFilterModel(
      mainCategoryId: json['main_category_id'],
      subCategoryId: json['sub_category_id'],
      price: priceList,
      rate: json['rate'],
      departmentId: json['department_id'],
      brandId: json['brand_id'],
      platform: json['platform'],
      colorId: json['color_id'],
      sizeId: json['size_id'],
      keyword: json['keyword'],
      regionId: json['region_id'],
      tags: json['tags'],
      page: json['page'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (mainCategoryId != null) data['main_category_id'] = mainCategoryId;
    if (subCategoryId != null) data['sub_category_id'] = subCategoryId;
    if (price != null && price!.isNotEmpty) data['price'] = price;
    if (rate != null) data['rate'] = rate;
    if (departmentId != null) data['department_id'] = departmentId;
    if (brandId != null) data['brand_id'] = brandId;
    if (platform != null) data['platform'] = platform;
    if (colorId != null) data['color_id'] = colorId;
    if (sizeId != null) data['size_id'] = sizeId;
    if (keyword != null) data['keyword'] = keyword;
    if (regionId != null) data['region_id'] = regionId;
    if (tags != null) data['tags'] = tags;
    if (page != null) data['page'] = page;
    
    return data;
  }

  @override
  ProductFilterModel copyWith({
    int? mainCategoryId,
    int? subCategoryId,
    List<double>? price,
    int? rate,
    String? departmentId,
    int? brandId,
    String? platform,
    int? colorId,
    int? sizeId,
    String? keyword,
    int? regionId,
    String? tags,
    int? page,
  }) {
    return ProductFilterModel(
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      price: price ?? this.price,
      rate: rate ?? this.rate,
      departmentId: departmentId ?? this.departmentId,
      brandId: brandId ?? this.brandId,
      platform: platform ?? this.platform,
      colorId: colorId ?? this.colorId,
      sizeId: sizeId ?? this.sizeId,
      keyword: keyword ?? this.keyword,
      regionId: regionId ?? this.regionId,
      tags: tags ?? this.tags,
      page: page ?? this.page,
    );
  }
}

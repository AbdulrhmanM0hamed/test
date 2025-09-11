import 'package:test/features/categories/domain/entities/product_filter.dart';

class ProductFilterModel extends ProductFilter {
  const ProductFilterModel({
    super.mainCategoryId,
    super.subCategoryId,
    super.minPrice,
    super.maxPrice,
    super.rate,
    super.departmentId,
    super.brandId,
    super.platform,
    super.colorId,
    super.sizeId,
    super.keyword,
    super.countryId,
    super.tags,
    super.page,
  });

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) {
    return ProductFilterModel(
      mainCategoryId: json['main_category_id'],
      subCategoryId: json['sub_category_id'],
      minPrice: json['min_price']?.toDouble(),
      maxPrice: json['max_price']?.toDouble(),
      rate: json['rate'],
      departmentId: json['department_id'],
      brandId: json['brand_id'],
      platform: json['platform'],
      colorId: json['color_id'],
      sizeId: json['size_id'],
      keyword: json['keyword'],
      countryId: json['country_id'],
      tags: json['tags'],
      page: json['page'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (mainCategoryId != null) data['main_category_id'] = mainCategoryId;
    if (subCategoryId != null) data['sub_category_id'] = subCategoryId;
    if (minPrice != null) data['min_price'] = minPrice;
    if (maxPrice != null) data['max_price'] = maxPrice;
    if (rate != null) data['rate'] = rate;
    if (departmentId != null) data['department_id'] = departmentId;
    if (brandId != null) data['brand_id'] = brandId;
    if (platform != null) data['platform'] = platform;
    if (colorId != null) data['color_id'] = colorId;
    if (sizeId != null) data['size_id'] = sizeId;
    if (keyword != null) data['keyword'] = keyword;
    if (countryId != null) data['country_id'] = countryId;
    if (tags != null) data['tags'] = tags;
    if (page != null) data['page'] = page;
    
    return data;
  }

  @override
  ProductFilterModel copyWith({
    int? mainCategoryId,
    int? subCategoryId,
    double? minPrice,
    double? maxPrice,
    int? rate,
    String? departmentId,
    int? brandId,
    String? platform,
    int? colorId,
    int? sizeId,
    String? keyword,
    int? countryId,
    String? tags,
    int? page,
  }) {
    return ProductFilterModel(
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      rate: rate ?? this.rate,
      departmentId: departmentId ?? this.departmentId,
      brandId: brandId ?? this.brandId,
      platform: platform ?? this.platform,
      colorId: colorId ?? this.colorId,
      sizeId: sizeId ?? this.sizeId,
      keyword: keyword ?? this.keyword,
      countryId: countryId ?? this.countryId,
      tags: tags ?? this.tags,
      page: page ?? this.page,
    );
  }
}

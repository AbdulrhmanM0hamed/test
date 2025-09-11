/// فلتر المنتجات
class ProductFilter {
  final int? mainCategoryId;
  final int? subCategoryId;
  final double? minPrice;
  final double? maxPrice;
  final int? rate;
  final String? departmentId;
  final int? brandId;
  final String? platform;
  final int? colorId;
  final int? sizeId;
  final String? keyword;
  final int? countryId;
  final String? tags;
  final int? page;

  const ProductFilter({
    this.mainCategoryId,
    this.subCategoryId,
    this.minPrice,
    this.maxPrice,
    this.rate,
    this.departmentId,
    this.brandId,
    this.platform,
    this.colorId,
    this.sizeId,
    this.keyword,
    this.countryId,
    this.tags,
    this.page = 1,
  });

  ProductFilter copyWith({
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
    return ProductFilter(
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

  /// مسح جميع الفلاتر
  ProductFilter clearAll() {
    return const ProductFilter();
  }

  /// مسح فلاتر الفئات فقط
  ProductFilter clearCategories() {
    return copyWith(
      departmentId: null,
      mainCategoryId: null,
      subCategoryId: null,
    );
  }

  /// التحقق من وجود فلاتر نشطة
  bool get hasActiveFilters {
    return mainCategoryId != null ||
        subCategoryId != null ||
        minPrice != null ||
        maxPrice != null ||
        rate != null ||
        departmentId != null ||
        brandId != null ||
        platform != null ||
        colorId != null ||
        sizeId != null ||
        (keyword != null && keyword!.isNotEmpty) ||
        countryId != null ||
        (tags != null && tags!.isNotEmpty);
  }

  @override
  String toString() {
    return 'ProductFilter(mainCategoryId: $mainCategoryId, subCategoryId: $subCategoryId, departmentId: $departmentId, keyword: $keyword, page: $page)';
  }
}

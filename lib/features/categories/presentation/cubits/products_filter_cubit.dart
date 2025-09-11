import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/categories/domain/entities/product_filter.dart';
import 'package:test/features/categories/domain/usecases/get_all_products_usecase.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';

/// Cubit إدارة فلترة المنتجات
class ProductsFilterCubit extends Cubit<ProductsFilterState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  ProductsFilterCubit({required this.getAllProductsUseCase})
    : super(const ProductsFilterState());

  /// تحديث الكلمة المفتاحية للبحث
  void updateKeyword(String keyword) {
    final newFilter = state.filter.copyWith(keyword: keyword);
    emit(state.copyWith(filter: newFilter));
    _loadProducts();
  }

  /// تحديد القسم والفئات المتاحة
  void updateDepartmentFilter(int departmentId, List<dynamic> categories) {
    final newFilter = state.filter.copyWith(
      departmentId: departmentId.toString(),
      mainCategoryId: null, // مسح الفئة الرئيسية عند تغيير القسم
      subCategoryId: null, // مسح الفئة الفرعية عند تغيير القسم
    );

    emit(
      state.copyWith(
        filter: newFilter,
        availableCategories: categories,
        availableSubCategories: [],
      ),
    );

    _loadProducts();
  }

  /// تحديد الفئة الرئيسية
  void updateMainCategory(int? mainCategoryId) {
    final newFilter = state.filter.copyWith(
      mainCategoryId: mainCategoryId,
      subCategoryId: null, // مسح الفئة الفرعية عند تغيير الفئة الرئيسية
    );

    // البحث عن الفئات الفرعية للفئة المحددة
    List<dynamic> subCategories = [];
    if (mainCategoryId != null) {
      final selectedCategory = state.availableCategories.firstWhere(
        (cat) => cat.id == mainCategoryId,
        orElse: () => null,
      );
      if (selectedCategory != null && selectedCategory.subCategories != null) {
        subCategories = selectedCategory.subCategories;
      }
    }

    emit(
      state.copyWith(filter: newFilter, availableSubCategories: subCategories),
    );

    _loadProducts();
  }

  /// تحديد الفئة الفرعية
  void updateSubCategory(int? subCategoryId) {
    final newFilter = state.filter.copyWith(subCategoryId: subCategoryId);
    emit(state.copyWith(filter: newFilter));
    _loadProducts();
  }

  /// تحديد التقييم
  void updateRating(int? rating) {
    final newFilter = state.filter.copyWith(rate: rating);
    emit(state.copyWith(filter: newFilter));
    _loadProducts();
  }

  /// تحديد نطاق السعر
  void updatePriceRange(double? minPrice, double? maxPrice) {
    final newFilter = state.filter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    emit(state.copyWith(filter: newFilter));
    _loadProducts();
  }

  /// تحديث فلاتر متعددة في مرة واحدة
  void updateFilter({
    int? departmentId,
    int? mainCategoryId,
    int? subCategoryId,
  }) {
    final newFilter = state.filter.copyWith(
      departmentId: departmentId?.toString(),
      mainCategoryId: mainCategoryId,
      subCategoryId: subCategoryId,
    );
    emit(state.copyWith(filter: newFilter));
    _loadProducts();
  }

  /// مسح جميع الفلاتر والعودة للقسم الأول
  void clearFilters({int? defaultDepartmentId}) {
    final newFilter = ProductFilter(
      departmentId: defaultDepartmentId?.toString(),
    );
    emit(ProductsFilterState(filter: newFilter));
    _loadProducts();
  }

  /// تحميل المزيد من المنتجات
  void loadMore() {
    if (state.isLoadingMore || state.hasReachedMax) return;

    final newFilter = state.filter.copyWith(page: (state.filter.page ?? 0) + 1);

    emit(state.copyWith(filter: newFilter, isLoadingMore: true));

    _loadProducts(loadMore: true);
  }

  /// إعادة تحميل المنتجات
  void refresh() {
    final newFilter = state.filter.copyWith(page: 1);
    emit(
      state.copyWith(
        filter: newFilter,
        products: [],
        currentPage: 1,
        hasReachedMax: false,
        error: null,
      ),
    );
    _loadProducts(refresh: true);
  }

  /// تحميل المنتجات
  Future<void> _loadProducts({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (!loadMore && !refresh) {
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
          products: [],
          currentPage: 1,
          hasReachedMax: false,
        ),
      );
    }

    try {
      final response = await getAllProductsUseCase.call(state.filter);

      if (response.success && response.data != null) {
        final newProducts = response.data!.data;
        final allProducts = loadMore
            ? [...state.products, ...newProducts]
            : newProducts;

        emit(
          state.copyWith(
            products: allProducts,
            isLoading: false,
            isLoadingMore: false,
            currentPage: state.filter.page ?? 1,
            hasReachedMax: newProducts.isEmpty,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: 'حدث خطأ في تحميل المنتجات',
        ),
      );
    }
  }
}

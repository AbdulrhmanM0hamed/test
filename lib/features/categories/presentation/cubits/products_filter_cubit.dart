import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/services/location_service.dart';
import 'package:test/features/categories/domain/entities/product_filter.dart';
import 'package:test/features/categories/domain/usecases/get_all_products_usecase.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';

/// Cubit إدارة فلترة المنتجات
class ProductsFilterCubit extends Cubit<ProductsFilterState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final DataRefreshService? dataRefreshService;

  ProductsFilterCubit({
    required this.getAllProductsUseCase,
    this.dataRefreshService,
  }) : super(const ProductsFilterState()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

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
      // Get current region ID from LocationService
      int? regionId;
      try {
        final locationService = LocationService.instance;
        regionId = locationService.selectedRegion?.id;
      } catch (e) {
        // LocationService not initialized, continue without region filter
        print('⚠️ LocationService not available: $e');
      }

      // Create filter with current region ID
      final filterWithRegion = state.filter.copyWith(regionId: regionId);
      final response = await getAllProductsUseCase.call(filterWithRegion);

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
      String errorMessage;

      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        // Handle specific network errors
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('connection closed') ||
            errorString.contains('connection reset') ||
            errorString.contains('connection refused')) {
          errorMessage =
              'فشل الاتصال بالخادم. تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
        } else if (errorString.contains('timeout') ||
            errorString.contains('timed out')) {
          errorMessage =
              'انتهت مهلة الاتصال. تأكد من سرعة الإنترنت وحاول مرة أخرى';
        } else if (errorString.contains('no internet') ||
            errorString.contains('network unreachable')) {
          errorMessage =
              'لا يوجد اتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى';
        } else {
          errorMessage = 'حدث خطأ في تحميل المنتجات. حاول مرة أخرى';
        }
      }

      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: errorMessage,
        ),
      );
    }
  }

  /// إعادة تحميل البيانات عند تغيير اللغة
  void _refreshData() {
    if (state.filter.departmentId != null ||
        state.filter.mainCategoryId != null ||
        state.filter.subCategoryId != null ||
        (state.filter.keyword != null && state.filter.keyword!.isNotEmpty)) {
      refresh();
    }
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/services/location_service.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/categories/domain/entities/product_filter.dart';
import 'package:test/features/categories/domain/usecases/get_all_products_usecase.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';

/// Cubit إدارة فلترة المنتجات
class ProductsFilterCubit extends Cubit<ProductsFilterState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final DataRefreshService? dataRefreshService;

  List<Product> _allProducts = [];
  int _currentPage = 1;
  bool _isLoading = false;

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
    _currentPage = 1;
    _allProducts.clear();
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

    _currentPage = 1;
    _allProducts.clear();
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

    _currentPage = 1;
    _allProducts.clear();
    _loadProducts();
  }

  /// تحديد الفئة الفرعية
  void updateSubCategory(int? subCategoryId) {
    final newFilter = state.filter.copyWith(subCategoryId: subCategoryId);
    emit(state.copyWith(filter: newFilter));
    _currentPage = 1;
    _allProducts.clear();
    _loadProducts();
  }

  /// تحديد التقييم
  void updateRating(int? rating) {
    final newFilter = state.filter.copyWith(rate: rating);
    emit(state.copyWith(filter: newFilter));
    _currentPage = 1;
    _allProducts.clear();
    _loadProducts();
  }

  /// تحديد نطاق السعر
  void updatePriceRange(double? minPrice, double? maxPrice) {
    final newFilter = state.filter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    emit(state.copyWith(filter: newFilter));
    _currentPage = 1;
    _allProducts.clear();
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
    _currentPage = 1;
    _allProducts.clear();
    _loadProducts();
  }

  /// مسح جميع الفلاتر والعودة للقسم الأول
  void clearFilters({int? defaultDepartmentId}) {
    final newFilter = ProductFilter(
      departmentId: defaultDepartmentId?.toString(),
    );
    emit(ProductsFilterState(filter: newFilter));
    _currentPage = 1;
    _allProducts.clear();
    _loadProducts();
  }

  /// تحميل المزيد من المنتجات
  void loadMore() {
    //print('📄 ProductsFilter: loadMore called - _isLoading=$_isLoading, hasReachedMax=${state.hasReachedMax}');
    if (_isLoading || state.hasReachedMax) {
      //print('⏹️ ProductsFilter: loadMore blocked');
      return;
    }
    //print('➕ ProductsFilter: Loading next page ${_currentPage + 1}');
    _currentPage++;
    _loadProducts(loadMore: true);
  }

  /// إعادة تحميل المنتجات
  void refresh() {
    _currentPage = 1;
    _allProducts.clear();
    _loadProducts(refresh: true);
  }

  /// تحميل المنتجات
  Future<void> _loadProducts({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (isClosed || _isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _allProducts.clear();
    }

    _isLoading = true;

    try {
      if (_currentPage == 1) {
        emit(state.copyWith(isLoading: true, error: null));
      } else {
        emit(state.copyWith(isLoadingMore: true, products: _allProducts));
      }

      // Get current region ID from LocationService
      int? regionId;
      try {
        final locationService = LocationService.instance;
        regionId = locationService.selectedRegion?.id;
      } catch (e) {
        // LocationService not initialized, continue without region filter
        ////print('⚠️ LocationService not available: $e');
      }

      // Create filter with current region ID and page
      final filterWithRegion = state.filter.copyWith(
        regionId: regionId,
        page: _currentPage,
      );
      final response = await getAllProductsUseCase.call(filterWithRegion);

      if (response.success && response.data != null) {
        final newProducts = response.data!.data;

        //print('📦 ProductsFilter: Received ${newProducts.length} products for page $_currentPage');

        if (_currentPage == 1) {
          _allProducts = newProducts;
        } else {
          _allProducts.addAll(newProducts);
        }

        //print('📋 ProductsFilter: Total products now: ${_allProducts.length}');

        _isLoading = false;

        if (!isClosed) {
          emit(
            state.copyWith(
              products: _allProducts,
              isLoading: false,
              isLoadingMore: false,
              currentPage: _currentPage,
              hasReachedMax: newProducts.isEmpty,
              error: null,
            ),
          );

          //print('✅ ProductsFilter: State emitted - hasMore: ${!newProducts.isEmpty}');
        }
      } else {
        _isLoading = false;
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              isLoadingMore: false,
              error: response.message,
            ),
          );
        }
      }
    } catch (e) {
      _isLoading = false;
      if (!isClosed) {
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

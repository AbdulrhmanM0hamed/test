import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/entities/home_product.dart';
import '../../../domain/entities/pagination_info.dart';
import '../../../domain/usecases/get_special_offer_products_use_case.dart';
import 'special_offer_products_state.dart';

class SpecialOfferProductsCubit extends Cubit<SpecialOfferProductsState> {
  final GetSpecialOfferProductsUseCase getSpecialOfferProductsUseCase;
  final DataRefreshService? dataRefreshService;

  List<HomeProduct> _allProducts = [];
  PaginationInfo? _paginationInfo;
  int _currentPage = 1;
  bool _isLoading = false;

  SpecialOfferProductsCubit({
    required this.getSpecialOfferProductsUseCase,
    this.dataRefreshService,
  }) : super(SpecialOfferProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getSpecialOfferProducts({bool refresh = false}) async {
    if (isClosed || _isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _allProducts.clear();
    }

    _isLoading = true;

    try {
      if (_currentPage == 1) {
        emit(SpecialOfferProductsLoading());
      } else {
        emit(SpecialOfferProductsLoadingMore(products: _allProducts));
      }

      final response = await getSpecialOfferProductsUseCase(page: _currentPage);
      _paginationInfo = response.pagination;

      if (_currentPage == 1) {
        _allProducts = response.products;
      } else {
        _allProducts.addAll(response.products);
      }

      _isLoading = false;

      if (!isClosed) {
        emit(
          SpecialOfferProductsLoaded(
            products: _allProducts,
            hasMore: _paginationInfo?.hasMore ?? false,
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      if (!isClosed) {
        emit(SpecialOfferProductsError(message: e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || (_paginationInfo?.hasMore != true)) return;
    _currentPage++;
    await getSpecialOfferProducts(refresh: false);
  }

  void _refreshData() {
    getSpecialOfferProducts(refresh: true);
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

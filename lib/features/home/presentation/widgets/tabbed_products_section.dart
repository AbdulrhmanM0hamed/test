import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../domain/entities/home_product.dart';
import '../cubits/featured_products/featured_products_cubit.dart';
import '../cubits/featured_products/featured_products_state.dart';
import '../cubits/best_seller_products/best_seller_products_cubit.dart';
import '../cubits/best_seller_products/best_seller_products_state.dart';
import '../cubits/latest_products/latest_products_cubit.dart';
import '../cubits/latest_products/latest_products_state.dart';
import '../cubits/special_offer_products/special_offer_products_cubit.dart';
import '../cubits/special_offer_products/special_offer_products_state.dart';
import 'home_product_card.dart';

enum ProductTab { specialOffers, featured, bestSellers, latest }

class TabbedProductsSection extends StatefulWidget {
  final Function(HomeProduct)? onProductTap;
  final Function(HomeProduct)? onFavoritePressed;
  final Set<int> favoriteProductIds;

  const TabbedProductsSection({
    super.key,
    this.onProductTap,
    this.onFavoritePressed,
    this.favoriteProductIds = const {},
  });

  @override
  State<TabbedProductsSection> createState() => _TabbedProductsSectionState();
}

class _TabbedProductsSectionState extends State<TabbedProductsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTabTitle(ProductTab tab) {
    switch (tab) {
      case ProductTab.specialOffers:
        return 'عروض خاصة';
      case ProductTab.featured:
        return 'منتجات مميزة';
      case ProductTab.bestSellers:
        return 'الأكثر مبيعاً';
      case ProductTab.latest:
        return 'أحدث المنتجات';
    }
  }

  IconData _getTabIcon(ProductTab tab) {
    switch (tab) {
      case ProductTab.specialOffers:
        return Icons.local_offer;
      case ProductTab.featured:
        return Icons.star;
      case ProductTab.bestSellers:
        return Icons.trending_up;
      case ProductTab.latest:
        return Icons.new_releases;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabBar(),
          SizedBox(
            height: 320,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSpecialOffersTab(),
                _buildFeaturedTab(),
                _buildBestSellersTab(),
                _buildLatestTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: getSemiBoldStyle(
          fontSize: FontSize.size13,
          fontFamily: FontConstant.cairo,
        ),
        unselectedLabelStyle: getMediumStyle(
          fontSize: FontSize.size13,
          fontFamily: FontConstant.cairo,
        ),
        tabs: ProductTab.values.map((tab) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getTabIcon(tab), size: 18),
                  const SizedBox(width: 8),
                  Text(_getTabTitle(tab)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecialOffersTab() {
    return BlocBuilder<SpecialOfferProductsCubit, SpecialOfferProductsState>(
      builder: (context, state) {
        return _buildProductGrid(
          products: state is SpecialOfferProductsLoaded ? state.products : [],
          isLoading: state is SpecialOfferProductsLoading,
          errorMessage: state is SpecialOfferProductsError
              ? state.message
              : null,
          onRetry: () => context
              .read<SpecialOfferProductsCubit>()
              .getSpecialOfferProducts(),
        );
      },
    );
  }

  Widget _buildFeaturedTab() {
    return BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
      builder: (context, state) {
        return _buildProductGrid(
          products: state is FeaturedProductsLoaded ? state.products : [],
          isLoading: state is FeaturedProductsLoading,
          errorMessage: state is FeaturedProductsError ? state.message : null,
          onRetry: () =>
              context.read<FeaturedProductsCubit>().getFeaturedProducts(),
        );
      },
    );
  }

  Widget _buildBestSellersTab() {
    return BlocBuilder<BestSellerProductsCubit, BestSellerProductsState>(
      builder: (context, state) {
        return _buildProductGrid(
          products: state is BestSellerProductsLoaded ? state.products : [],
          isLoading: state is BestSellerProductsLoading,
          errorMessage: state is BestSellerProductsError ? state.message : null,
          onRetry: () =>
              context.read<BestSellerProductsCubit>().getBestSellerProducts(),
        );
      },
    );
  }

  Widget _buildLatestTab() {
    return BlocBuilder<LatestProductsCubit, LatestProductsState>(
      builder: (context, state) {
        return _buildProductGrid(
          products: state is LatestProductsLoaded ? state.products : [],
          isLoading: state is LatestProductsLoading,
          errorMessage: state is LatestProductsError ? state.message : null,
          onRetry: () =>
              context.read<LatestProductsCubit>().getLatestProducts(),
        );
      },
    );
  }

  Widget _buildProductGrid({
    required List<HomeProduct> products,
    required bool isLoading,
    required String? errorMessage,
    required VoidCallback onRetry,
  }) {
    print(
      'Building product grid: isLoading=$isLoading, products.length=${products.length}, errorMessage=$errorMessage',
    );

    if (isLoading) {
      return _buildLoadingGrid();
    }

    if (errorMessage != null) {
      return _buildErrorState(errorMessage, onRetry);
    }

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length > 6 ? 6 : products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          print('Building product card for: ${product.name}');
          return HomeProductCard(
            product: product,
            isFavorite: widget.favoriteProductIds.contains(product.id),
            onTap: () => widget.onProductTap?.call(product),
            onFavoritePressed: () => widget.onFavoritePressed?.call(product),
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: const Center(child: CustomProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text(
              'حدث خطأ في تحميل المنتجات',
              style: getSemiBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: getMediumStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'لا توجد منتجات متاحة',
              style: getSemiBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إضافة منتجات جديدة قريباً',
              style: getMediumStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

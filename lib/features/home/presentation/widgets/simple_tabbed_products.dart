import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../domain/entities/home_product.dart';
import '../cubits/special_offer_products/special_offer_products_cubit.dart';
import '../cubits/special_offer_products/special_offer_products_state.dart';
import '../cubits/featured_products/featured_products_cubit.dart';
import '../cubits/featured_products/featured_products_state.dart';
import '../cubits/best_seller_products/best_seller_products_cubit.dart';
import '../cubits/best_seller_products/best_seller_products_state.dart';
import '../cubits/latest_products/latest_products_cubit.dart';
import '../cubits/latest_products/latest_products_state.dart';
import 'home_product_card.dart';

class SimpleTabbledProducts extends StatefulWidget {
  final Function(HomeProduct)? onProductTap;
  final Function(HomeProduct)? onFavoritePressed;

  const SimpleTabbledProducts({
    super.key,
    this.onProductTap,
    this.onFavoritePressed,
  });

  @override
  State<SimpleTabbledProducts> createState() => _SimpleTabbledProductsState();
}

class _SimpleTabbledProductsState extends State<SimpleTabbledProducts>
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_offer, size: 18),
                      SizedBox(width: 8),
                      Text('عروض خاصة'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 18),
                      SizedBox(width: 8),
                      Text('منتجات مميزة'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 18),
                      SizedBox(width: 8),
                      Text('الأكثر مبيعاً'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.new_releases, size: 18),
                      SizedBox(width: 8),
                      Text('أحدث المنتجات'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Tab Content
        SizedBox(
          height: 400,
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
    );
  }

  Widget _buildSpecialOffersTab() {
    return BlocBuilder<SpecialOfferProductsCubit, SpecialOfferProductsState>(
      builder: (context, state) {
        print('Special Offers State: $state');

        if (state is SpecialOfferProductsLoading) {
          return const Center(child: CustomProgressIndicator());
        }

        if (state is SpecialOfferProductsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text('خطأ: ${state.message}'),
                ElevatedButton(
                  onPressed: () => context
                      .read<SpecialOfferProductsCubit>()
                      .getSpecialOfferProducts(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is SpecialOfferProductsLoaded) {
          final products = state.products;
          print('Special Offers Products Count: ${products.length}');

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد عروض خاصة'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return HomeProductCard(
                  product: product,
                  onTap: () => widget.onProductTap?.call(product),
                  onFavoritePressed: () =>
                      widget.onFavoritePressed?.call(product),
                );
              },
            ),
          );
        }

        return const Center(child: Text('حالة غير معروفة'));
      },
    );
  }

  Widget _buildFeaturedTab() {
    return BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
      builder: (context, state) {
        if (state is FeaturedProductsLoading) {
          return const Center(child: CustomProgressIndicator());
        }

        if (state is FeaturedProductsError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        if (state is FeaturedProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات مميزة'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return HomeProductCard(
                  product: product,
                  onTap: () => widget.onProductTap?.call(product),
                  onFavoritePressed: () =>
                      widget.onFavoritePressed?.call(product),
                );
              },
            ),
          );
        }

        return const Center(child: Text('حالة غير معروفة'));
      },
    );
  }

  Widget _buildBestSellersTab() {
    return BlocBuilder<BestSellerProductsCubit, BestSellerProductsState>(
      builder: (context, state) {
        if (state is BestSellerProductsLoading) {
          return const Center(child: CustomProgressIndicator());
        }

        if (state is BestSellerProductsError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        if (state is BestSellerProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات الأكثر مبيعاً'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return HomeProductCard(
                  product: product,
                  onTap: () => widget.onProductTap?.call(product),
                  onFavoritePressed: () =>
                      widget.onFavoritePressed?.call(product),
                );
              },
            ),
          );
        }

        return const Center(child: Text('حالة غير معروفة'));
      },
    );
  }

  Widget _buildLatestTab() {
    return BlocBuilder<LatestProductsCubit, LatestProductsState>(
      builder: (context, state) {
        if (state is LatestProductsLoading) {
          return const Center(child: CustomProgressIndicator());
        }

        if (state is LatestProductsError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }

        if (state is LatestProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات جديدة'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return HomeProductCard(
                  product: product,
                  onTap: () => widget.onProductTap?.call(product),
                  onFavoritePressed: () =>
                      widget.onFavoritePressed?.call(product),
                );
              },
            ),
          );
        }

        return const Center(child: Text('حالة غير معروفة'));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/home/presentation/widgets/greeting_header.dart';
import 'package:test/features/home/presentation/widgets/offers_section.dart';
import 'package:test/features/home/presentation/widgets/categories_section.dart';
import 'package:test/features/home/presentation/widgets/stores/stores_showcase.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/special_offers_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/featured_products_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/best_seller_products_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/latest_products_section.dart';
import '../cubits/featured_products/featured_products_cubit.dart';
import '../cubits/best_seller_products/best_seller_products_cubit.dart';
import '../cubits/latest_products/latest_products_cubit.dart';
import '../cubits/special_offer_products/special_offer_products_cubit.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Get user name from preferences or state management
    final String username =
        'User'; // Replace with actual username from user state

    return MultiBlocProvider(
      providers: [
        BlocProvider<FeaturedProductsCubit>(
          create: (context) =>
              DependencyInjection.getIt<FeaturedProductsCubit>()
                ..getFeaturedProducts(),
        ),
        BlocProvider<BestSellerProductsCubit>(
          create: (context) =>
              DependencyInjection.getIt<BestSellerProductsCubit>()
                ..getBestSellerProducts(),
        ),
        BlocProvider<LatestProductsCubit>(
          create: (context) =>
              DependencyInjection.getIt<LatestProductsCubit>()
                ..getLatestProducts(),
        ),
        BlocProvider<SpecialOfferProductsCubit>(
          create: (context) =>
              DependencyInjection.getIt<SpecialOfferProductsCubit>()
                ..getSpecialOfferProducts(),
        ),
        BlocProvider<MainCategoryCubit>(
          create: (context) =>
              DependencyInjection.getIt<MainCategoryCubit>()..getMainCategories(),
        ),
      ],
      child: Column(
        children: [
          // Greeting and Notification Header
          GreetingHeader(
            username: username,
            location: 'Dubai, UAE', // This would come from user location state
            notificationCount: 6,
          ),

          // Scrollable Content
          Expanded(
            child: Builder(
              builder: (innerContext) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // Trigger refresh on each cubit using inner context (inside providers scope)
                    innerContext
                        .read<FeaturedProductsCubit>()
                        .getFeaturedProducts();
                    innerContext
                        .read<BestSellerProductsCubit>()
                        .getBestSellerProducts();
                    innerContext
                        .read<LatestProductsCubit>()
                        .getLatestProducts();
                    innerContext
                        .read<SpecialOfferProductsCubit>()
                        .getSpecialOfferProducts();
                    innerContext.read<MainCategoryCubit>().getMainCategories();
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Custom Search Bar
                            //  CustomSearchBar(),
                            const SizedBox(height: 20),
                            // Offers Section with Slider
                            const OffersSection(),

                            // Categories Section
                            const SizedBox(height: 20),
                            const CategoriesSection(),

                            // Special Offers Section
                            const SizedBox(height: 24),
                            SpecialOffersSection(
                              onProductTap: (product) {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: product.id,
                                );
                              },
                              onFavoritePressed: (product) {
                                // TODO: Toggle favorite
                                //print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                // TODO: Navigate to special offers page
                                //print('See all special offers');
                              },
                            ),

                            // Featured Products Section
                            const SizedBox(height: 24),
                            FeaturedProductsSection(
                              onProductTap: (product) {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: product.id,
                                );
                              },
                              onFavoritePressed: (product) {
                                // TODO: Toggle favorite
                                //print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                // TODO: Navigate to featured products page
                                //print('See all featured products');
                              },
                            ),

                            // Best Seller Products Section
                            const SizedBox(height: 24),
                            BestSellerProductsSection(
                              onProductTap: (product) {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: product.id,
                                );
                              },
                              onFavoritePressed: (product) {
                                // TODO: Toggle favorite
                                //print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                // TODO: Navigate to best seller products page
                                //print('See all best seller products');
                              },
                            ),

                            // Latest Products Section
                            const SizedBox(height: 24),
                            LatestProductsSection(
                              onProductTap: (product) {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: product.id,
                                );
                              },
                              onFavoritePressed: (product) {
                                // TODO: Toggle favorite
                                //print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                // TODO: Navigate to latest products page
                                //print('See all latest products');
                              },
                            ),

                            // Stores Showcase Section
                            const SizedBox(height: 24),
                            //  const StoresShowcaseSection(),

                            // Footer space
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

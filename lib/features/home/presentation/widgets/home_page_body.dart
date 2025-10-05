import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/features/home/presentation/widgets/home sections/sub_categories_section.dart';
import 'package:test/core/services/network/network_info.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_cubit.dart';
import 'package:test/features/categories/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/home/data/datasources/sub_categories_remote_data_source_impl.dart';
import 'package:test/features/home/data/repositories/sub_categories_repository_impl.dart';
import 'package:test/features/home/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/home/presentation/cubits/sub_categories/sub_categories_cubit.dart';
import 'package:test/features/home/presentation/widgets/greeting_header.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/featured_products_section.dart';
import 'package:test/features/home/presentation/widgets/offers_section.dart';
import 'package:test/features/home/presentation/widgets/categories_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/special_offers_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/best_seller_products_section.dart';
import 'package:test/features/home/presentation/widgets/home%20sections/latest_products_section.dart';
import 'package:test/features/home/presentation/widgets/stores/stores_showcase.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import '../cubits/featured_products/featured_products_cubit.dart';
import '../cubits/best_seller_products/best_seller_products_cubit.dart';
import '../cubits/latest_products/latest_products_cubit.dart';
import '../cubits/special_offer_products/special_offer_products_cubit.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';
import 'package:test/features/home/presentation/cubit/slider_cubit.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide ProfileCubit
        BlocProvider<ProfileCubit>(
          create: (context) =>
              DependencyInjection.getIt<ProfileCubit>()..getProfile(),
        ),
        // Provide WishlistCubit - use global instance for realtime updates
        BlocProvider<WishlistCubit>.value(
          value:
              GlobalCubitService.instance.wishlistCubit ??
              DependencyInjection.getIt<WishlistCubit>(),
        ),
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
              DependencyInjection.getIt<MainCategoryCubit>()
                ..getMainCategories(),
        ),
        BlocProvider<SliderCubit>(
          create: (context) =>
              DependencyInjection.getIt<SliderCubit>()..getSliders(),
        ),
        BlocProvider<SubCategoryCubit>(
          create: (context) => SubCategoryCubit(
            getSubCategoriesUseCase:
                DependencyInjection.getIt<GetSubCategoriesUseCase>(),
          )..getSubCategories(),
        ),
        BlocProvider<SubCategoriesCubit>(
          create: (context) => SubCategoriesCubit(
            getSubCategoriesUsecase: GetSubCategoriesUsecase(
              repository: SubCategoriesRepositoryImpl(
                remoteDataSource: SubCategoriesRemoteDataSourceImpl(
                  dioService: DependencyInjection.getIt<DioService>(),
                ),
                networkInfo: DependencyInjection.getIt<NetworkInfo>(),
              ),
            ),
          )..getSubCategories(),
        ),
      ],
      child: Column(
        children: [
          // Greeting and Notification Header

          // Scrollable Content with Refresh Indicator
          Expanded(
            child: Builder(
              builder: (innerContext) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // Trigger refresh on each cubit using inner context (inside providers scope)
                    innerContext.read<ProfileCubit>().getProfile();
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
                    innerContext.read<SubCategoryCubit>().getSubCategories();
                    innerContext.read<SliderCubit>().getSliders();
                    innerContext.read<SubCategoriesCubit>().getSubCategories();
                  },
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      // Greeting Header (Scrollable, outside refresh area)
                      SliverToBoxAdapter(
                        child: GreetingHeader(
                          location:
                              'Dubai, UAE', // This would come from user location state
                          notificationCount: 6,
                        ),
                      ),
                      // Empty space to push refresh indicator below greeting header
                      const SliverToBoxAdapter(child: SizedBox(height: 1)),
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
                                ////print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                Navigator.pushNamed(context, '/special-offers');
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
                                ////print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                Navigator.pushNamed(
                                  context,
                                  '/featured-products',
                                );
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
                                ////print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                Navigator.pushNamed(
                                  context,
                                  '/best-seller-products',
                                );
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
                                ////print('Favorite pressed: ${product.name}');
                              },
                              onSeeAll: () {
                                Navigator.pushNamed(
                                  context,
                                  '/latest-products',
                                );
                              },
                            ),

                            // Sub-Categories Sections
                            const SizedBox(height: 24),
                            SubCategoriesSection(
                              onProductTap: (product) {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: product.id,
                                );
                              },
                              onFavoritePressed: (product) {
                                // TODO: Toggle favorite
                              },
                              onSeeAll: (subCategory) {
                                // TODO: Navigate to sub category products
                              },
                            ),

                            // Stores Showcase Section
                            const SizedBox(height: 24),
                            const StoresShowcaseSection(),

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

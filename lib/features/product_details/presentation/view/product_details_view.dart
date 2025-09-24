import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/global_cubit_service.dart';
import '../../../../core/services/hybrid_wishlist_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/product_details.dart';
import '../../../categories/domain/entities/product.dart';
import '../cubit/product_details_cubit.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_reviews_section.dart';
import '../widgets/product_video_section.dart';
import '../widgets/cart_floating_button.dart';

class ProductDetailsView extends StatefulWidget {
  static const String routeName = '/product-details';

  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showFloatingCart = false;
  bool _isWishlistLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Product details will be loaded by the cubit in the route
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showFloatingCart) {
      setState(() => _showFloatingCart = true);
    } else if (_scrollController.offset <= 200 && _showFloatingCart) {
      setState(() => _showFloatingCart = false);
    }
  }

  Future<void> _toggleWishlist(
    int productId,
    bool isCurrentlyInWishlist,
  ) async {
    if (_isWishlistLoading) return;

    setState(() {
      _isWishlistLoading = true;
    });

    try {
      // Get the product details from the cubit state instead of route arguments
      final state = context.read<ProductDetailsCubit>().state;
      if (state is ProductDetailsLoaded) {
        final product = state.productDetails;
        // Convert ProductDetails to Product entity for the service
        final firstSizeColor = product.productSizeColor.first;
        final realPrice = double.tryParse(firstSizeColor.realPrice) ?? 0.0;
        final fakePrice = firstSizeColor.fakePrice != null
            ? double.tryParse(firstSizeColor.fakePrice!)
            : null;
        final discount = firstSizeColor.discount != null
            ? int.tryParse(firstSizeColor.discount!) ?? 0
            : 0;

        final productEntity = Product(
          id: product.id,
          name: product.name,
          slug: product.slug,
          description: product.summary,
          image: product.image,
          realPrice: realPrice,
          fakePrice: fakePrice,
          discount: discount,
          star: product.star,
          numOfUserReview: product.numOfUserReview,
          stock: product.stock,
          isFav: firstSizeColor.isFav == "1",
          isBest: firstSizeColor.isBest,
          brandName: product.brandName,
          brandLogo: product.brandLogo,
          limitation: product.limitation,
          countOfAvailable: product.countOfAvailable,
          countOfReviews: product.numOfUserReview,
          currency: AppLocalizations.of(context)!.currency,
          quantityInCart: firstSizeColor.quantityInCart,
          productSizeColorId: firstSizeColor.id,
        );


        await HybridWishlistService.instance.toggleWishlistForProduct(
          productEntity,
        );
      } else {
        // Fallback to ID-only method
        await HybridWishlistService.instance.toggleWishlistByProductId(
          productId,
        );
      }
    } catch (error) {
      // Error handling is done in the HybridWishlistService
      print('Error toggling wishlist: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isWishlistLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if GlobalCubitService is initialized and cubits are available
    final globalService = GlobalCubitService.instance;
    final cartCubit = globalService.cartCubit;
    final wishlistCubit = globalService.wishlistCubit;

    // If not initialized or cubits are null, create new instances
    final providers = <BlocProvider>[];

    if (cartCubit != null) {
      providers.add(BlocProvider.value(value: cartCubit));
    } else {
      providers.add(
        BlocProvider(
          create: (context) => DependencyInjection.getIt<CartCubit>(),
        ),
      );
    }

    if (wishlistCubit != null) {
      providers.add(BlocProvider.value(value: wishlistCubit));
    } else {
      providers.add(
        BlocProvider(
          create: (context) => DependencyInjection.getIt<WishlistCubit>(),
        ),
      );
    }

    return MultiBlocProvider(
      providers: providers,
      child: Scaffold(
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CustomProgressIndicator());
            }

            if (state is ProductDetailsError) {
              return _buildErrorState(state.message);
            }

            if (state is ProductDetailsLoaded) {
              return _buildProductDetailsContent(state.productDetails);
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: _showFloatingCart
            ? BlocProvider.value(
                value: cartCubit ?? DependencyInjection.getIt<CartCubit>(),
                child: const CartFloatingButton(),
              )
            : null,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: getMediumStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Retry loading product details
              final args = ModalRoute.of(context)?.settings.arguments as int?;
              if (args != null) {
                context.read<ProductDetailsCubit>().getProductDetails(args);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsContent(ProductDetails product) {
    // Get cart cubit for nested widgets
    final globalService = GlobalCubitService.instance;
    final cartCubit = globalService.cartCubit;
    final wishlistCubit = globalService.wishlistCubit;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        BlocProvider.value(
          value: wishlistCubit ?? DependencyInjection.getIt<WishlistCubit>(),
          child: _buildAppBar(product),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProductImageGallery(
                mainImage: product.image,
                images: product.productImages.map((e) => e.image).toList(),
              ),
              const SizedBox(height: 16),
              BlocProvider.value(
                value: cartCubit ?? DependencyInjection.getIt<CartCubit>(),
                child: ProductInfoSection(product: product),
              ),
              const SizedBox(height: 24),
              _buildTabSection(product),
              const SizedBox(height: 24),

              // Video section
              if (product.videoLink != null && product.videoLink!.isNotEmpty)
                ProductVideoSection(videoLink: product.videoLink),

              // Reviews section
              ProductReviewsSection(
                reviews: product.userReviews,
                productId: product.id,
                productName: product.name,
                onReviewAdded: () {
                  // Refresh product details to get updated reviews
                  context.read<ProductDetailsCubit>().getProductDetails(
                    product.id,
                  );
                },
              ),
              const SizedBox(height: 100), // Space for floating cart
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(ProductDetails product) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      title: Text(
        product.name,
        style: getBoldStyle(
          fontSize: FontSize.size16,
          fontFamily: FontConstant.cairo,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [
        ListenableBuilder(
          listenable: HybridWishlistService.instance,
          builder: (context, child) {
            return FutureBuilder<bool>(
              future: HybridWishlistService.instance.isInWishlist(product.id),
              initialData: false,
              builder: (context, futureSnapshot) {
                bool isInWishlist = futureSnapshot.data ?? false;

                return IconButton(
                  onPressed: _isWishlistLoading
                      ? null
                      : () => _toggleWishlist(product.id, isInWishlist),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isInWishlist
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isWishlistLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist ? AppColors.error : null,
                            size: 20,
                          ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTabSection(ProductDetails product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 2,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[650],
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            labelStyle: getSemiBoldStyle(
              fontSize: FontSize.size15,
              fontFamily: FontConstant.cairo,
            ),
            unselectedLabelStyle: getMediumStyle(
              fontSize: FontSize.size15,
              fontFamily: FontConstant.cairo,
            ),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.description),
              Tab(text: AppLocalizations.of(context)!.features),
              Tab(text: AppLocalizations.of(context)!.specifications),
              Tab(text: AppLocalizations.of(context)!.shipping),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHtmlContent(product.details),
                _buildHtmlContent(product.features),
                _buildSpecifications(product),
                _buildShippingInfo(product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlContent(String htmlContent) {
    // Remove HTML tags and display as plain text
    final cleanText = htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        cleanText,
        style: getMediumStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: Colors.grey[650],
        ),
      ),
    );
  }

  Widget _buildSpecifications(ProductDetails product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow(
            AppLocalizations.of(context)!.material,
            product.material,
          ),
          _buildSpecRow(
            AppLocalizations.of(context)!.stock,
            '${product.stock} ${AppLocalizations.of(context)!.pieces}',
          ),
          _buildSpecRow(
            AppLocalizations.of(context)!.available,
            '${product.countOfAvailable} ${AppLocalizations.of(context)!.pieces}',
          ),
          _buildSpecRow(
            AppLocalizations.of(context)!.salesCount,
            '${product.numberOfSale}',
          ),
          _buildSpecRow(
            AppLocalizations.of(context)!.viewsCount,
            '${product.views}',
          ),
          _buildSpecRow(
            AppLocalizations.of(context)!.orderLimit,
            '${product.limitation} ${AppLocalizations.of(context)!.pieces}',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[650],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[650],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(ProductDetails product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product.shipping,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey[650],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${AppLocalizations.of(context)!.shippingAvailableTo}: ${product.cityName}',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[650],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/product_details.dart';
import '../cubit/product_details_cubit.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_reviews_section.dart';
import '../widgets/product_video_section.dart';
import '../widgets/add_review_section.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          ? const CartFloatingButton()
          : null,
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
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildAppBar(product),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProductImageGallery(
                mainImage: product.image,
                images: product.productImages.map((e) => e.image).toList(),
              ),
              const SizedBox(height: 16),
              ProductInfoSection(product: product),
              const SizedBox(height: 24),
              _buildTabSection(product),
              const SizedBox(height: 24),
              
              // Video section
              if (product.videoLink != null && product.videoLink!.isNotEmpty)
                ProductVideoSection(videoLink: product.videoLink),

              // Reviews section
              if (product.userReviews.isNotEmpty)
                ProductReviewsSection(reviews: product.userReviews),
              
              // Add review section
              AddReviewSection(
                productId: product.id,
                onReviewAdded: () {
                  // TODO: Refresh reviews after adding new review
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
          
            size: 20,
          ),
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
        IconButton(
          onPressed: () {
            // TODO: Add to favorites
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_border,
              
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTabSection(ProductDetails product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
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
          color: Colors.grey[800],
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
                color: Colors.grey[700],
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
                color: Colors.grey[800],
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
                    color: Colors.grey[800],
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
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

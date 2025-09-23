import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/features/categories/presentation/widgets/product_card_professional.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/product_details/presentation/view/product_details_view.dart';
import 'package:test/l10n/app_localizations.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    // Update the filter cubit with the search query
    context.read<ProductsFilterCubit>().updateKeyword(query);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductsFilterCubit>().updateKeyword('');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            MediaQuery.of(context).size.height * _slideAnimation.value,
          ),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildSearchBar(context),
                  Expanded(child: _buildSearchResults(context)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.close, color: Colors.grey[600], size: 20),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.searchProducts,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Search indicator
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12), // subtle background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Colors.white,
          ),
          cursorColor: Colors.white70,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            hintStyle: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                AppAssets.searchIcon,
                width: 18,
                height: 18,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            suffixIcon: _isSearching
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.clear,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 18,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppAssets.icon_filter,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withValues(alpha: 0.8),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<ProductsFilterCubit, ProductsFilterState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoadingState();
        }

        if (state.error != null) {
          return _buildErrorState(state.error!);
        }

        final products = state.products;

        if (!_isSearching) {
          return _buildEmptySearchState();
        }

        if (products.isEmpty) {
          return _buildNoResultsState();
        }

        return _buildProductGrid(products);
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loading,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.searchIcon,
            width: 80,
            height: 80,
            colorFilter: ColorFilter.mode(Colors.grey[300]!, BlendMode.srcIn),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.searchHint,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.searchProducts,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noProductsFound,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tryDifferentKeywords,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.66,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return CustomAnimations.slideFromBottom(
            child: ProductCardProfessional(
              product: product,
              onTap: () {
                // Navigate to product details
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  ProductDetailsView.routeName,
                  arguments: product.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

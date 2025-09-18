import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/entities/home_product.dart';

class HomeProductCard extends StatefulWidget {
  final HomeProduct product;
  final VoidCallback? onTap;

  const HomeProductCard({super.key, required this.product, this.onTap});

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;
  bool _isInWishlist = false;

  @override
  void initState() {
    super.initState();

    // Initialize wishlist state from product data
    _isInWishlist = widget.product.isFavorite;
    print(
      '🔍 HomeProductCard: Product ${widget.product.id} - isFavorite: ${widget.product.isFavorite}, _isInWishlist: $_isInWishlist',
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _isPressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() => _isPressed = false);
        print('🔍 Home: Product tapped: ${widget.product.name}');
        // Let parent handle navigation
        widget.onTap?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProductImage(),
                    Flexible(child: _buildProductDetails()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        Hero(
          tag: 'home_product_${widget.product.id}_${widget.product.hashCode}',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 130,
              width: double.infinity,
              color: const Color.fromARGB(255, 240, 233, 211),
              child: CachedNetworkImage(
                imageUrl: widget.product.image,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CustomProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Product badges
        Positioned(
          top: 8,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [if (widget.product.isBest) _buildBestSellerBadge()],
          ),
        ),

        // Discount badge - Bottom left
        if (widget.product.hasDiscount)
          Positioned(bottom: 8, left: 8, child: _buildDiscountBadge()),

        // Favorite button - Fixed position on top left
        Positioned(top: 8, left: 8, child: _buildFavoriteButton()),

        // Stock indicator
        if (!widget.product.isAvailable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                color: Colors.black.withValues(alpha: 0.6),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'غير متوفر',
                    style: getBoldStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${widget.product.discount}%',
        style: getBoldStyle(
          fontSize: FontSize.size11,
          fontFamily: FontConstant.cairo,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBestSellerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppLocalizations.of(context)!.bestSellers,
        style: getBoldStyle(
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return BlocProvider(
      create: (context) => DependencyInjection.getIt<WishlistCubit>(),
      child: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state is WishlistItemAdded &&
              state.productId == widget.product.id) {
            setState(() {
              _isInWishlist = true;
            });
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
          } else if (state is WishlistItemRemoved &&
              state.productId == widget.product.id) {
            setState(() {
              _isInWishlist = false;
            });
            CustomSnackbar.showWarning(
              context: context,
              message: state.message,
            );
          } else if (state is WishlistError) {
            CustomSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          final wishlistCubit = context.read<WishlistCubit>();

          return GestureDetector(
            onTap: () {
              // Prevent multiple taps while loading
              if (state is WishlistLoading) return;

              if (_isInWishlist) {
                wishlistCubit.removeFromWishlist(widget.product.id);
              } else {
                wishlistCubit.addToWishlist(widget.product.id);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: state is WishlistLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[600]!,
                        ),
                      ),
                    )
                  : Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: _isInWishlist ? Colors.red : Colors.grey[600],
                      size: 18,
                    ),
            ),
          );
        },
      ),
    );
  }

  String _formatPrice(String price) {
    // Remove .00 from prices like "9,000.00"
    if (price.endsWith('.00')) {
      return price.substring(0, price.length - 3);
    }
    return price;
  }

  String _limitProductName(String name) {
    // Limit product name to maximum 3 words
    final words = name.split(' ');
    if (words.length <= 2) {
      return name;
    }
    return '${words.take(2).join(' ')}...';
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand name with logo
          if (widget.product.brandName.isNotEmpty) ...[
            Row(
              children: [
                // Brand logo
                if (widget.product.brandLogo != null &&
                    widget.product.brandLogo!.isNotEmpty) ...[
                  CachedNetworkImage(
                    imageUrl: widget.product.brandLogo!,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 6),
                ],
                // Brand name
                Flexible(
                  child: Text(
                    widget.product.brandName,
                    style: getMediumStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey[650],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // Product name
          Text(
            _limitProductName(widget.product.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 8),

          // Price, Rating and Add to Cart in one row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price and Rating Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price
                    Text(
                      '${_formatPrice(widget.product.price)} ج.م',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.starIcon,
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.product.star}',
                          style: getSemiBoldStyle(
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '(${widget.product.reviewCount})',
                          style: getMediumStyle(
                            fontSize: FontSize.size10,
                            fontFamily: FontConstant.cairo,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add to Cart Button
              BlocProvider(
                create: (context) => DependencyInjection.getIt<CartCubit>(),
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is CartItemAdded &&
                        state.productId == widget.product.id) {
                      CustomSnackbar.showSuccess(
                        context: context,
                        message: state.message,
                      );
                    } else if (state is CartError) {
                      CustomSnackbar.showError(
                        context: context,
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    final cartCubit = context.read<CartCubit>();
                    final isLoading =
                        state is CartItemAdding &&
                        state.productId == widget.product.id;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              if (widget.product.productSizeColorId != null) {
                                cartCubit.addToCart(
                                  productId: widget.product.id,
                                  productSizeColorId:
                                      widget.product.productSizeColorId!,
                                  quantity: 1,
                                );
                              } else {
                                CustomSnackbar.showWarning(
                                  context: context,
                                  message: 'معلومات المنتج غير مكتملة',
                                );
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 0,
                              offset: const Offset(-1, -1),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 0,
                              offset: const Offset(1, 1),
                              spreadRadius: 0.5,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Discount Price
          if (widget.product.hasDiscount &&
              widget.product.originalPrice != null) ...[
            const SizedBox(height: 8),
            Text(
              '${_formatPrice(widget.product.originalPrice!)} ج.م',
              style: TextStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],

          const SizedBox(height: 6),

          // Stock status and quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Availability text
              Text(
                widget.product.availabilityText,
                style: getMediumStyle(
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                  color: widget.product.isAvailable ? Colors.green : Colors.red,
                ),
              ),

              // Stock Quantity
              if (widget.product.stock > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'متوفر ${widget.product.stock}',
                    style: getMediumStyle(
                      fontSize: FontSize.size10,
                      fontFamily: FontConstant.cairo,
                      color: Colors.green[700],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

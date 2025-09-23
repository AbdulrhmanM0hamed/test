import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/core/services/cart_global_service.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../domain/entities/product.dart';

class ProductCardProfessional extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardProfessional({super.key, required this.product, this.onTap});

  @override
  State<ProductCardProfessional> createState() =>
      _ProductCardProfessionalState();
}

class _ProductCardProfessionalState extends State<ProductCardProfessional>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;
  bool _isAddingToCart = false;
  bool _isInWishlist = false;
  bool _isWishlistLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize wishlist state from product data
    _isInWishlist = widget.product.isFavorite;
    print(
      '🔍 ProductCardProfessional: Product ${widget.product.id} - isFavorite: ${widget.product.isFavorite}, _isInWishlist: $_isInWishlist',
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
        // Let parent handle navigation
        widget.onTap?.call();
      }
    });
  }

  String _limitProductName(String name) {
    // Limit product name to maximum 2 words
    final words = name.split(' ');
    if (words.length <= 2) {
      return name;
    }
    return '${words.take(2).join(' ')}...';
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
          tag: 'category_product_${widget.product.id}',
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
                    AppLocalizations.of(context)!.notAvailable,
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
        '${widget.product.discountPercentage.toStringAsFixed(0)}%',
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
    return BlocConsumer<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state is WishlistItemAdded &&
            state.productId == widget.product.id) {
          setState(() {
            _isInWishlist = true;
            _isWishlistLoading = false;
          });
          // Remove snackbar - handled by WishlistView
        } else if (state is WishlistItemRemoved &&
            state.productId == widget.product.id) {
          setState(() {
            _isInWishlist = false;
            _isWishlistLoading = false;
          });
          // Remove snackbar - handled by WishlistView
        } else if (state is WishlistError) {
          // Reset loading for this product on error
          setState(() {
            _isWishlistLoading = false;
          });
          // Only show error snackbar for this specific product
          if (state.toString().contains('${widget.product.id}')) {
            CustomSnackbar.showError(context: context, message: state.message);
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // Prevent multiple taps while this product is loading
            if (_isWishlistLoading) return;

            debugPrint(
              '❤️ ProductCardProfessional: ${_isInWishlist ? 'Removing' : 'Adding'} product ${widget.product.id} ${_isInWishlist ? 'from' : 'to'} wishlist',
            );

            // Set loading state for this specific product
            setState(() {
              _isWishlistLoading = true;
            });

            // Use global service for wishlist operations
            if (_isInWishlist) {
              GlobalCubitService.instance
                  .removeFromWishlist(widget.product.id)
                  .then((_) {
                    if (mounted) {
                      setState(() {
                        _isInWishlist = false;
                        _isWishlistLoading = false;
                      });
                    }
                  })
                  .catchError((error) {
                    if (mounted) {
                      setState(() {
                        _isWishlistLoading = false;
                      });
                    }
                  });
            } else {
              GlobalCubitService.instance
                  .addToWishlist(widget.product.id)
                  .then((_) {
                    if (mounted) {
                      setState(() {
                        _isInWishlist = true;
                        _isWishlistLoading = false;
                      });
                    }
                  })
                  .catchError((error) {
                    if (mounted) {
                      setState(() {
                        _isWishlistLoading = false;
                      });
                    }
                  });
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
            child: _isWishlistLoading
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
    );
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
                if (widget.product.brandLogo.isNotEmpty) ...[
                  CachedNetworkImage(
                    imageUrl: widget.product.brandLogo,
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
                      color: Colors.grey[600],
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
                      '${widget.product.finalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primary,
                      ),
                    ),
                    if (widget.product.hasDiscount) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${widget.product.originalPrice.toStringAsFixed(0)} ${widget.product.currency}',
                        style: TextStyle(
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    // Rating
                    if (widget.product.rating >= 0)
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.starIcon,
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.product.rating}',
                            style: getSemiBoldStyle(
                              fontSize: FontSize.size11,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${widget.product.reviewsCount})',
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

              // Add to Cart Button with Visual Indicator
              StreamBuilder<CartEvent>(
                stream: CartGlobalService.instance.cartEventStream,
                builder: (context, eventSnapshot) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      // Calculate current quantity in cart and available quantity
                      final currentQuantity =
                          widget.product.quantityInCart ?? 0;
                      // Use the minimum of limitation and stock to respect both constraints
                      final maxAllowed = widget.product.limitation > 0
                          ? (widget.product.limitation < widget.product.stock
                                ? widget.product.limitation
                                : widget.product.stock)
                          : widget.product.stock;
                      final canAddMore = currentQuantity < maxAllowed;
                      final isInCart = currentQuantity > 0;

                      // Always show Add to Cart button with visual indicator
                      return GestureDetector(
                        onTap:
                            (_isAddingToCart ||
                                !widget.product.isAvailable ||
                                !canAddMore)
                            ? null
                            : () async {
                                setState(() {
                                  _isAddingToCart = true;
                                });

                                try {
                                  final cartCubit = context.read<CartCubit>();

                                  // Use productSizeColorId if available, otherwise use product id as fallback
                                  final sizeColorId =
                                      widget.product.productSizeColorId ??
                                      widget.product.id;

                                  await cartCubit.addToCart(
                                    productId: widget.product.id,
                                    productSizeColorId: sizeColorId,
                                    quantity: currentQuantity + 1,
                                  );

                                  debugPrint(
                                    '✅ CategoryProductCard: Product added successfully',
                                  );
                                } catch (e) {
                                  CustomSnackbar.showError(
                                    context: context,
                                    message: AppLocalizations.of(
                                      context,
                                    )!.failedToAddToCart,
                                  );
                                } finally {
                                  setState(() {
                                    _isAddingToCart = false;
                                  });
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            // Different background color if product is in cart
                            color: isInCart
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : (widget.product.isAvailable && canAddMore)
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isInCart
                                  ? AppColors.primary.withValues(alpha: 0.5)
                                  : (widget.product.isAvailable && canAddMore)
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: isInCart ? 2 : 1,
                            ),
                            boxShadow:
                                (widget.product.isAvailable && canAddMore)
                                ? [
                                    BoxShadow(
                                      color: isInCart
                                          ? AppColors.primary.withValues(
                                              alpha: 0.6,
                                            )
                                          : AppColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                      blurRadius: isInCart ? 2 : 0,
                                      offset: const Offset(0, 2),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      blurRadius: 0,
                                      offset: const Offset(-1, -1),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 0,
                                      offset: const Offset(1, 1),
                                      spreadRadius: 0.5,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 0.5,
                                    ),
                                  ]
                                : [],
                          ),
                          child: _isAddingToCart
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
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isInCart
                                          ? Icons.shopping_cart
                                          : Icons.add_shopping_cart_rounded,
                                      size: 18,
                                      color:
                                          (widget.product.isAvailable &&
                                              canAddMore)
                                          ? AppColors.primary
                                          : Colors.grey,
                                    ),
                                    // Show quantity badge if product is in cart
                                    if (isInCart) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          '$currentQuantity',
                                          style: getBoldStyle(
                                            fontSize: FontSize.size10,
                                            fontFamily: FontConstant.cairo,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Stock status and quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Stock quantity
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
                    widget.product.isAvailable
                        ? '${AppLocalizations.of(context)?.available}  ${widget.product.stock}'
                        : '${AppLocalizations.of(context)?.notAvailable}',
                    style: getMediumStyle(
                      fontSize: FontSize.size10,
                      fontFamily: FontConstant.cairo,
                      color: widget.product.isAvailable
                          ? Colors.green
                          : Colors.red,
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

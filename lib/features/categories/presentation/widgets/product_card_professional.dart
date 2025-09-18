import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  const ProductCardProfessional({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
  });

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

  @override
  void initState() {
    super.initState();

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
    return GestureDetector(
      onTap: widget.onFavoritePressed,
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
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.grey[600],
          size: 18,
        ),
      ),
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
                      '${widget.product.finalPrice.toStringAsFixed(0)} ${widget.product.currency}',
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

              // Add to Cart Button
              GestureDetector(
                onTap: () {
                  // TODO: Implement add to cart functionality
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
                      // Bottom shadow (darker)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                      // Middle shadow
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 0,
                        offset: const Offset(-1, -1),
                      ),
                      // Top highlight
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 0,
                        offset: const Offset(1, 1),
                        spreadRadius: 0.5,
                      ),
                      // Soft outer glow
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
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

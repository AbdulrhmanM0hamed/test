import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../domain/entities/home_product.dart';

class HomeProductCard extends StatefulWidget {
  final HomeProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  const HomeProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
  });

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard>
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
          tag: 'product_${widget.product.id}',
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
            children: [
              if (widget.product.hasDiscount) _buildDiscountBadge(),
              if (widget.product.isBest) ...[
                const SizedBox(height: 4),
                _buildBestSellerBadge(),
              ],
              if (widget.product.isFeatured) ...[
                const SizedBox(height: 4),
                _buildFeaturedBadge(),
              ],
            ],
          ),
        ),

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
        'الأكثر مبيعاً',
        style: getBoldStyle(
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildFeaturedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'مميز',
        style: getBoldStyle(
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
          color: Colors.white,
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
    if (words.length <= 3) {
      return name;
    }
    return words.take(3).join(' ') + '...';
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand name
          if (widget.product.brandName.isNotEmpty) ...[
            Text(
              widget.product.brandName,
              style: getMediumStyle(
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
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

          // Rating
          Row(
            children: [
              SvgPicture.asset(AppAssets.starIcon, width: 14, height: 14),
              const SizedBox(width: 4),
              Text(
                '${widget.product.star}',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${widget.product.reviewCount})',
                style: getMediumStyle(
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Price section
          Row(
            children: [
              Text(
                '${_formatPrice(widget.product.price)} ج.م',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primary,
                ),
              ),
              if (widget.product.hasDiscount &&
                  widget.product.originalPrice != null) ...[
                const SizedBox(width: 8),
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
            ],
          ),

          const SizedBox(height: 6),

          // Stock status and quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stock status
              Text(
                widget.product.availabilityText,
                style: getMediumStyle(
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                  color: widget.product.isAvailable ? Colors.green : Colors.red,
                ),
              ),
              // Stock quantity
              if (widget.product.stock > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
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

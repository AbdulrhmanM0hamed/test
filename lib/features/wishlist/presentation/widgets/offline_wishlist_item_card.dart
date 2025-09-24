import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/services/hybrid_cart_service.dart';
import 'package:test/core/services/hybrid_wishlist_service.dart';
import 'package:test/features/product_details/presentation/view/product_details_view.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';

class OfflineWishlistItemCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  const OfflineWishlistItemCard({super.key, required this.product, this.onTap});

  @override
  State<OfflineWishlistItemCard> createState() =>
      _OfflineWishlistItemCardState();
}

class _OfflineWishlistItemCardState extends State<OfflineWishlistItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;
  bool _isAddingToCart = false;

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
    Navigator.pushNamed(
      context,
      ProductDetailsView.routeName,
      arguments: widget.product['id'] ?? 0,
    );
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
            scale: _isPressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildProductImage(),
                  Expanded(child: _buildProductDetails()),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final productImage = widget.product['image'] as String? ?? '';
    final isAvailable = (widget.product['countOfAvailable'] as int? ?? 0) > 0;
    final isBest = widget.product['isBest'] as bool? ?? false;
    final productId = widget.product['id'] ?? 0;

    return Hero(
      tag: 'offline_wishlist_product_$productId',
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 240, 233, 211),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: productImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: productImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CustomProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    ),
            ),
            // Status badge
            if (isBest)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.bestSellers,
                    style: getBoldStyle(
                      fontSize: FontSize.size9,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            // Stock indicator
            if (!isAvailable)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.outOfStock,
                        style: getBoldStyle(
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    final productName = widget.product['name'] as String? ?? 'Unknown Product';
    final price = widget.product['originalPrice'] ?? widget.product['price'];
    final isAvailable = (widget.product['countOfAvailable'] as int? ?? 0) > 0;
    final star = widget.product['star'] as num? ?? 0;
    final reviewCount = widget.product['reviewCount'] as int? ?? 0;
    final brandName = widget.product['brandName'] as String? ?? '';
    final brandLogo = widget.product['brandLogo'] as String? ?? '';
    final hasDiscount = widget.product['hasDiscount'] as bool? ?? false;
    final fakePrice = widget.product['fakePrice'] ?? widget.product['oldPrice'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand name
          if (brandName.isNotEmpty) ...[
            Row(
              children: [
                if (brandLogo.isNotEmpty) ...[
                  CachedNetworkImage(
                    imageUrl: brandLogo,
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
                Flexible(
                  child: Text(
                    brandName,
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
            productName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontSize: FontSize.size14,
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
                '$star',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviewCount)',
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
                '$price ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: AppColors.primary,
                ),
              ),
              if (hasDiscount && fakePrice != null) ...[
                const SizedBox(width: 8),
                Text(
                  '$fakePrice ج.م',
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

          const SizedBox(height: 4),

          // Stock status
          Text(
            isAvailable ? 'متوفر' : AppLocalizations.of(context)!.outOfStock,
            style: getMediumStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: isAvailable ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isAvailable = (widget.product['countOfAvailable'] as int? ?? 0) > 0;
    final productId = widget.product['id'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Remove from wishlist button
          GestureDetector(
            onTap: () async {
              await HybridWishlistService.instance.removeFromWishlist(
                productId,
              );
              CustomSnackbar.showWarning(
                context: context,
                message: 'تم حذف المنتج من المفضلة',
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.favorite, color: Colors.red, size: 20),
            ),
          ),

          const SizedBox(height: 12),

          // Add to cart button (if available)
          if (isAvailable)
            GestureDetector(
              onTap: (_isAddingToCart || !isAvailable)
                  ? null
                  : () async {
                      setState(() {
                        _isAddingToCart = true;
                      });

                      try {
                        debugPrint(
                          '🛒 OfflineWishlistItemCard: Adding product $productId to cart',
                        );

                        // Use hybrid service for cart operations
                        await HybridCartService.instance.addToCart(
                          product: widget.product,
                          productSizeColorId: 1, // Default for offline
                          quantity: 1,
                        );

                        // Show success snackbar
                        CustomSnackbar.showSuccess(
                          context: context,
                          message:
                              '${AppLocalizations.of(context)!.addedToCart} ${widget.product['name']} ${AppLocalizations.of(context)!.toCart}',
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isAvailable
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: _isAddingToCart
                    ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.shopping_cart_outlined,
                        color: isAvailable ? AppColors.primary : Colors.grey,
                        size: 20,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

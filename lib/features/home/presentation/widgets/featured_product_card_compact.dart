import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/services/hybrid_cart_service.dart';
import 'package:test/core/services/hybrid_wishlist_service.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import '../../domain/entities/home_product.dart';

class FeaturedProductCardCompact extends StatefulWidget {
  final HomeProduct product;
  final double width;
  final VoidCallback? onTap;

  const FeaturedProductCardCompact({
    super.key,
    required this.product,
    required this.width,
    this.onTap,
  });

  @override
  State<FeaturedProductCardCompact> createState() =>
      _FeaturedProductCardCompactState();
}

class _FeaturedProductCardCompactState
    extends State<FeaturedProductCardCompact> {
  bool _isWishlistLoading = false;
  bool _isInWishlist = false;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _isInWishlist = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.01),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // صورة المنتج
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image,
                        width: 85,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 85,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 85,
                          height: 100,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                    // Wishlist Button على الصورة
                    Positioned(top: 6, left: 6, child: _buildWishlistButton()),

                    // Discount Badge
                    if (widget.product.discount != null &&
                        widget.product.discount! > 0)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.product.discount}%',
                            style: getBoldStyle(
                              fontSize: FontSize.size10,
                              fontFamily: FontConstant.cairo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // تفاصيل المنتج
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // اسم المنتج
                        Text(
                          widget.product.name,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 13,
                          ),
                        ),

                        // التقييم والسعر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // التقييم
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "(${widget.product.reviewCount})",
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: 11,
                                    color: AppColors.grey,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  widget.product.star.toString(),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                SvgPicture.asset(
                                  AppAssets.starIcon,
                                  width: 12,
                                  height: 12,
                                ),
                              ],
                            ),

                            // السعر
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatPrice(widget.product.price),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (widget.product.originalPrice != null)
                                  Text(
                                    _formatPrice(widget.product.originalPrice!),
                                    style:
                                        getRegularStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ).copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        // زر إضافة للسلة
                        _buildAddToCartButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Best Seller Badge
            if (widget.product.isBest)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'الأفضل',
                    style: getBoldStyle(
                      fontSize: FontSize.size9,
                      fontFamily: FontConstant.cairo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return FutureBuilder<int>(
      future: HybridCartService.instance.getProductQuantity(
        productId: widget.product.id,
        productSizeColorId: widget.product.productSizeColorId ?? 0,
      ),
      builder: (context, quantitySnapshot) {
        final currentQuantity = quantitySnapshot.data ?? 0;
        final maxAllowed = widget.product.limitation > 0
            ? (widget.product.limitation < widget.product.countOfAvailable
                  ? widget.product.limitation
                  : widget.product.countOfAvailable)
            : widget.product.countOfAvailable;
        final canAddMore = currentQuantity < maxAllowed;
        final isInCart = currentQuantity > 0;

        return GestureDetector(
          onTap: (_isAddingToCart || !widget.product.isAvailable || !canAddMore)
              ? null
              : () async {
                  if (widget.product.productSizeColorId != null) {
                    setState(() {
                      _isAddingToCart = true;
                    });

                    try {
                      await HybridCartService.instance.addToCart(
                        product: widget.product,
                        productSizeColorId: widget.product.productSizeColorId!,
                        quantity: 1,
                      );

                      CustomSnackbar.showSuccess(
                        context: context,
                        message:
                            '${AppLocalizations.of(context)!.addedToCart} ${widget.product.name}',
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
                  }
                },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: isInCart
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : (widget.product.isAvailable && canAddMore)
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isInCart
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : (widget.product.isAvailable && canAddMore)
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: _isAddingToCart
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isInCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                        size: 14,
                        color: isInCart
                            ? AppColors.primary
                            : (widget.product.isAvailable && canAddMore)
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          isInCart ? 'في السلة' : 'أضف',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 10,
                            color: isInCart
                                ? AppColors.primary
                                : (widget.product.isAvailable && canAddMore)
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildWishlistButton() {
    return GestureDetector(
      onTap: _isWishlistLoading
          ? null
          : () {
              setState(() {
                _isWishlistLoading = true;
              });

              HybridWishlistService.instance
                  .toggleWishlist(widget.product)
                  .then((_) {
                    if (mounted) {
                      setState(() {
                        _isInWishlist = !_isInWishlist;
                        _isWishlistLoading = false;
                      });

                      CustomSnackbar.showSuccess(
                        context: context,
                        message: _isInWishlist
                            ? 'تمت الإضافة للمفضلة'
                            : 'تم الحذف من المفضلة',
                      );
                    }
                  })
                  .catchError((error) {
                    if (mounted) {
                      setState(() {
                        _isWishlistLoading = false;
                      });
                      CustomSnackbar.showError(
                        context: context,
                        message: error.toString(),
                      );
                    }
                  });
            },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: _isWishlistLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                _isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: _isInWishlist ? Colors.red : Colors.grey[600],
                size: 16,
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

  bool get isAvailable {
    return widget.product.countOfAvailable > 0;
  }
}

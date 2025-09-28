import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/services/hybrid_cart_service.dart';
import 'package:test/core/services/hybrid_wishlist_service.dart';
import 'package:test/core/utils/responsive/responsive_helper.dart';
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
        height: ResponsiveHelper.getCompactCardHeight(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 10.0,
              tablet: 12.0,
              desktop: 14.0,
            ),
          ),
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
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 10.0,
                            tablet: 12.0,
                            desktop: 14.0,
                          ),
                        ),
                        bottomRight: Radius.circular(
                          ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 10.0,
                            tablet: 12.0,
                            desktop: 14.0,
                          ),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image,
                        width: ResponsiveHelper.getCompactCardImageWidth(
                          context,
                        ),
                        height: ResponsiveHelper.getCompactCardHeight(context),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: ResponsiveHelper.getCompactCardImageWidth(
                            context,
                          ),
                          height: ResponsiveHelper.getCompactCardHeight(
                            context,
                          ),
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: ResponsiveHelper.getCompactCardImageWidth(
                            context,
                          ),
                          height: ResponsiveHelper.getCompactCardHeight(
                            context,
                          ),
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 30.0,
                              tablet: 34.0,
                              desktop: 38.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Wishlist Button على الصورة
                    Positioned(
                      top: ResponsiveHelper.getResponsiveSpacing(context, 6),
                      left: ResponsiveHelper.getResponsiveSpacing(context, 6),
                      child: _buildWishlistButton(),
                    ),

                    // Discount Badge
                    if (widget.product.discount != null &&
                        widget.product.discount! > 0)
                      Positioned(
                        top: ResponsiveHelper.getResponsiveSpacing(context, 4),
                        right: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          4,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              6,
                            ),
                            vertical: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              2,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 6.0,
                                tablet: 7.0,
                                desktop: 8.0,
                              ),
                            ),
                          ),
                          child: Text(
                            '${widget.product.discount}%',
                            style: getBoldStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                FontSize.size10,
                              ),
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
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsiveSpacing(context, 8),
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
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              12,
                            ),
                          ),
                        ),

                        // التقييم والسعر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // التقييم
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "(${widget.product.reviewCount})",
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              9,
                                            ),
                                        color: AppColors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        ResponsiveHelper.getResponsiveSpacing(
                                          context,
                                          2,
                                        ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.product.star.toString(),
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              9,
                                            ),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        ResponsiveHelper.getResponsiveSpacing(
                                          context,
                                          2,
                                        ),
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.starIcon,
                                    width: ResponsiveHelper.getResponsiveValue(
                                      context,
                                      mobile: 12.0,
                                      tablet: 14.0,
                                      desktop: 16.0,
                                    ),
                                    height: ResponsiveHelper.getResponsiveValue(
                                      context,
                                      mobile: 12.0,
                                      tablet: 14.0,
                                      desktop: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // السعر
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatPrice(widget.product.price),
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize:
                                          ResponsiveHelper.getResponsiveFontSize(
                                            context,
                                            10,
                                          ),
                                      color: AppColors.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                  if (widget.product.originalPrice != null)
                                    Text(
                                      _formatPrice(
                                        widget.product.originalPrice!,
                                      ),
                                      style:
                                          getRegularStyle(
                                            fontFamily: FontConstant.cairo,
                                            fontSize:
                                                ResponsiveHelper.getResponsiveFontSize(
                                                  context,
                                                  8,
                                                ),
                                            color: Colors.grey.shade600,
                                          ).copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                ],
                              ),
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
                top: ResponsiveHelper.getResponsiveSpacing(context, 4),
                left: ResponsiveHelper.getResponsiveSpacing(context, 4),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      6,
                    ),
                    vertical: ResponsiveHelper.getResponsiveSpacing(context, 2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 6.0,
                        tablet: 7.0,
                        desktop: 8.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'الأفضل',
                    style: getBoldStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        FontSize.size9,
                      ),
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
                            '${AppLocalizations.of(context)!.addedToCart} ${widget.product.name} ${AppLocalizations.of(context)!.toCart}',
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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 8),
              vertical: ResponsiveHelper.getResponsiveSpacing(context, 5),
            ),
            decoration: BoxDecoration(
              color: isInCart
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : (widget.product.isAvailable && canAddMore)
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6.0,
                  tablet: 7.0,
                  desktop: 8.0,
                ),
              ),
              border: Border.all(
                color: isInCart
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : (widget.product.isAvailable && canAddMore)
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: _isAddingToCart
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 14.0,
                          tablet: 16.0,
                          desktop: 18.0,
                        ),
                        color: AppColors.primary,
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          3,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.addingToCart,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              10,
                            ),
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isInCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 14.0,
                          tablet: 16.0,
                          desktop: 18.0,
                        ),
                        color: isInCart
                            ? AppColors.primary
                            : (widget.product.isAvailable && canAddMore)
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          3,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          isInCart
                              ? AppLocalizations.of(context)!.inCart
                              : AppLocalizations.of(context)!.add,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              10,
                            ),
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
                    }
                  })
                  .catchError((error) {
                    if (mounted) {
                      setState(() {
                        _isWishlistLoading = false;
                      });
                    }
                  });
            },
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSpacing(context, 5),
        ),
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
            ? SizedBox(
                width: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 14.0,
                  tablet: 16.0,
                  desktop: 18.0,
                ),
                height: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 14.0,
                  tablet: 16.0,
                  desktop: 18.0,
                ),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                _isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: _isInWishlist ? Colors.red : Colors.grey[600],
                size: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 16.0,
                  tablet: 18.0,
                  desktop: 20.0,
                ),
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

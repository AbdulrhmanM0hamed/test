import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/features/product_details/presentation/view/product_details_view.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../domain/entities/wishlist_item.dart';
import '../cubit/wishlist_cubit.dart';

class WishlistItemCard extends StatefulWidget {
  final WishlistItem item;
  final VoidCallback? onTap;

  const WishlistItemCard({super.key, required this.item, this.onTap});

  @override
  State<WishlistItemCard> createState() => _WishlistItemCardState();
}

class _WishlistItemCardState extends State<WishlistItemCard>
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
      arguments: widget.item.product.id,
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
    return Container(
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
            child: CachedNetworkImage(
              imageUrl: widget.item.product.image,
              width: double.infinity,
              height: double.infinity,
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
          // Status badge
          if (widget.item.product.isBest)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
          if (!widget.item.product.isAvailable)
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
    );
  }

  Widget _buildProductDetails() {
 

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand name
          if (widget.item.wishlistProduct.brandName.isNotEmpty) ...[
            Row(
              children: [
                if (widget.item.wishlistProduct.brandLogo.isNotEmpty) ...[
                  CachedNetworkImage(
                    imageUrl: widget.item.wishlistProduct.brandLogo,
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
                    widget.item.wishlistProduct.brandName,
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
            widget.item.product.name,
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
                '${widget.item.product.star}',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${widget.item.product.numOfUserReview})',
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
                '${widget.item.product.formattedPrice} ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: AppColors.primary,
                ),
              ),
              if (widget.item.product.hasDiscount) ...[
                const SizedBox(width: 8),
                Text(
                  '${widget.item.product.fakePrice} ج.م',
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
            widget.item.product.availabilityText,
            style: getMediumStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: widget.item.product.isAvailable
                  ? Colors.green
                  : Colors.red,
            ),
          ),

          // Color variant if available
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Remove from wishlist button
          GestureDetector(
            onTap: () {
              context.read<WishlistCubit>().removeFromWishlist(
                widget.item.product.id,
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
          if (widget.item.product.isAvailable)
            GestureDetector(
              onTap: (_isAddingToCart || !widget.item.product.isAvailable)
                  ? null
                  : () async {
                      if (widget.item.product.productSizeColorId > 0) {
                        setState(() {
                          _isAddingToCart = true;
                        });

                        try {
                          debugPrint(
                            '🛒 WishlistItemCard: Adding product ${widget.item.product.id} to cart',
                          );

                          // Use global service for cart operations
                          await GlobalCubitService.instance.addToCart(
                            productId: widget.item.product.id,
                            productSizeColorId:
                                widget.item.product.productSizeColorId,
                            quantity: 1,
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
                      } else {
                        CustomSnackbar.showWarning(
                          context: context,
                          message: AppLocalizations.of(
                            context,
                          )!.incompleteProductInfo,
                        );
                      }
                    },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.item.product.isAvailable
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.item.product.isAvailable
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
                        color: widget.item.product.isAvailable
                            ? AppColors.primary
                            : Colors.grey,
                        size: 20,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/features/product_details/presentation/view/product_details_view.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/responsive/responsive_helper.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRemoving = false;
  bool _isUpdating = false;
  late int _localQuantity;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _localQuantity = widget.cartItem.quantity;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local quantity if the cart item quantity changed from external source
    if (oldWidget.cartItem.quantity != widget.cartItem.quantity &&
        !_isUpdating) {
      setState(() {
        _localQuantity = widget.cartItem.quantity;
      });
    }
  }

  void _updateQuantityWithDebounce(int newQuantity) {
    setState(() {
      _localQuantity = newQuantity;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      widget.onQuantityChanged?.call(newQuantity);
    });
  }

  void _showLimitationMessage(int maxQuantity, int limitation) {
    String message;

    if (limitation > 0 && _localQuantity >= limitation) {
      // Product-specific limitation reached
      message =
          '${AppLocalizations.of(context)!.maxAllowedQuantity} $limitation ${AppLocalizations.of(context)!.forThisProduct}';
    } else if (_localQuantity >= maxQuantity) {
      // Stock limitation reached
      message =
          '${AppLocalizations.of(context)!.onlyAvailable} $maxQuantity ${AppLocalizations.of(context)!.inStock}';
    } else {
      // General limitation message
      message = AppLocalizations.of(context)!.cannotAddMoreItems;
    }

    CustomSnackbar.showWarning(context: context, message: message);
  }

  void _handleRemove() async {
    setState(() => _isRemoving = true);

    await _controller.reverse();
    widget.onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        // Reset updating state if there was an error
        if (state is CartError) {
          setState(() => _isUpdating = false);
        }
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailsView.routeName,
                arguments: widget.cartItem.product.id,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
                vertical: ResponsiveHelper.getResponsiveSpacing(context, 8),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveValue(
                    context,
                    smallMobile: 10.0,
                    mobile: 12.0,
                    tablet: 14.0,
                    desktop: 16.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsiveSpacing(context, 16),
                ),
                child: Row(
                  children: [
                    // Product Image
                    _buildProductImage(),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(context, 16),
                    ),

                    // Product Details
                    Expanded(child: _buildProductDetails()),

                    // Actions Column
                    _buildActionsColumn(),
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
    return Hero(
      tag:
          'cart_product_${widget.cartItem.product.id}_${widget.cartItem.productSizeColorId}_${widget.cartItem.hashCode}',
      child: Container(
        width: ResponsiveHelper.getResponsiveValue(
          context,
          smallMobile: 60.0,
          mobile: 70.0,
          tablet: 80.0,
          desktop: 90.0,
        ),
        height: ResponsiveHelper.getResponsiveValue(
          context,
          smallMobile: 60.0,
          mobile: 70.0,
          tablet: 80.0,
          desktop: 90.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveValue(
              context,
              smallMobile: 10.0,
              mobile: 10.0,
              tablet: 12.0,
              desktop: 14.0,
            ),
          ),
          color: const Color.fromARGB(255, 240, 233, 211),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getResponsiveValue(
              context,
              smallMobile: 10.0,
              mobile: 10.0,
              tablet: 12.0,
              desktop: 14.0,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.cartItem.product.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(child: CustomProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: ResponsiveHelper.getResponsiveValue(
                  context,
                  smallMobile: 24.0,
                  mobile: 28.0,
                  tablet: 32.0,
                  desktop: 36.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.cartItem.product.name,
          style: getBoldStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
            fontFamily: FontConstant.cairo,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 4)),

        // Size and Color Info

        // Price and Rating
        Row(
          children: [
            Text(
              '${widget.cartItem.product.realPrice} ${AppLocalizations.of(context)?.currency}',
              style: getBoldStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 8)),
            if (widget.cartItem.product.star > 0) ...[
              SvgPicture.asset(
                AppAssets.starIcon,
                width: ResponsiveHelper.getResponsiveValue(
                  context,
                  smallMobile: 10.0,
                  mobile: 10.0,
                  tablet: 12.0,
                  desktop: 14.0,
                ),
                height: ResponsiveHelper.getResponsiveValue(
                  context,
                  smallMobile: 10.0,
                  mobile: 10.0,
                  tablet: 12.0,
                  desktop: 14.0,
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsiveSpacing(context, 2),
              ),
              Text(
                '${widget.cartItem.product.star}',
                style: getMediumStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 11),
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 4)),

        // Stock Status
        Text(
          widget.cartItem.isAvailable
              ? AppLocalizations.of(context)!.available
              : AppLocalizations.of(context)!.notAvailable,
          style: getMediumStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 11),
            fontFamily: FontConstant.cairo,
            color: widget.cartItem.isAvailable ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  // Helper method to build quantity control buttons
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    Color? iconColor,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey[100]
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDisabled
              ? Colors.grey[300]!
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            size: 16,
            color: isDisabled
                ? Colors.grey[400]
                : (iconColor ?? AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isRemoving ? null : _handleRemove,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          ),
          child: Icon(
            Icons.delete_outline,
            color: _isRemoving ? Colors.grey[400] : Colors.red,
            size: 20,
          ),
        ),
      ),
    );
  }

  // Widget _buildRemoveButton() {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: _isRemoving ? null : _handleRemove,
  //       borderRadius: BorderRadius.circular(8),
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.red.withValues(alpha:0.05),
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Colors.red.withValues(alpha:0.2)),
  //         ),
  //         child: Icon(
  //           Icons.delete_outline,
  //           color: _isRemoving ? Colors.grey[400] : Colors.red,
  //           size: 20,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionsColumn() {
    // Check if this item is currently being updated
    final cartState = context.watch<CartCubit>().state;
    _isUpdating =
        cartState is CartItemUpdating &&
        cartState.cartItemId == widget.cartItem.id;

    final currentQuantity = _localQuantity;
    // Get product limitation and stock from cart item
    final limitation = widget.cartItem.product.limitation;
    final stock = widget.cartItem.product.stock;
    final maxQuantity = limitation > 0 ? (limitation < stock ? limitation : stock) : stock;
    
    final canIncrease = currentQuantity < maxQuantity;
    final canDecrease = currentQuantity > 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Remove Button
        _buildRemoveButton(),
        const SizedBox(height: 16),
        // Quantity Controls
        if (_isUpdating) ...[
          const SizedBox(
            width: 100,
            height: 32,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ),
        ] else ...[
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease Button
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: canDecrease
                      ? () => _updateQuantityWithDebounce(currentQuantity - 1)
                      : null,
                  isDisabled: !canDecrease,
                ),

                // Quantity Display
                Container(
                  width: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                    ),
                  ),
                  child: Text(
                    '$currentQuantity',
                    style: getBoldStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                // Increase Button
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: canIncrease
                      ? () => _updateQuantityWithDebounce(currentQuantity + 1)
                      : () => _showLimitationMessage(maxQuantity, limitation),
                  isDisabled: false, // Always enabled to show limitation message
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/features/product_details/presentation/view/product_details_view.dart';
import 'package:test/l10n/app_localizations.dart';

class OfflineCartItemCard extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;

  const OfflineCartItemCard({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  State<OfflineCartItemCard> createState() => _OfflineCartItemCardState();
}

class _OfflineCartItemCardState extends State<OfflineCartItemCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRemoving = false;
  final bool _isUpdating = false;
  late int _localQuantity;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _localQuantity = widget.cartItem['quantity'] as int? ?? 1;

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
  void didUpdateWidget(OfflineCartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newQuantity = widget.cartItem['quantity'] as int? ?? 1;
    if (oldWidget.cartItem['quantity'] != newQuantity && !_isUpdating) {
      setState(() {
        _localQuantity = newQuantity;
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

  void _handleRemove() async {
    setState(() => _isRemoving = true);

    await _controller.reverse();
    widget.onRemove?.call();
  }

  Widget _buildProductImage(String productImage, String productId) {
    return Hero(
      tag: 'offline_cart_product_$productId',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 240, 233, 211),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: productImage,
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
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(
    BuildContext context,
    String productName,
    double realPrice,
    double star,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          productName,
          style: getBoldStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Price and Rating
        Row(
          children: [
            Text(
              '$realPrice ${AppLocalizations.of(context)?.currency}',
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            if (star > 0) ...[
              SvgPicture.asset(AppAssets.starIcon, width: 12, height: 12),
              const SizedBox(width: 2),
              Text(
                '$star',
                style: getMediumStyle(
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Stock Status
        Text(
          AppLocalizations.of(context)!.available,
          style: getMediumStyle(
            fontSize: FontSize.size11,
            fontFamily: FontConstant.cairo,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

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

  Widget _buildActionsColumn(BuildContext context) {
    final currentQuantity = _localQuantity;
    final canIncrease = currentQuantity < 99; // Max quantity limit
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
                      : null,
                  isDisabled: !canIncrease,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      //print('Building OfflineCartItemCard with data: ${widget.cartItem}');

      // Extract product data safely
      final productData =
          widget.cartItem['product'] as Map<String, dynamic>? ?? {};
      final productName = productData['name']?.toString() ?? 'Unknown Product';
      final productImage = productData['image']?.toString() ?? '';
      final productId = productData['id']?.toString() ?? '';

      // Handle price parsing more safely
      double realPrice = 0.0;
      if (productData['realPrice'] != null) {
        realPrice = double.tryParse(productData['realPrice'].toString()) ?? 0.0;
      } else if (productData['price'] != null) {
        realPrice = double.tryParse(productData['price'].toString()) ?? 0.0;
      } else if (productData['originalPrice'] != null) {
        realPrice =
            double.tryParse(productData['originalPrice'].toString()) ?? 0.0;
      }

      final star =
          double.tryParse(productData['star']?.toString() ?? '0') ?? 0.0;

      //print('Parsed data - Name: $productName, Price: $realPrice, Quantity: $_localQuantity');

      return SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailsView.routeName,
                arguments: widget.cartItem['product']['id'],
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Product Image
                    _buildProductImage(productImage, productId),
                    const SizedBox(width: 16),

                    // Product Details
                    Expanded(
                      child: _buildProductDetails(
                        context,
                        productName,
                        realPrice,
                        star,
                      ),
                    ),

                    // Actions Column
                    _buildActionsColumn(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      // //debugprint('🛒 OfflineCartItemCard: Error parsing cart item: $e');
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Failed to parse cart item',
                style: TextStyle(color: Colors.red),
              ),
            ),
            if (widget.onRemove != null)
              GestureDetector(
                onTap: widget.onRemove,
                child: Icon(Icons.delete_outline, color: Colors.red),
              ),
          ],
        ),
      );
    }
  }
}

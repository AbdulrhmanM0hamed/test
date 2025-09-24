import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/services/offline_cart_service.dart';
import 'package:test/core/services/hybrid_cart_service.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/auth/presentation/view/login_view.dart';
import 'package:test/features/cart/presentation/widgets/offline_cart_item_card.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/l10n/app_localizations.dart';

class OfflineCartView extends StatefulWidget {
  const OfflineCartView({super.key});

  @override
  State<OfflineCartView> createState() => _OfflineCartViewState();
}

class _OfflineCartViewState extends State<OfflineCartView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _loadCartItems();

    // Listen to hybrid cart service events to refresh cart when items are added
    HybridCartService.instance.addListener(_refreshCart);
  }

  @override
  void dispose() {
    HybridCartService.instance.removeListener(_refreshCart);
    _animationController.dispose();
    super.dispose();
  }

  void _refreshCart() {
    if (mounted) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await OfflineCartService.instance.getCartItems();

      // Debug: Print cart items structure
      //debugprint('🛒 OfflineCartView: Loaded ${items.length} cart items');
      for (int i = 0; i < items.length; i++) {
        //debugprint('🛒 Item $i: ${items[i]}');
      }

      // Calculate total price
      double totalPrice = 0.0;
      for (var item in items) {
        final product = item['product'] as Map<String, dynamic>?;
        final quantity = item['quantity'] as int? ?? 1;

        if (product != null) {
          final priceStr = product['price'] as String? ?? '0';
          final price = double.tryParse(priceStr) ?? 0.0;
          totalPrice += price * quantity;
        }
      }

      setState(() {
        _cartItems = items;
        _totalPrice = totalPrice;
        _isLoading = false;
      });
    } catch (e) {
      //debugprint('🛒 OfflineCartView: Error loading cart items: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load cart items: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeFromCart(int productId, int productSizeColorId) async {
    try {
      await OfflineCartService.instance.removeFromCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
      await _loadCartItems(); // Refresh the cart

      // Notify hybrid service to update badges
      HybridCartService.instance.notifyListeners();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.productRemovedFromCart,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove item from cart: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateQuantity(
    int productId,
    int productSizeColorId,
    int newQuantity,
  ) async {
    if (newQuantity <= 0) {
      await _removeFromCart(productId, productSizeColorId);
      return;
    }

    try {
      await OfflineCartService.instance.updateQuantity(
        productId: productId,
        productSizeColorId: productSizeColorId,
        newQuantity: newQuantity,
      );
      await _loadCartItems(); // Refresh the cart
    } catch (e) {
      CustomSnackbar.showError(
        context: context,
        message: 'Failed to update quantity',
      );
    }
  }

  Future<void> _clearCart() async {
    try {
      await OfflineCartService.instance.clearCart();
      await _loadCartItems(); // Refresh the cart
      CustomSnackbar.showSuccess(
        context: context,
        message: 'Cart cleared successfully',
      );
    } catch (e) {
      CustomSnackbar.showError(
        context: context,
        message: 'Failed to clear cart',
      );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)!.cartTitle,
        style: getBoldStyle(
          fontSize: FontSize.size20,
          fontFamily: FontConstant.cairo,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      actions: [
        if (_cartItems.isNotEmpty)
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Colors.red, size: 24),
            onPressed: () => _showClearCartDialog(),
            tooltip: AppLocalizations.of(context)!.clearAll,
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? const Center(child: CustomProgressIndicator())
            : _cartItems.isEmpty
            ? _buildEmptyCart()
            : _buildCartContent(),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.cartEmpty,
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.cartEmptyMessage,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: CustomButton(
              onPressed: () {
                BottomNavBar.navigateToHome();
              },

              text: AppLocalizations.of(context)!.startShopping,
              backgroundColor: AppColors.primary,
              height: 56,
              prefix: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Login prompt for offline users
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.loginToSyncCart,
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = _cartItems[index];
              return OfflineCartItemCard(
                cartItem: cartItem,
                onRemove: () => _removeFromCart(
                  cartItem['productId'],
                  cartItem['productSizeColorId'],
                ),
                onQuantityChanged: (newQuantity) => _updateQuantity(
                  cartItem['productId'],
                  cartItem['productSizeColorId'],
                  newQuantity,
                ),
              );
            },
          ),
        ),

        // Cart summary
        _buildCartSummary(),
      ],
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.subTotal,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[650],
                ),
              ),
              Text(
                '${_totalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.taxes,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[650],
                ),
              ),
              Text(
                '0${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              Text(
                '${_totalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () => _showLoginPrompt(),
              text: AppLocalizations.of(context)!.completeOrder,
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.completeOrder,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.loginToSyncCart,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginView.routeName);
            },
            child: Text(
              AppLocalizations.of(context)!.login,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.clearCart,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.clearCartConfirmation,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearCart();
            },
            child: Text(
              AppLocalizations.of(context)!.clearAll,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

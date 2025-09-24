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
      debugPrint('🛒 OfflineCartView: Loaded ${items.length} cart items');
      for (int i = 0; i < items.length; i++) {
        debugPrint('🛒 Item $i: ${items[i]}');
      }

      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('🛒 OfflineCartView: Error loading cart items: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.cart,
          style: getBoldStyle(
            fontSize: FontSize.size20,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              onPressed: () => _showClearCartDialog(),
              icon: Icon(Icons.delete_outline, color: Colors.red),
            ),
        ],
      ),
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
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: getSemiBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your cart to see them here',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Continue Shopping',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
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
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Login to sync your cart and complete your purchase',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.total,
                  style: getBoldStyle(
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
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
            const SizedBox(height: 16),
            CustomButton(
              text: 'Login to Checkout',
              onPressed: () => _showLoginPrompt(),
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Required',
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          'Please login to complete your purchase and sync your cart.',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
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
              // Navigate to login screen - you can implement this based on your routing
              // Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Login',
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
          'Clear Cart',
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
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
              'Clear',
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

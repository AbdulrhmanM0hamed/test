import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/services/cart_global_service.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/l10n/app_localizations.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Listen to cart global service events to refresh cart when items are added
    CartGlobalService.instance.cartEventStream.listen((event) {
      if (event == CartEvent.itemAdded) {
        // Refresh cart data when item is added from other screens
        context.read<CartCubit>().getCart();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(context, state),
            body: state is CartLoading
                ? _buildLoadingState()
                : state is CartEmpty
                ? _buildEmptyState(context)
                : state is CartLoaded
                ? _buildLoadedState(context, state)
                : state is CartItemUpdating
                ? _buildLoadedStateFromUpdating(context, state)
                : state is CartError
                ? _buildErrorState(context, state)
                : _buildLoadingState(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CartState state) {
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
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoaded && state.cart.isNotEmpty) {
              return IconButton(
                icon: Icon(Icons.delete_sweep, color: Colors.red, size: 24),
                onPressed: () => _showClearCartDialog(context),
                tooltip: AppLocalizations.of(context)!.clearAll,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CustomProgressIndicator());
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildLoadedState(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = state.cart.items[index];
              return CartItemCard(
                cartItem: cartItem,
                onRemove: () =>
                    context.read<CartCubit>().removeFromCart(cartItem.id),
                onQuantityChanged: (newQuantity) {
                  // Use the new updateCartItemQuantity method which handles all the logic
                  context.read<CartCubit>().updateCartItemQuantity(
                    cartItemId: cartItem.id,
                    newQuantity: newQuantity,
                    productId: cartItem.product.id,
                    productSizeColorId: cartItem.productSizeColorId,
                  );
                },
              );
            },
          ),
        ),

        // Cart Summary
        _buildCartSummary(context, state),
      ],
    );
  }

  Widget _buildLoadedStateFromUpdating(
    BuildContext context,
    CartItemUpdating state,
  ) {
    // Use the cart data from the updating state to avoid showing loading
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = state.cart.items[index];
              return CartItemCard(
                cartItem: cartItem,
                onRemove: () =>
                    context.read<CartCubit>().removeFromCart(cartItem.id),
                onQuantityChanged: (newQuantity) {
                  context.read<CartCubit>().updateCartItemQuantity(
                    cartItemId: cartItem.id,
                    newQuantity: newQuantity,
                    productId: cartItem.product.id,
                    productSizeColorId: cartItem.productSizeColorId,
                  );
                },
              );
            },
          ),
        ),

        // Cart Summary - create a CartLoaded state to reuse the existing method
        _buildCartSummary(context, CartLoaded(state.cart)),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartLoaded state) {
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
                '${state.cart.totalProductPrice} ${AppLocalizations.of(context)!.currency}',
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
                '${state.cart.totalTaxAmount}${AppLocalizations.of(context)!.currency}',
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
                '${state.cart.totalPrice} ${AppLocalizations.of(context)!.currency}',
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
              onPressed: () {
                Navigator.pushNamed(context, '/checkout');
              },

              text: AppLocalizations.of(context)!.completeOrder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CartError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.error,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<CartCubit>().getCart(),
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, CartState state) {
    // Only show snackbars for cart operations that happen within CartView
    // Don't show snackbars for CartItemAdded as it's handled by the component that triggered the action
    if (state is CartItemRemoved) {
      CustomSnackbar.showWarning(context: context, message: state.message);
    } else if (state is CartCleared) {
      CustomSnackbar.showSuccess(context: context, message: state.message);
    } else if (state is CartError) {
      CustomSnackbar.showError(context: context, message: state.message);
    }
  }

  void _showClearCartDialog(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
              onPressed: () => Navigator.pop(dialogContext),
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
                Navigator.pop(dialogContext);
                cartCubit.removeAllFromCart();
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
        );
      },
    );
  }
}

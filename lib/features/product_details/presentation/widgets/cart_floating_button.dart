import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/global_cubit_service.dart';
import '../../../../core/services/hybrid_cart_service.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../cart/presentation/widgets/cart_item_card.dart';
import '../../../cart/presentation/view/offline_cart_view.dart';

class CartFloatingButton extends StatelessWidget {
  const CartFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: HybridCartService.instance,
      builder: (context, child) {
        return FutureBuilder<int>(
          future: HybridCartService.instance.getCartItemCount(),
          initialData: 0,
          builder: (context, snapshot) {
            int cartCount = snapshot.data ?? 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showCartBottomSheet(context);
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 24),
                        if (cartCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                cartCount.toString(),
                                style: getBoldStyle(
                                  fontSize: FontSize.size10,
                                  fontFamily: FontConstant.cairo,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.cart,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final cartCubit = GlobalCubitService.instance.cartCubit;
        final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
        
        if (cartCubit != null && wishlistCubit != null) {
          // User is logged in - use online cart
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cartCubit),
              BlocProvider.value(value: wishlistCubit),
            ],
            child: const CartBottomSheet(),
          );
        } else {
          // User is offline - show offline cart as bottom sheet
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const OfflineCartView(),
          );
        }
      },
    );
  }
}

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({super.key});

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Load cart data when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalCubitService.instance.cartCubit?.getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.cart,
                      style: getBoldStyle(
                        fontSize: FontSize.size20,
                        fontFamily: FontConstant.cairo,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Cart content
              Expanded(child: _buildCartContent(context, cartState)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartContent(BuildContext context, CartState cartState) {
    if (cartState is CartLoading) {
      return const Center(child: CustomProgressIndicator());
    }

    if (cartState is CartError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              cartState.message,
              style: getMediumStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                GlobalCubitService.instance.cartCubit?.getCart();
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (cartState is CartEmpty ||
        (cartState is CartLoaded && cartState.cart.items.isEmpty)) {
      return _buildEmptyState(context);
    }

    if (cartState is CartLoaded) {
      return _buildLoadedState(context, cartState);
    }

    return const Center(child: CustomProgressIndicator());
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.startShopping,
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

  Widget _buildCartSummary(BuildContext context, CartLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${state.cart.totalProductPrice} ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.black87,
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
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${state.cart.totalTaxAmount} ${AppLocalizations.of(context)!.currency}',
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.black87,
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
                  color: Colors.black87,
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
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showCheckoutBottomSheet(context, state);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                AppLocalizations.of(context)!.checkout,
                style: getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutBottomSheet(BuildContext context, CartLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutBottomSheet(cart: state.cart),
    );
  }
}

class CheckoutBottomSheet extends StatelessWidget {
  final Cart cart;

  const CheckoutBottomSheet({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.completeOrder,
                  style: getBoldStyle(
                    fontSize: FontSize.size20,
                    fontFamily: FontConstant.cairo,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Order summary
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.orderSummary,
                    style: getBoldStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order details
                  _buildSummaryRow(
                    context,
                    AppLocalizations.of(context)!.numberOfProducts,
                    '${cart.totalQuantity}',
                  ),
                  _buildSummaryRow(
                    context,
                    AppLocalizations.of(context)!.subTotal,
                    '${cart.totalProductPrice} ${AppLocalizations.of(context)!.currency}',
                  ),
                  _buildSummaryRow(
                    context,
                    AppLocalizations.of(context)!.taxes,
                    '${cart.totalTaxAmount} ${AppLocalizations.of(context)!.currency}',
                  ),
                  const Divider(thickness: 1),
                  _buildSummaryRow(
                    context,
                    AppLocalizations.of(context)!.total,
                    '${cart.totalPrice} ${AppLocalizations.of(context)!.egp}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          // Checkout button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToCheckout(context);
                },
                text: AppLocalizations.of(context)!.checkout,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: isTotal
                ? getBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: Colors.black,
                  )
                : getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey[600],
                  ),
          ),
          const Spacer(),
          Text(
            value,
            style: isTotal
                ? getBoldStyle(
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  )
                : getSemiBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: Colors.black,
                  ),
          ),
        ],
      ),
    );
  }

  void _navigateToCheckout(BuildContext context) {
    Navigator.pushNamed(context, '/checkout');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/widgets/order_success_dialog.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/services/global_cubit_service.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/addresses_cubit.dart';
import '../cubit/promo_code_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../widgets/address_selection_section.dart';
import '../widgets/promo_code_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/order_summary_section.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/promo_code.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';

class CheckoutView extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  Address? selectedAddress;
  PromoCode? appliedPromoCode;
  String selectedPaymentMethod = 'cash_on_delivery';
  double cartTotal = 0.0;
  double shippingCost = 0.0;
  double discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Load addresses and cart data
    context.read<AddressesCubit>().getAddresses();
    _loadCartData();
  }

  void _loadCartData() {
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded) {
      setState(() {
        cartTotal = cartState.cart.totalProductPriceAsDouble;
        // Recalculate discount if promo code is applied
        if (appliedPromoCode != null) {
          discountAmount = appliedPromoCode!.calculateDiscount(cartTotal);
        }
      });
    }
  }

  void _onAddressSelected(Address address) {
    setState(() {
      selectedAddress = address;
      shippingCost = address.shippingCost;
    });
  }

  void _onPromoCodeApplied(PromoCode promoCode) {
    setState(() {
      appliedPromoCode = promoCode;
      discountAmount = promoCode.calculateDiscount(cartTotal);
    });
  }

  void _onPromoCodeRemoved() {
    setState(() {
      appliedPromoCode = null;
      discountAmount = 0.0;
    });
    context.read<PromoCodeCubit>().clearPromoCode();
  }

  void _onPaymentMethodChanged(String paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
    });
  }

  double get finalTotal => cartTotal + shippingCost - discountAmount;

  void _proceedToCheckout() {
    if (selectedAddress == null) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.pleaseSelectAddress,
      );
      return;
    }

    context.read<CheckoutCubit>().checkout(
      selectedAddress: selectedAddress!,
      promoCode: appliedPromoCode,
      cartTotal: cartTotal,
      paymentType: selectedPaymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.checkout,
          style: getBoldStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutSuccess) {
                // Refresh cart after successful order
                GlobalCubitService.instance.refreshCartAfterOrder();

                // Go back to previous page (don't create new route)
                Navigator.of(context).pop();

                // Show dialog after navigation
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => OrderSuccessDialog(
                      orderId: state.order.id.toString(),
                      onTrackOrder: () {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        // TODO: Navigate to orders page
                      },
                    ),
                  );
                });
              } else if (state is CheckoutError) {
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
              }
            },
          ),
          BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              // Update cart total when cart changes
              if (state is CartLoaded) {
                _loadCartData();
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address Selection Section
                    AddressSelectionSection(
                      selectedAddress: selectedAddress,
                      onAddressSelected: _onAddressSelected,
                    ),

                    const SizedBox(height: 24),

                    // Promo Code Section
                    PromoCodeSection(
                      appliedPromoCode: appliedPromoCode,
                      onPromoCodeApplied: _onPromoCodeApplied,
                      onPromoCodeRemoved: _onPromoCodeRemoved,
                    ),

                    const SizedBox(height: 24),

                    // Payment Method Section
                    PaymentMethodSection(
                      selectedPaymentMethod: selectedPaymentMethod,
                      onPaymentMethodChanged: _onPaymentMethodChanged,
                    ),

                    const SizedBox(height: 24),

                    // Order Summary Section
                    OrderSummarySection(
                      cartTotal: cartTotal,
                      shippingCost: shippingCost,
                      discountAmount: discountAmount,
                      finalTotal: finalTotal,
                    ),
                  ],
                ),
              ),
            ),

            // Checkout Button
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
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
      child: SafeArea(
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final isLoading = state is CheckoutLoading;

            return CustomButton(
              text:
                  '${AppLocalizations.of(context)!.placeOrder} • ${finalTotal.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
              onPressed: _proceedToCheckout,
              isLoading: isLoading,
              width: double.infinity,
              height: 56,
            );
          },
        ),
      ),
    );
  }
}

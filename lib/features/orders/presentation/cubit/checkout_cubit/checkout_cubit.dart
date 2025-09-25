import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/promo_code.dart';
import '../../../domain/usecases/checkout_usecase.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutUseCase checkoutUseCase;

  CheckoutCubit({
    required this.checkoutUseCase,
  }) : super(CheckoutInitial());

  Future<void> checkout({
    required Address selectedAddress,
    PromoCode? promoCode,
    required double cartTotal,
    String paymentType = 'cash_on_delivery',
  }) async {
    emit(CheckoutLoading());

    try {
      // Calculate discount if promo code is applied
      double discountAmount = 0.0;
      if (promoCode != null) {
        discountAmount = promoCode.calculateDiscount(cartTotal);
      }

      // Detect platform
      String orderFrom = _detectPlatform();

      // Create order entity
      final order = OrderEntity(
        userAddressId: selectedAddress.id,
        promoCodeId: promoCode?.id ,
        orderFrom: orderFrom,
        paymentType: paymentType,
        totalAmount: cartTotal - discountAmount,
        discountAmount: discountAmount > 0 ? discountAmount : null,
      );

      final result = await checkoutUseCase(CheckoutParams(order: order));

      result.fold(
        (failure) => emit(CheckoutError(failure.message)),
        (completedOrder) => emit(CheckoutSuccess(completedOrder)),
      );
    } catch (e) {
      emit(CheckoutError('An unexpected error occurred: $e'));
    }
  }

  String _detectPlatform() {
    if (Platform.isAndroid) {
      return OrderPlatform.android.value;
    } else if (Platform.isIOS) {
      return OrderPlatform.ios.value;
    } else {
      return OrderPlatform.web.value;
    }
  }

  void resetState() {
    emit(CheckoutInitial());
  }
}

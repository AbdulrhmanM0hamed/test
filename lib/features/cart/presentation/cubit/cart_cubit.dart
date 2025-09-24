import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../domain/entities/add_to_cart_request.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/remove_all_from_cart_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final RemoveAllFromCartUseCase removeAllFromCartUseCase;
  final DataRefreshService? dataRefreshService;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.removeAllFromCartUseCase,
    this.dataRefreshService,
  }) : super(CartInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getCart() async {
    emit(CartLoading());

    final result = await getCartUseCase();

    result.fold((failure) => emit(CartError(failure.message)), (cart) {
      if (cart.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    });
  }

  Future<void> addToCart({
    required int productId,
    required int productSizeColorId,
    int quantity = 1,
  }) async {
    emit(CartItemAdding(productId));

    final request = AddToCartRequest(
      items: [
        CartItemRequest(
          productId: productId,
          productSizeColorId: productSizeColorId,
          quantity: quantity,
        ),
      ],
    );

    final result = await addToCartUseCase(request);

    result.fold((failure) => emit(CartError(failure.message)), (message) async {
      emit(CartItemAdded(message, productId));
      // Refresh cart after adding item to ensure UI updates
      await getCart();
    });
  }

  Future<void> removeFromCart(int cartItemId) async {
    emit(CartItemRemoving(cartItemId));

    final result = await removeFromCartUseCase(cartItemId);

    result.fold((failure) => emit(CartError(failure.message)), (message) async {
      emit(CartItemRemoved(message, cartItemId));
      // Refresh cart after removing item
      await getCart();
    });
  }

  Future<void> removeAllFromCart() async {
    emit(CartClearing());

    final result = await removeAllFromCartUseCase();

    result.fold((failure) => emit(CartError(failure.message)), (message) {
      emit(CartCleared(message));
      emit(CartEmpty());
    });
  }

  int get cartItemCount {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.totalQuantity;
    }
    return 0;
  }

  bool get hasItems {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.isNotEmpty;
    }
    return false;
  }

  double get totalPrice {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.totalPriceAsDouble;
    }
    return 0.0;
  }

  void _refreshData() {
    getCart();
  }

  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int newQuantity,
    required int productId,
    required int productSizeColorId,
  }) async {
    if (newQuantity <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    // If we're in a loaded state, we can optimize by updating the UI immediately
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartItemUpdating(cartItemId, newQuantity, currentState.cart));

      try {
        // First remove the item
        await removeFromCartUseCase(cartItemId);

        // Then add it back with the new quantity
        final request = AddToCartRequest(
          items: [
            CartItemRequest(
              productId: productId,
              productSizeColorId: productSizeColorId,
              quantity: newQuantity,
            ),
          ],
        );

        final result = await addToCartUseCase(request);

        result.fold(
          (failure) {
            // If there's an error, revert to the previous state
            emit(currentState);
            emit(CartError(failure.message));
          },
          (_) {
            // On success, get fresh cart data without showing loading state
            _refreshCartSilently();
          },
        );
      } catch (e) {
        // If any error occurs, revert to the previous state
        emit(currentState);
        emit(CartError('Failed to update cart item quantity'));
      }
    } else {
      // Fallback for non-loaded states
      await removeFromCart(cartItemId);
      await addToCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
        quantity: newQuantity,
      );
    }
  }

  Future<void> _refreshCartSilently() async {
    final result = await getCartUseCase();

    result.fold((failure) => emit(CartError(failure.message)), (cart) {
      if (cart.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    });
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

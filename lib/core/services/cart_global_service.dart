import 'dart:async';
import 'package:flutter/foundation.dart';
import '../di/dependency_injection.dart';
import '../../features/cart/domain/entities/cart.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/cart_state.dart';

class CartGlobalService {
  static final CartGlobalService _instance = CartGlobalService._internal();
  factory CartGlobalService() => _instance;
  CartGlobalService._internal();

  static CartGlobalService get instance => _instance;

  // Stream controllers for real-time updates
  final StreamController<Cart?> _cartStreamController =
      StreamController<Cart?>.broadcast();
  final StreamController<int> _cartCountStreamController =
      StreamController<int>.broadcast();
  final StreamController<CartEvent> _cartEventController =
      StreamController<CartEvent>.broadcast();

  // Current cart data
  Cart? _currentCart;
  int _currentCount = 0;

  // Getters for streams
  Stream<Cart?> get cartStream => _cartStreamController.stream;
  Stream<int> get cartCountStream => _cartCountStreamController.stream;
  Stream<CartEvent> get cartEventStream => _cartEventController.stream;

  // Getters for current values
  Cart? get currentCart => _currentCart;
  int get currentCount => _currentCount;

  // Initialize the service
  Future<void> initialize() async {
    try {
      //debugprint('🔧 CartGlobalService: Starting initialization...');
      final cartCubit = DependencyInjection.getIt<CartCubit>();

      // Listen to cart cubit changes
      //debugprint('👂 CartGlobalService: Setting up stream listener...');
      cartCubit.stream.listen((state) {
        //debugprint('📨 CartGlobalService: Received state from CartCubit: ${state.runtimeType}');
        _handleCartStateChange(state);
      });

      // Load initial cart data
      //debugprint('📦 CartGlobalService: Loading initial cart data...');
      await cartCubit.getCart();
      //debugprint('✅ CartGlobalService: Initialization completed');
    } catch (e) {
      //debugprint('❌ CartGlobalService initialization error: $e');
    }
  }

  // Force refresh cart and update UI immediately
  Future<void> forceRefreshAndUpdate() async {
    try {
      //debugprint('🔄 CartGlobalService: Force refreshing cart...');
      final cartCubit = DependencyInjection.getIt<CartCubit>();
      await cartCubit.getCart();
    } catch (e) {
      //debugprint('❌ CartGlobalService force refresh error: $e');
    }
  }

  // Handle cart state changes from cubit
  void _handleCartStateChange(CartState state) {
    //debugprint('🔄 CartGlobalService: Handling state change: ${state.runtimeType}');

    if (state is CartLoaded) {
      //debugprint('📦 CartGlobalService: Cart loaded with ${state.cart.totalQuantity} items');
      _updateCart(state.cart);
      _broadcastEvent(CartEvent.loaded);
    } else if (state is CartEmpty) {
      //debugprint('🛒 CartGlobalService: Cart is empty');
      _updateCart(null);
      _broadcastEvent(CartEvent.cleared);
    } else if (state is CartItemAdded) {
      //debugprint('➕ CartGlobalService: Item added to cart');
      _broadcastEvent(CartEvent.itemAdded);
      // CartCubit already calls getCart() after adding, so we don't need to refresh here
      // The CartLoaded state will be emitted automatically and handled above
    } else if (state is CartItemRemoved) {
      //debugprint('➖ CartGlobalService: Item removed from cart');
      _broadcastEvent(CartEvent.itemRemoved);
      // CartCubit already calls getCart() after removing, so we don't need to refresh here
      // The CartLoaded state will be emitted automatically and handled above
    } else if (state is CartCleared) {
      //debugprint('🗑️ CartGlobalService: Cart cleared');
      _updateCart(null);
      _broadcastEvent(CartEvent.cleared);
    }
  }

  // Update cart data and notify listeners
  void _updateCart(Cart? cart) {
    _currentCart = cart;
    _currentCount = cart?.totalQuantity ?? 0;

    //debugprint('🔢 CartGlobalService: Updating cart count to $_currentCount');

    // Broadcast updates
    _cartStreamController.add(_currentCart);
    _cartCountStreamController.add(_currentCount);

    //debugprint('📡 CartGlobalService: Broadcasted cart updates');
  }

  // Broadcast cart events
  void _broadcastEvent(CartEvent event) {
    _cartEventController.add(event);
  }

  // Force refresh cart from server
  Future<void> _refreshCart() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Small delay to ensure API call completes
      final cartCubit = DependencyInjection.getIt<CartCubit>();
      await cartCubit.getCart();
    } catch (e) {
      //debugprint('Cart refresh error: $e');
    }
  }

  // Manual refresh method for external use
  Future<void> refreshCart() async {
    await _refreshCart();
  }

  // Add item to cart and trigger updates
  Future<void> addToCart({
    required int productId,
    required int productSizeColorId,
    int quantity = 1,
  }) async {
    try {
      final cartCubit = DependencyInjection.getIt<CartCubit>();
      await cartCubit.addToCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
        quantity: quantity,
      );

      // Force immediate refresh and update
      await _forceRefreshCart();
    } catch (e) {
      //debugprint('Add to cart error: $e');
    }
  }

  // Private method to force refresh cart and update streams immediately
  Future<void> _forceRefreshCart() async {
    try {
      //debugprint('🔄 CartGlobalService: Force refreshing cart data...');
      final cartCubit = DependencyInjection.getIt<CartCubit>();

      // Get fresh cart data
      await cartCubit.getCart();

      // Wait a bit for the state to be emitted
      await Future.delayed(const Duration(milliseconds: 200));

      // If state handling didn't work, manually get the current state
      final currentState = cartCubit.state;
      if (currentState is CartLoaded) {
        //debugprint('📦 CartGlobalService: Manually updating from current state');
        _updateCart(currentState.cart);
        _broadcastEvent(CartEvent.loaded);
      } else if (currentState is CartEmpty) {
        //debugprint('🛒 CartGlobalService: Manually updating - cart is empty');
        _updateCart(null);
        _broadcastEvent(CartEvent.cleared);
      }
    } catch (e) {
      //debugprint('❌ CartGlobalService force refresh error: $e');
    }
  }

  // Remove item from cart and trigger updates
  Future<void> removeFromCart(int cartItemId) async {
    try {
      final cartCubit = DependencyInjection.getIt<CartCubit>();
      await cartCubit.removeFromCart(cartItemId);
    } catch (e) {
      //debugprint('Remove from cart error: $e');
    }
  }

  // Clear all cart items
  Future<void> clearCart() async {
    try {
      final cartCubit = DependencyInjection.getIt<CartCubit>();
      await cartCubit.removeAllFromCart();
    } catch (e) {
      //debugprint('Clear cart error: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _cartStreamController.close();
    _cartCountStreamController.close();
    _cartEventController.close();
  }
}

// Cart events enum
enum CartEvent { loaded, itemAdded, itemRemoved, cleared, error }

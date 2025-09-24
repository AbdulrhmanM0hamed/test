import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/cart/domain/entities/add_to_cart_request.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/features/cart/domain/usecases/add_to_cart_usecase.dart';

/// Global singleton service to manage shared cubit instances across the app
class GlobalCubitService {
  static final GlobalCubitService _instance = GlobalCubitService._internal();
  factory GlobalCubitService() => _instance;
  GlobalCubitService._internal();

  static GlobalCubitService get instance => _instance;

  CartCubit? _cartCubit;
  WishlistCubit? _wishlistCubit;
  bool _isInitialized = false;

  /// Initialize the global cubits (should be called once from bottom nav bar)
  void initialize() {
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    if (isLoggedIn) {
      // Always reinitialize to ensure fresh cubit instances after login
      _cartCubit = DependencyInjection.getIt<CartCubit>()..getCart();
      _wishlistCubit = DependencyInjection.getIt<WishlistCubit>()
        ..getMyWishlist();
      _isInitialized = true;

      print('🌍 GlobalCubitService: Initialized with shared cubit instances');
    } else if (_isInitialized) {
      // Reset if user logged out
      reset();
    }
  }

  /// Get the shared cart cubit instance
  CartCubit? get cartCubit {
    if (!_isInitialized) {
      print('⚠️ GlobalCubitService: Not initialized, call initialize() first');
    }
    return _cartCubit;
  }

  /// Get the shared wishlist cubit instance
  WishlistCubit? get wishlistCubit {
    if (!_isInitialized) {
      print('⚠️ GlobalCubitService: Not initialized, call initialize() first');
    }
    return _wishlistCubit;
  }

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Reset the service (for logout scenarios)
  void reset() {
    _cartCubit = null;
    _wishlistCubit = null;
    _isInitialized = false;
    print('🔄 GlobalCubitService: Reset completed');
  }

  /// Force reinitialize after login (ensures fresh cubit instances)
  void forceReinitialize() {
    print('🔄 GlobalCubitService: Force reinitializing...');
    _isInitialized = false;
    initialize();
  }

  /// Refresh both cart and wishlist
  Future<void> refreshAll() async {
    if (_isInitialized) {
      print('🔄 GlobalCubitService: Refreshing cart and wishlist...');
      await Future.wait([
        if (_cartCubit != null) _cartCubit!.getCart(),
        if (_wishlistCubit != null) _wishlistCubit!.getMyWishlist(),
      ]);
      print('✅ GlobalCubitService: Refresh completed');
    }
  }

  /// Add item to cart and refresh
  Future<void> addToCart({
    required int productId,
    required int productSizeColorId,
    required int quantity,
  }) async {
    if (_cartCubit != null) {
      print('🛒 GlobalCubitService: Adding product $productId to cart');
      await _cartCubit!.addToCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
        quantity: quantity,
      );
      // Auto refresh after adding
      await _cartCubit!.getCart();
      print('✅ GlobalCubitService: Product added and cart refreshed');
    }
  }

  /// Add item to cart silently (without triggering snackbar states) - used during sync
  Future<void> addToCartSilently({
    required int productId,
    required int productSizeColorId,
    required int quantity,
  }) async {
    if (_cartCubit != null) {
      print(
        '🛒 GlobalCubitService: Adding product $productId to cart silently',
      );
      // Use the use case directly to bypass state emissions that trigger snackbars
      final addToCartUseCase = DependencyInjection.getIt
          .get<AddToCartUseCase>();
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
      result.fold(
        (failure) => throw Exception(failure.message),
        (message) =>
            print('✅ GlobalCubitService: Product $productId added silently'),
      );
    }
  }

  /// Update cart item quantity (for products already in cart)
  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int productId,
    required int productSizeColorId,
    required int newQuantity,
  }) async {
    if (_cartCubit != null) {
      print(
        '🛒 GlobalCubitService: Updating cart item $cartItemId quantity to $newQuantity',
      );
      await _cartCubit!.updateCartItemQuantity(
        cartItemId: cartItemId,
        newQuantity: newQuantity,
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
      print('✅ GlobalCubitService: Cart item quantity updated');
    }
  }

  /// Get cart item by product ID (helper method)
  int? getCartItemIdByProductId(int productId) {
    if (_cartCubit != null && _cartCubit!.state is CartLoaded) {
      final cart = (_cartCubit!.state as CartLoaded).cart;
      final cartItem = cart.getItemByProductId(productId);
      return cartItem?.id;
    }
    return null;
  }

  /// Add item to wishlist and refresh
  Future<void> addToWishlist(int productId) async {
    if (_wishlistCubit != null) {
      print('❤️ GlobalCubitService: Adding product $productId to wishlist');
      await _wishlistCubit!.addToWishlist(productId);
      // Auto refresh after adding
      await _wishlistCubit!.getMyWishlist();
      print('✅ GlobalCubitService: Product added to wishlist and refreshed');
    }
  }

  /// Remove item from wishlist and refresh
  Future<void> removeFromWishlist(int productId) async {
    if (_wishlistCubit != null) {
      print('💔 GlobalCubitService: Removing product $productId from wishlist');
      await _wishlistCubit!.removeFromWishlist(productId);
      // Auto refresh after removing
      await _wishlistCubit!.getMyWishlist();
      print(
        '✅ GlobalCubitService: Product removed from wishlist and refreshed',
      );
    }
  }

  /// Refresh cart after successful order (to clear it)
  Future<void> refreshCartAfterOrder() async {
    if (_cartCubit != null) {
      print('🛒 GlobalCubitService: Refreshing cart after successful order');
      await _cartCubit!.getCart();
      print('✅ GlobalCubitService: Cart refreshed after order');
    }
  }
}

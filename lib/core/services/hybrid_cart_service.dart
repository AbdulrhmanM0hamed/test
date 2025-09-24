import 'package:flutter/foundation.dart';
import 'auth_state_service.dart';
import 'offline_cart_service.dart';
import 'global_cubit_service.dart';
import '../../features/home/domain/entities/home_product.dart';
import '../../features/product_details/domain/entities/product_details.dart';
import '../../features/cart/presentation/cubit/cart_state.dart';

class HybridCartService extends ChangeNotifier {
  static HybridCartService? _instance;

  static HybridCartService get instance {
    _instance ??= HybridCartService._internal();
    return _instance!;
  }

  HybridCartService._internal() {
    // Listen to auth state changes
    AuthStateService.instance.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    notifyListeners();
  }

  bool get _isLoggedIn => AuthStateService.instance.isLoggedIn;

  // Add to cart - handles both online and offline
  Future<void> addToCart({
    dynamic
    product, // Can be HomeProduct, ProductDetails or Map<String, dynamic>
    required int productSizeColorId,
    int quantity = 1,
  }) async {
    if (_isLoggedIn) {
      // Use server-based cart
      int productId;
      if (product is HomeProduct) {
        productId = product.id;
      } else if (product is ProductDetails) {
        productId = product.id;
      } else {
        productId = product['id'] as int;
      }

      await GlobalCubitService.instance.addToCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
        quantity: quantity,
      );
    } else {
      // Use local cart - convert to HomeProduct if needed
      HomeProduct homeProduct;
      if (product is HomeProduct) {
        homeProduct = product;
      } else if (product is ProductDetails) {
        // Convert ProductDetails to HomeProduct
        homeProduct = HomeProduct(
          id: product.id,
          name: product.name,
          image: product.image,
          price: product.productSizeColor.first.realPrice,
          originalPrice:
              product.productSizeColor.first.fakePrice ??
              product.productSizeColor.first.realPrice,
          star: product.star,
          reviewCount: product.numOfUserReview,
          isFavorite: false,
          isBest: false,
          isFeatured: false,
          isLatest: false,
          isSpecialOffer: product.productSizeColor.first.fakePrice != null,
          limitation: product.limitation,
          countOfAvailable: product.countOfAvailable,
          quantityInCart: 0,
          brandName: product.brandName,
          brandLogo: product.brandLogo,
          productSizeColorId: productSizeColorId,
        );
      } else {
        // Convert map to HomeProduct
        final productMap = product as Map<String, dynamic>;
        homeProduct = HomeProduct(
          id: productMap['id'] as int,
          name: productMap['name'] as String,
          image: productMap['image'] as String,
          price: productMap['price'] as String,
          originalPrice:
              (productMap['originalPrice'] ??
                      productMap['oldPrice'] ??
                      productMap['price'])
                  as String,
          star: 0,
          reviewCount: 0,
          isFavorite: true,
          isBest: false,
          isFeatured: false,
          isLatest: false,
          isSpecialOffer: false,
          limitation: productMap['limitation'] as int? ?? 0,
          countOfAvailable: productMap['countOfAvailable'] as int? ?? 999,
          quantityInCart: 0,
          brandName: '',
          brandLogo: null,
          productSizeColorId: null,
        );
      }

      await OfflineCartService.instance.addToCart(
        product: homeProduct,
        productSizeColorId: productSizeColorId,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  // Update cart item quantity
  Future<void> updateQuantity({
    required int productId,
    required int productSizeColorId,
    required int newQuantity,
    int? cartItemId,
  }) async {
    if (_isLoggedIn && cartItemId != null) {
      // Use server-based cart
      await GlobalCubitService.instance.updateCartItemQuantity(
        cartItemId: cartItemId,
        productId: productId,
        productSizeColorId: productSizeColorId,
        newQuantity: newQuantity,
      );
    } else {
      // Use local cart
      await OfflineCartService.instance.updateQuantity(
        productId: productId,
        productSizeColorId: productSizeColorId,
        newQuantity: newQuantity,
      );
    }
    notifyListeners();
  }

  // Remove from cart
  Future<void> removeFromCart({
    required int productId,
    required int productSizeColorId,
    int? cartItemId,
  }) async {
    if (_isLoggedIn && cartItemId != null) {
      // Use server-based cart - need to implement removeFromCart in CartCubit
      final cartCubit = GlobalCubitService.instance.cartCubit;
      if (cartCubit != null) {
        await cartCubit.removeFromCart(cartItemId);
      }
    } else {
      // Use local cart
      await OfflineCartService.instance.removeFromCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
    }
    notifyListeners();
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    if (_isLoggedIn) {
      // Get from server cart
      final cartCubit = GlobalCubitService.instance.cartCubit;
      return cartCubit?.cartItemCount ?? 0;
    } else {
      // Get from local cart
      return await OfflineCartService.instance.getCartItemCount();
    }
  }

  // Check if product is in cart
  Future<bool> isInCart({
    required int productId,
    required int productSizeColorId,
  }) async {
    if (_isLoggedIn) {
      // Check server cart
      final cartItemId = GlobalCubitService.instance.getCartItemIdByProductId(
        productId,
      );
      return cartItemId != null;
    } else {
      // Check local cart
      return await OfflineCartService.instance.isInCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
    }
  }

  // Get product quantity in cart
  Future<int> getProductQuantity({
    required int productId,
    required int productSizeColorId,
  }) async {
    if (_isLoggedIn) {
      // Get from server cart
      final cartCubit = GlobalCubitService.instance.cartCubit;
      if (cartCubit != null && cartCubit.state is CartLoaded) {
        final cart = (cartCubit.state as CartLoaded).cart;
        final cartItem = cart.getItemByProductId(productId);
        return cartItem?.quantity ?? 0;
      }
      return 0;
    } else {
      // Get from local cart
      return await OfflineCartService.instance.getProductQuantity(
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    if (_isLoggedIn) {
      // Clear server cart
      final cartCubit = GlobalCubitService.instance.cartCubit;
      if (cartCubit != null) {
        await cartCubit.removeAllFromCart();
      }
    } else {
      // Clear local cart
      await OfflineCartService.instance.clearCart();
    }
    notifyListeners();
  }

  // Get total price
  Future<double> getTotalPrice() async {
    if (_isLoggedIn) {
      // Get from server cart
      final cartCubit = GlobalCubitService.instance.cartCubit;
      return cartCubit?.totalPrice ?? 0.0;
    } else {
      // Get from local cart
      return await OfflineCartService.instance.getTotalPrice();
    }
  }

  @override
  void dispose() {
    AuthStateService.instance.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}

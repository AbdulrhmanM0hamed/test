import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/domain/entities/home_product.dart';

class OfflineCartService {
  static const String _cartKey = 'offline_cart_items';
  static OfflineCartService? _instance;
  
  static OfflineCartService get instance {
    _instance ??= OfflineCartService._internal();
    return _instance!;
  }
  
  OfflineCartService._internal();

  // Add item to offline cart
  Future<void> addToCart({
    required HomeProduct product,
    required int productSizeColorId,
    int quantity = 1,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    // Check if item already exists
    final existingIndex = cartItems.indexWhere(
      (item) => item['productId'] == product.id && 
                item['productSizeColorId'] == productSizeColorId,
    );
    
    if (existingIndex != -1) {
      // Update quantity
      cartItems[existingIndex]['quantity'] = 
          (cartItems[existingIndex]['quantity'] as int) + quantity;
    } else {
      // Add new item
      cartItems.add({
        'productId': product.id,
        'productSizeColorId': productSizeColorId,
        'quantity': quantity,
        'product': {
          'id': product.id,
          'name': product.name,
          'image': product.image,
          'price': product.price,
          'originalPrice': product.originalPrice ?? product.price,
          'limitation': product.limitation,
          'countOfAvailable': product.countOfAvailable,
        },
        'addedAt': DateTime.now().toIso8601String(),
      });
    }
    
    await prefs.setString(_cartKey, jsonEncode(cartItems));
  }

  // Remove item from offline cart
  Future<void> removeFromCart({
    required int productId,
    required int productSizeColorId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    cartItems.removeWhere(
      (item) => item['productId'] == productId && 
                item['productSizeColorId'] == productSizeColorId,
    );
    
    await prefs.setString(_cartKey, jsonEncode(cartItems));
  }

  // Update item quantity in offline cart
  Future<void> updateQuantity({
    required int productId,
    required int productSizeColorId,
    required int newQuantity,
  }) async {
    if (newQuantity <= 0) {
      await removeFromCart(
        productId: productId,
        productSizeColorId: productSizeColorId,
      );
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    
    final existingIndex = cartItems.indexWhere(
      (item) => item['productId'] == productId && 
                item['productSizeColorId'] == productSizeColorId,
    );
    
    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity'] = newQuantity;
      await prefs.setString(_cartKey, jsonEncode(cartItems));
    }
  }

  // Get all cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(_cartKey);
    
    if (cartData == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(cartData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(
      0, 
      (sum, item) => sum + (item['quantity'] as int),
    );
  }

  // Check if product is in cart
  Future<bool> isInCart({
    required int productId,
    required int productSizeColorId,
  }) async {
    final cartItems = await getCartItems();
    return cartItems.any(
      (item) => item['productId'] == productId && 
                item['productSizeColorId'] == productSizeColorId,
    );
  }

  // Get quantity of specific product in cart
  Future<int> getProductQuantity({
    required int productId,
    required int productSizeColorId,
  }) async {
    final cartItems = await getCartItems();
    final item = cartItems.firstWhere(
      (item) => item['productId'] == productId && 
                item['productSizeColorId'] == productSizeColorId,
      orElse: () => {'quantity': 0},
    );
    return item['quantity'] as int;
  }

  // Clear all cart items
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // Get total price
  Future<double> getTotalPrice() async {
    final cartItems = await getCartItems();
    double total = 0.0;
    
    for (final item in cartItems) {
      final product = item['product'] as Map<String, dynamic>;
      final quantity = item['quantity'] as int;
      final price = product['originalPrice'] ?? product['price'];
      total += (price as num).toDouble() * quantity;
    }
    
    return total;
  }

  // Get total quantity of all items
  Future<int> getTotalQuantity() async {
    final cartItems = await getCartItems();
    int totalQuantity = 0;
    
    for (final item in cartItems) {
      totalQuantity += item['quantity'] as int;
    }
    
    return totalQuantity;
  }

  // Convert offline cart items to server format for sync
  Future<List<Map<String, dynamic>>> getCartItemsForSync() async {
    final cartItems = await getCartItems();
    return cartItems.map((item) => {
      'productId': item['productId'],
      'productSizeColorId': item['productSizeColorId'],
      'quantity': item['quantity'],
    }).toList();
  }
}

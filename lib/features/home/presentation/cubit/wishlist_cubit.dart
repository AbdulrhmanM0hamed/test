// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test/features/home/domain/usecases/wishlist_use_case.dart';
// import 'package:equatable/equatable.dart';

// part 'wishlist_state.dart';

// class WishlistCubit extends Cubit<WishlistState> {
//   final AddToWishlistUseCase _addToWishlistUseCase;
//   final RemoveFromWishlistUseCase _removeFromWishlistUseCase;
//   final GetWishlistUseCase _getWishlistUseCase;

//   // Track wishlist items locally for quick UI updates
//   final Set<int> _wishlistItems = <int>{};

//   WishlistCubit(
//     this._addToWishlistUseCase,
//     this._removeFromWishlistUseCase,
//     this._getWishlistUseCase,
//   ) : super(WishlistInitial());

//   void initializeWithProduct(int productId, bool isFavorite) {
//     if (isFavorite) {
//       _wishlistItems.add(productId);
//     }
//   }

//   Set<int> get wishlistItems => Set.unmodifiable(_wishlistItems);

//   bool isInWishlist(int productId) => _wishlistItems.contains(productId);

//   Future<void> addToWishlist(int productId) async {
//     emit(WishlistLoading());

//     try {
//       final response = await _addToWishlistUseCase(productId);
//       _wishlistItems.add(productId);
//       emit(
//         WishlistAddedSuccess(
//           productId,
//           response['message'] ?? 'Added to wishlist',
//         ),
//       );
//     } catch (e) {
//       emit(WishlistError(e.toString()));
//     }
//   }

//   Future<void> removeFromWishlist(int productId) async {
//     emit(WishlistLoading());

//     try {
//       final response = await _removeFromWishlistUseCase(productId);
//       _wishlistItems.remove(productId);
//       emit(
//         WishlistRemovedSuccess(
//           productId,
//           response['message'] ?? 'Removed from wishlist',
//         ),
//       );
//     } catch (e) {
//       emit(WishlistError(e.toString()));
//     }
//   }

//   Future<void> toggleWishlist(int productId) async {
//     if (isInWishlist(productId)) {
//       await removeFromWishlist(productId);
//     } else {
//       await addToWishlist(productId);
//     }
//   }

//   Future<void> loadWishlist() async {
//     emit(WishlistLoading());

//     try {
//       final response = await _getWishlistUseCase();
//       _wishlistItems.clear();

//       // Assuming the API returns wishlist items with product IDs
//       if (response['data'] != null && response['data'] is List) {
//         final List<dynamic> items = response['data'];
//         for (final item in items) {
//           if (item is Map<String, dynamic> && item['product_id'] != null) {
//             _wishlistItems.add(item['product_id'] as int);
//           }
//         }
//       }

//       emit(WishlistLoadedSuccess(_wishlistItems.toList()));
//     } catch (e) {
//       emit(WishlistError(e.toString()));
//     }
//   }

//   void resetState() {
//     emit(WishlistInitial());
//   }
// }

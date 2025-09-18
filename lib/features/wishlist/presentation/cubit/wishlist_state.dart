part of 'wishlist_cubit.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final WishlistResponse wishlistResponse;

  const WishlistLoaded(this.wishlistResponse);

  @override
  List<Object?> get props => [wishlistResponse];
}

class WishlistEmpty extends WishlistState {}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistItemRemoved extends WishlistState {
  final int productId;
  final String message;

  const WishlistItemRemoved(this.productId, this.message);

  @override
  List<Object?> get props => [productId, message];
}

class WishlistItemAdded extends WishlistState {
  final int productId;
  final String message;

  const WishlistItemAdded(this.productId, this.message);

  @override
  List<Object?> get props => [productId, message];
}

class WishlistCleared extends WishlistState {
  final String message;

  const WishlistCleared(this.message);

  @override
  List<Object?> get props => [message];
}

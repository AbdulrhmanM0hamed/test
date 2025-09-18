import 'package:equatable/equatable.dart';
import '../../domain/entities/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemAdding extends CartState {
  final int productId;

  const CartItemAdding(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemAdded extends CartState {
  final String message;
  final int productId;

  const CartItemAdded(this.message, this.productId);

  @override
  List<Object?> get props => [message, productId];
}

class CartItemRemoving extends CartState {
  final int cartItemId;

  const CartItemRemoving(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class CartItemRemoved extends CartState {
  final String message;
  final int cartItemId;

  const CartItemRemoved(this.message, this.cartItemId);

  @override
  List<Object?> get props => [message, cartItemId];
}

class CartItemUpdating extends CartState {
  final int cartItemId;
  final int newQuantity;

  const CartItemUpdating(this.cartItemId, this.newQuantity);

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

class CartClearing extends CartState {}

class CartCleared extends CartState {
  final String message;

  const CartCleared(this.message);

  @override
  List<Object?> get props => [message];
}

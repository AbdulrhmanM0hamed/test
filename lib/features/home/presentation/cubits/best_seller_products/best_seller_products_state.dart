import 'package:equatable/equatable.dart';
import 'package:test/features/home/domain/entities/home_product.dart';

abstract class BestSellerProductsState extends Equatable {
  const BestSellerProductsState();

  @override
  List<Object> get props => [];
}

class BestSellerProductsInitial extends BestSellerProductsState {}

class BestSellerProductsLoading extends BestSellerProductsState {}

class BestSellerProductsLoadingMore extends BestSellerProductsState {
  final List<HomeProduct> products;

  const BestSellerProductsLoadingMore({required this.products});

  @override
  List<Object> get props => [products];
}

class BestSellerProductsLoaded extends BestSellerProductsState {
  final List<HomeProduct> products;
  final bool hasMore;

  const BestSellerProductsLoaded({required this.products, required this.hasMore});

  @override
  List<Object> get props => [products, hasMore];
}

class BestSellerProductsError extends BestSellerProductsState {
  final String message;

  const BestSellerProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

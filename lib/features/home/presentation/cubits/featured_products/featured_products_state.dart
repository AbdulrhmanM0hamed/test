import 'package:equatable/equatable.dart';
import '../../../domain/entities/home_product.dart';

abstract class FeaturedProductsState extends Equatable {
  const FeaturedProductsState();

  @override
  List<Object> get props => [];
}

class FeaturedProductsInitial extends FeaturedProductsState {}

class FeaturedProductsLoading extends FeaturedProductsState {}

class FeaturedProductsLoadingMore extends FeaturedProductsState {
  final List<HomeProduct> products;

  const FeaturedProductsLoadingMore({required this.products});

  @override
  List<Object> get props => [products];
}

class FeaturedProductsLoaded extends FeaturedProductsState {
  final List<HomeProduct> products;
  final bool hasMore;

  const FeaturedProductsLoaded({required this.products, required this.hasMore});

  @override
  List<Object> get props => [products, hasMore];
}

class FeaturedProductsError extends FeaturedProductsState {
  final String message;

  const FeaturedProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

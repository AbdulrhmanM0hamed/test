import 'package:equatable/equatable.dart';
import 'package:test/features/home/domain/entities/home_product.dart';

abstract class FeaturedProductsState extends Equatable {
  const FeaturedProductsState();

  @override
  List<Object> get props => [];
}

class FeaturedProductsInitial extends FeaturedProductsState {}

class FeaturedProductsLoading extends FeaturedProductsState {}

class FeaturedProductsLoaded extends FeaturedProductsState {
  final List<HomeProduct> products;

  const FeaturedProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class FeaturedProductsError extends FeaturedProductsState {
  final String message;

  const FeaturedProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

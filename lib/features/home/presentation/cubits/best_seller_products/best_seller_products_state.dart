import 'package:equatable/equatable.dart';
import 'package:test/features/home/domain/entities/home_product.dart';

abstract class BestSellerProductsState extends Equatable {
  const BestSellerProductsState();

  @override
  List<Object> get props => [];
}

class BestSellerProductsInitial extends BestSellerProductsState {}

class BestSellerProductsLoading extends BestSellerProductsState {}

class BestSellerProductsLoaded extends BestSellerProductsState {
  final List<HomeProduct> products;

  const BestSellerProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class BestSellerProductsError extends BestSellerProductsState {
  final String message;

  const BestSellerProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:test/features/home/domain/entities/home_product.dart';

abstract class LatestProductsState extends Equatable {
  const LatestProductsState();

  @override
  List<Object> get props => [];
}

class LatestProductsInitial extends LatestProductsState {}

class LatestProductsLoading extends LatestProductsState {}

class LatestProductsLoaded extends LatestProductsState {
  final List<HomeProduct> products;

  const LatestProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class LatestProductsError extends LatestProductsState {
  final String message;

  const LatestProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

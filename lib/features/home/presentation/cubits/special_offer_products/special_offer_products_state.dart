import 'package:equatable/equatable.dart';
import '../../../domain/entities/home_product.dart';

abstract class SpecialOfferProductsState extends Equatable {
  const SpecialOfferProductsState();

  @override
  List<Object> get props => [];
}

class SpecialOfferProductsInitial extends SpecialOfferProductsState {}

class SpecialOfferProductsLoading extends SpecialOfferProductsState {}

class SpecialOfferProductsLoadingMore extends SpecialOfferProductsState {
  final List<HomeProduct> products;

  const SpecialOfferProductsLoadingMore({required this.products});

  @override
  List<Object> get props => [products];
}

class SpecialOfferProductsLoaded extends SpecialOfferProductsState {
  final List<HomeProduct> products;
  final bool hasMore;

  const SpecialOfferProductsLoaded({required this.products, required this.hasMore});

  @override
  List<Object> get props => [products, hasMore];
}

class SpecialOfferProductsError extends SpecialOfferProductsState {
  final String message;

  const SpecialOfferProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

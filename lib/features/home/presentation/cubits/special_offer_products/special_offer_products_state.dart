import 'package:equatable/equatable.dart';
import '../../../domain/entities/home_product.dart';

abstract class SpecialOfferProductsState extends Equatable {
  const SpecialOfferProductsState();

  @override
  List<Object> get props => [];
}

class SpecialOfferProductsInitial extends SpecialOfferProductsState {}

class SpecialOfferProductsLoading extends SpecialOfferProductsState {}

class SpecialOfferProductsLoaded extends SpecialOfferProductsState {
  final List<HomeProduct> products;

  const SpecialOfferProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class SpecialOfferProductsError extends SpecialOfferProductsState {
  final String message;

  const SpecialOfferProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

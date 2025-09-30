import 'package:equatable/equatable.dart';
import 'package:test/features/categories/domain/entities/sub_category.dart';

abstract class SubCategoryState extends Equatable {
  const SubCategoryState();

  @override
  List<Object> get props => [];
}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategory> subCategories;

  const SubCategoryLoaded({required this.subCategories});

  @override
  List<Object> get props => [subCategories];
}

class SubCategoryError extends SubCategoryState {
  final String message;

  const SubCategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

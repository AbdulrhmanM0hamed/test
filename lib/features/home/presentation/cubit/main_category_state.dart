import 'package:test/features/home/domain/entities/main_category.dart';

abstract class MainCategoryState {}

class MainCategoryInitial extends MainCategoryState {}

class MainCategoryLoading extends MainCategoryState {}

class MainCategoryLoaded extends MainCategoryState {
  final List<MainCategory> categories;

  MainCategoryLoaded({required this.categories});
}

class MainCategoryError extends MainCategoryState {
  final String message;

  MainCategoryError({required this.message});
}

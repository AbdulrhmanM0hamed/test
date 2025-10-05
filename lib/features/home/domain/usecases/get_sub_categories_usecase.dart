import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/features/home/domain/entities/sub_category.dart';
import 'package:test/features/home/domain/repositories/sub_categories_repository.dart';

class GetSubCategoriesUsecase {
  final SubCategoriesRepository repository;

  GetSubCategoriesUsecase({required this.repository});

  Future<Either<Failure, List<SubCategory>>> call() async {
    return await repository.getSubCategories();
  }
}

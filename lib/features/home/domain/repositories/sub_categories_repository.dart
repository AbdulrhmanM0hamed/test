import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/features/home/domain/entities/sub_category.dart';

abstract class SubCategoriesRepository {
  Future<Either<Failure, List<SubCategory>>> getSubCategories();
}

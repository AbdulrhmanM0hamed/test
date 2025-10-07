import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/about_us.dart';
import '../repositories/about_us_repository.dart';

class GetAboutUsUseCase {
  final AboutUsRepository repository;

  GetAboutUsUseCase({required this.repository});

  Future<Either<Failure, AboutUs>> call() async {
    return await repository.getAboutUs();
  }
}

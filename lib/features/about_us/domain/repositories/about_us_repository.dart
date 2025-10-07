import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/about_us.dart';

abstract class AboutUsRepository {
  Future<Either<Failure, AboutUs>> getAboutUs();
}

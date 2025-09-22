import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/address.dart';
import '../repositories/addresses_repository.dart';

class GetAddressesUseCase {
  final AddressesRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await repository.getAddresses();
  }
}

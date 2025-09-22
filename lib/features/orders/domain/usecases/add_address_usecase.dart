import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/address.dart';
import '../repositories/addresses_repository.dart';

class AddAddressUseCase {
  final AddressesRepository repository;

  AddAddressUseCase(this.repository);

  @override
  Future<Either<Failure, Address>> call(Address address) async {
    return await repository.addAddress(address);
  }
}

class AddAddressParams extends Equatable {
  final Address address;

  const AddAddressParams({required this.address});

  @override
  List<Object> get props => [address];
}

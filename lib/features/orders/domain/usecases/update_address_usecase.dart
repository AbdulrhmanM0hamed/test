import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/address.dart';
import '../repositories/addresses_repository.dart';

class UpdateAddressUseCase {
  final AddressesRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, Address>> call(UpdateAddressParams params) async {
    return await repository.updateAddress(params.addressId, params.address);
  }
}

class UpdateAddressParams extends Equatable {
  final int addressId;
  final Address address;

  const UpdateAddressParams({
    required this.addressId,
    required this.address,
  });

  @override
  List<Object> get props => [addressId, address];
}

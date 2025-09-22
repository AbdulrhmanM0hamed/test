import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/addresses_repository.dart';

class DeleteAddressUseCase {
  final AddressesRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteAddressParams params) async {
    return await repository.deleteAddress(params.addressId);
  }
}

class DeleteAddressParams extends Equatable {
  final int addressId;

  const DeleteAddressParams({required this.addressId});

  @override
  List<Object> get props => [addressId];
}

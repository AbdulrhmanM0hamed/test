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
    //print('🎯 AddAddressUseCase called');
    //print('   - Address: ${address.address}');
    //print('   - City ID: ${address.city.id}');
    //print('   - Region ID: ${address.region.id}');

    final result = await repository.addAddress(address);

    result.fold(
      (failure) => print('❌ UseCase failed: ${failure.message}'),
      (newAddress) => print('✅ UseCase success: Address ID ${newAddress.id}'),
    );

    return result;
  }
}

class AddAddressParams extends Equatable {
  final Address address;

  const AddAddressParams({required this.address});

  @override
  List<Object> get props => [address];
}

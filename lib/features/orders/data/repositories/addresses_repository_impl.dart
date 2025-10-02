import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../datasources/addresses_remote_data_source.dart';
import '../models/address_model.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AddressesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.getAddresses();
      if (response.success) {
        return Right(response.data ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    //print('🏪 AddressesRepository.addAddress called');
    //print('   - Network connected: ${await networkInfo.isConnected}');

    if (await networkInfo.isConnected) {
      final addressModel = AddressModel(
        id: address.id,
        address: address.address,
        addressType: address.addressType,
        country: CountryModel(
          id: address.country.id,
          name: address.country.name,
        ),
        city: CityModel(id: address.city.id, name: address.city.name),
        region: RegionModel(id: address.region.id, name: address.region.name),
        shippingCost: address.shippingCost,
      );

      //print('📡 Calling remote data source...');
      final response = await remoteDataSource.addAddress(addressModel);
      //print('📡 Remote data source response:');
      //print('   - Success: ${response.success}');
      //print('   - Message: ${response.message}');
      //print('   - Data: ${response.data != null ? 'Address ID ${response.data!.id}' : 'null'}');

      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      //print('❌ No internet connection');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(
    int addressId,
    Address address,
  ) async {
    if (await networkInfo.isConnected) {
      final addressModel = AddressModel(
        id: addressId,
        address: address.address,
        addressType: address.addressType,
        country: CountryModel(
          id: address.country.id,
          name: address.country.name,
        ),
        city: CityModel(id: address.city.id, name: address.city.name),
        region: RegionModel(id: address.region.id, name: address.region.name),
        shippingCost: address.shippingCost,
      );

      final response = await remoteDataSource.updateAddress(
        addressId,
        addressModel,
      );
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(int addressId) async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.deleteAddress(addressId);
      if (response.success) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

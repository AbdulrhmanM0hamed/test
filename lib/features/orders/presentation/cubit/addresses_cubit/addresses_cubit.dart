import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/usecases/get_addresses_usecase.dart';
import '../../../domain/usecases/add_address_usecase.dart';
import '../../../domain/usecases/update_address_usecase.dart';
import '../../../domain/usecases/delete_address_usecase.dart';

part 'addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  AddressesCubit({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
  }) : super(AddressesInitial());

  Future<void> getAddresses() async {
    if (isClosed) return;
    emit(AddressesLoading());

    final result = await getAddressesUseCase();

    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(AddressesError(failure.message));
      },
      (addresses) {
        if (!isClosed) emit(AddressesLoaded(addresses));
      },
    );
  }

  Future<void> addAddress(Address address) async {
    //print('🏗️ AddressesCubit.addAddress called');
    //print('   - Address: ${address.address}');
    //print('   - Type: ${address.addressType}');
    //print('   - City: ${address.city.name}');
    //print('   - Region: ${address.region.name}');

    if (isClosed) return;
    emit(AddressesLoading());
    //print('⏳ Emitted AddressesLoading');

    final result = await addAddressUseCase(address);
    //print('📡 UseCase result received');

    if (isClosed) return;
    result.fold(
      (failure) {
        //print('❌ AddAddress failed: ${failure.message}');
        if (!isClosed) emit(AddressesError(failure.message));
      },
      (newAddress) {
        //print('✅ AddAddress success');
        //print('   - New address ID: ${newAddress.id}');
        if (!isClosed) {
          //print('🎯 About to emit AddressAdded');
          //print('🔍 Cubit state before emit: ${state.runtimeType}');
          emit(AddressAdded(newAddress));
          //print('🎯 Emitted AddressAdded');
          //print('🔍 Cubit state after emit: ${state.runtimeType}');
          // Don't call getAddresses here - let the UI handle the refresh
          // getAddresses();
        }
      },
    );
  }

  Future<void> updateAddress(int addressId, Address address) async {
    if (isClosed) return;
    emit(AddressesLoading());

    final result = await updateAddressUseCase(
      UpdateAddressParams(addressId: addressId, address: address),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(AddressesError(failure.message));
      },
      (updatedAddress) {
        if (!isClosed) {
          emit(AddressUpdated(updatedAddress));
          // Don't call getAddresses here - let the UI handle the refresh
        }
      },
    );
  }

  Future<void> deleteAddress(int addressId) async {
    if (isClosed) return;
    emit(AddressesLoading());

    final result = await deleteAddressUseCase(
      DeleteAddressParams(addressId: addressId),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(AddressesError(failure.message));
      },
      (_) {
        if (!isClosed) {
          emit(AddressDeleted(addressId));
          // Refresh the addresses list immediately for delete
          getAddresses();
        }
      },
    );
  }
}

// NoParams class for get addresses use case
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}

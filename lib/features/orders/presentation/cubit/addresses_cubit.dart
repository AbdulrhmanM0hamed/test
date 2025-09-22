import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';

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
    if (isClosed) return;
    emit(AddressesLoading());
    
    final result = await addAddressUseCase(address);
    
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(AddressesError(failure.message));
      },
      (newAddress) {
        if (!isClosed) {
          // Refresh the addresses list
          getAddresses();
          emit(AddressAdded(newAddress));
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
    result.fold((failure) {
      if (!isClosed) emit(AddressesError(failure.message));
    }, (updatedAddress) {
      if (!isClosed) {
        // Refresh the addresses list
        getAddresses();
        emit(AddressUpdated(updatedAddress));
      }
    });
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
          // Refresh the addresses list
          getAddresses();
          emit(AddressDeleted(addressId));
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

part of 'addresses_cubit.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object> get props => [];
}

class AddressesInitial extends AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<Address> addresses;

  const AddressesLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class AddressesError extends AddressesState {
  final String message;

  const AddressesError(this.message);

  @override
  List<Object> get props => [message];
}

class AddressAdded extends AddressesState {
  final Address address;
  final String? message;

  const AddressAdded(this.address, {this.message});

  @override
  List<Object> get props => [address, message ?? ''];
}

class AddressUpdated extends AddressesState {
  final Address address;
  final String? message;

  const AddressUpdated(this.address, {this.message});

  @override
  List<Object> get props => [address, message ?? ''];
}

class AddressDeleted extends AddressesState {
  final int addressId;

  const AddressDeleted(this.addressId);

  @override
  List<Object> get props => [addressId];
}

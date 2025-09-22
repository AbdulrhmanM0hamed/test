import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final String addressType;
  final String address;
  final Country country;
  final City city;
  final Region region;
  final double shippingCost;

  const Address({
    required this.id,
    required this.addressType,
    required this.address,
    required this.country,
    required this.city,
    required this.region,
    required this.shippingCost,
  });

  @override
  List<Object> get props => [
        id,
        addressType,
        address,
        country,
        city,
        region,
        shippingCost,
      ];
}

class Country extends Equatable {
  final int id;
  final String name;

  const Country({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

class City extends Equatable {
  final int id;
  final String name;

  const City({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

class Region extends Equatable {
  final int id;
  final String name;

  const Region({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

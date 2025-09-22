import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.addressType,
    required super.address,
    required super.country,
    required super.city,
    required super.region,
    required super.shippingCost,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      addressType: json['address_type'] as String,
      address: json['address'] as String,
      country: CountryModel.fromJson(json['country'] as Map<String, dynamic>),
      city: CityModel.fromJson(json['city'] as Map<String, dynamic>),
      region: RegionModel.fromJson(json['region'] as Map<String, dynamic>),
      shippingCost: (json['shipping_cost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_type': addressType,
      'address': address,
      'country': (country as CountryModel).toJson(),
      'city': (city as CityModel).toJson(),
      'region': (region as RegionModel).toJson(),
      'shipping_cost': shippingCost,
    };
  }

  /// For creating new address
  Map<String, dynamic> toCreateJson() {
    return {
      'address': address,
      'address_type': addressType,
      'country_id': country.id,
      'city_id': city.id,
      'region_id': region.id,
    };
  }

  /// For updating existing address
  Map<String, dynamic> toUpdateJson() {
    return {
      'address': address,
      'address_type': addressType,
      'country_id': country.id,
      'city_id': city.id,
      'region_id': region.id,
    };
  }
}

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    required super.name,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CityModel extends City {
  const CityModel({
    required super.id,
    required super.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RegionModel extends Region {
  const RegionModel({
    required super.id,
    required super.name,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

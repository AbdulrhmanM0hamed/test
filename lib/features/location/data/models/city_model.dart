import 'package:test/features/location/domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.countryId,
    super.image,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      countryId: json['country_id'] as int,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_ar': titleAr,
      'country_id': countryId,
      'image': image,
    };
  }
}

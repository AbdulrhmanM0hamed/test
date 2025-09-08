import 'package:test/features/profile/domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.id,
    super.image,
    required super.titleEn,
    required super.titleAr,
    required super.code,
    required super.status,
    required super.countryId,
    super.createdAt,
    super.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      image: json['image'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      code: json['code'],
      status: json['status'],
      countryId: json['country_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title_en': titleEn,
      'title_ar': titleAr,
      'code': code,
      'status': status,
      'country_id': countryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

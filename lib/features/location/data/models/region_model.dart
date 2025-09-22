import 'package:test/features/location/domain/entities/region.dart';

class RegionModel extends Region {
  const RegionModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.cityId,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      cityId: json['city_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_ar': titleAr,
      'city_id': cityId,
    };
  }
}

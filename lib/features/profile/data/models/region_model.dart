import 'package:test/features/profile/domain/entities/region.dart';

class RegionModel extends Region {
  const RegionModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    super.code,
    super.status,
    required super.cityId,
    super.createdAt,
    super.updatedAt,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      code: json['code'],
      status: json['status'],
      cityId: json['city_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_ar': titleAr,
      'code': code,
      'status': status,
      'city_id': cityId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

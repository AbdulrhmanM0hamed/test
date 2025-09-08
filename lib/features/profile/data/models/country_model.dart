import 'package:test/features/profile/domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    super.image,
    required super.titleEn,
    required super.titleAr,
    required super.shortcut,
    required super.code,
    required super.status,
    super.createdAt,
    super.updatedAt,
    required super.currency,
    required super.currencyAr,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      image: json['image'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      shortcut: json['shortcut'],
      code: json['code'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      currency: json['currency'],
      currencyAr: json['currency_ar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title_en': titleEn,
      'title_ar': titleAr,
      'shortcut': shortcut,
      'code': code,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'currency': currency,
      'currency_ar': currencyAr,
    };
  }
}

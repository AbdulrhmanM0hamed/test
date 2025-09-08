import 'package:test/features/auth/domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.currencyEn,
    required super.currencyAr,
    required super.shortcut,
    required super.code,
    required super.image,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      currencyEn: json['currency_en'] as String,
      currencyAr: json['currency_ar'] as String,
      shortcut: json['shortcut'] as String,
      code: json['code'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_ar': titleAr,
      'currency_en': currencyEn,
      'currency_ar': currencyAr,
      'shortcut': shortcut,
      'code': code,
      'image': image,
    };
  }
}

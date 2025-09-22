import 'package:equatable/equatable.dart';

class City extends Equatable {
  final int id;
  final String titleEn;
  final String titleAr;
  final int countryId;
  final String? image;

  const City({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.countryId,
    this.image,
  });

  /// Get localized title based on language
  String getLocalizedTitle(bool isArabic) {
    return isArabic ? titleAr : titleEn;
  }

  @override
  List<Object?> get props => [id, titleEn, titleAr, countryId, image];

  @override
  String toString() => 'City(id: $id, titleAr: $titleAr, titleEn: $titleEn)';
}

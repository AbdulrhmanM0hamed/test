import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final int id;
  final String titleEn;
  final String titleAr;
  final int cityId;
  final String? image;

  const Region({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.cityId,
    this.image,
  });

  /// Get localized title based on language
  String getLocalizedTitle(bool isArabic) {
    return isArabic ? titleAr : titleEn;
  }

  @override
  List<Object?> get props => [id, titleEn, titleAr, cityId, image];

  @override
  String toString() => 'Region(id: $id, titleAr: $titleAr, titleEn: $titleEn)';
}

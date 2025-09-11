class Country {
  final int id;
  final String titleEn;
  final String titleAr;
  final String currencyEn;
  final String currencyAr;
  final String shortcut;
  final String code;
  final String image;

  const Country({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.currencyEn,
    required this.currencyAr,
    required this.shortcut,
    required this.code,
    required this.image,
  });

  /// Get localized title based on language
  String getLocalizedTitle(bool isArabic) {
    return isArabic ? titleAr : titleEn;
  }

  /// Get localized currency based on language
  String getLocalizedCurrency(bool isArabic) {
    return isArabic ? currencyAr : currencyEn;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

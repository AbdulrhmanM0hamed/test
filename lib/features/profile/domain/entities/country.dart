class Country {
  final int id;
  final String? image;
  final String titleEn;
  final String titleAr;
  final String shortcut;
  final String code;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String currency;
  final String currencyAr;

  const Country({
    required this.id,
    this.image,
    required this.titleEn,
    required this.titleAr,
    required this.shortcut,
    required this.code,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.currency,
    required this.currencyAr,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Country(id: $id, titleAr: $titleAr, titleEn: $titleEn)';
}

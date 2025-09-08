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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

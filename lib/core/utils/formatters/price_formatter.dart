import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');
  
  /// Format price with thousands separators and 2 decimal places
  /// Example: 1500.6 -> "1,500.60"
  /// Example: 5600.29 -> "5,600.29"
  static String formatPrice(dynamic price) {
    if (price == null) return '0.00';
    
    double priceValue;
    if (price is String) {
      // Remove existing commas and parse
      priceValue = double.tryParse(price.replaceAll(',', '')) ?? 0.0;
    } else if (price is num) {
      priceValue = price.toDouble();
    } else {
      return '0.00';
    }
    
    return _formatter.format(priceValue);
  }
  
  /// Format price with currency symbol
  /// Example: formatPriceWithCurrency(1500.6, "EGP") -> "1,500.60 EGP"
  static String formatPriceWithCurrency(dynamic price, String currency) {
    return '${formatPrice(price)} $currency';
  }
  
  /// Format price for Arabic display with currency
  /// Example: formatPriceArabic(1500.6, "جنيه") -> "1,500.60 جنيه"
  static String formatPriceArabic(dynamic price, String currency) {
    return '${formatPrice(price)} $currency';
  }
  
  /// Parse formatted price back to double
  /// Example: "1,500.60" -> 1500.6
  static double parseFormattedPrice(String formattedPrice) {
    return double.tryParse(formattedPrice.replaceAll(',', '')) ?? 0.0;
  }
}

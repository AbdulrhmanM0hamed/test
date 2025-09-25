import 'package:flutter/material.dart';

/// Order status enumeration with colors and localized names
enum OrderStatus {
  newOrder('New', 'جديد', Color(0xFF3498db)),
  inProgress('Inprogress', 'جاري العمل عليها', Color(0xFFf1c40f)),
  delivered('Deliverd', 'تم التوصيل', Color(0xFF2ecc71)),
  cancelled('Cancelled', 'تم الالغاء', Color(0xFFe74c3c)),
  wantToReturn('WantTOReturn', 'طلب ارجاع', Color(0xFFe67e22)),
  inProgressReturn('InprogressReturn', 'جاري الارجاع', Color(0xFF9b59b6)),
  returned('Returned', 'تم الارجاع', Color(0xFF1abc9c));

  const OrderStatus(this.englishName, this.arabicName, this.color);

  final String englishName;
  final String arabicName;
  final Color color;

  /// Get order status from string value
  static OrderStatus? fromString(String status) {
    for (OrderStatus orderStatus in OrderStatus.values) {
      if (orderStatus.englishName.toLowerCase() == status.toLowerCase() ||
          orderStatus.arabicName == status) {
        return orderStatus;
      }
    }
    return null;
  }

  /// Get localized name based on language
  String getLocalizedName(bool isArabic) {
    return isArabic ? arabicName : englishName;
  }

  /// Get color from hex string or return default color
  static Color getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return const Color(0xFF3498db); // Default blue color
    }
    
    try {
      String colorString = hexColor.replaceAll('#', '');
      if (colorString.length == 6) {
        colorString = 'FF$colorString'; // Add alpha channel
      }
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return const Color(0xFF3498db); // Default blue color
    }
  }
}

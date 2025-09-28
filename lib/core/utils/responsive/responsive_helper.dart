import 'package:flutter/material.dart';

/// Responsive helper class for handling different screen sizes
class ResponsiveHelper {
  static const double _smallMobileBreakpoint = 400;

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < _mobileBreakpoint;
  }

  static bool isSmallMobile(BuildContext context) {
    return getScreenWidth(context) < _smallMobileBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= _desktopBreakpoint;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? smallMobile,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isSmallMobile(context) && smallMobile != null) {
      return smallMobile;
    } else {
      return mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveValue(
        context,
        smallMobile: 12.0,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: getResponsiveValue(
        context,
        smallMobile: 8.0,
        mobile: 0,
        tablet: 24.0,
        desktop: 32.0,
      ),
    );
  }

  /// Get responsive card width for product cards
  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isSmallMobile(context)) {
      return (screenWidth - 24) / 2; // 12*2 padding + 12 gap
    }
    if (isMobile(context)) {
      // Mobile: 2 cards per row with padding
      return (screenWidth - 48) / 2; // 16*2 padding + 16 gap
    } else if (isTablet(context)) {
      // Tablet: 3 cards per row
      return (screenWidth - 80) / 3;
      // 24*2 padding + 16*2 gaps
    } else {
      // Desktop: 4 cards per row
      return (screenWidth - 128) / 4; // 32*2 padding + 16*3 gaps
    }
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    return getResponsiveValue(context, mobile: 2, tablet: 3, desktop: 4);
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final scaleFactor = getResponsiveValue(
      context,
      smallMobile: 0.9,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseFontSize * scaleFactor;
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return getResponsiveValue(
      context,
      smallMobile: baseSpacing * 0.8,
      mobile: baseSpacing,
      tablet: baseSpacing * 1.2,
      desktop: baseSpacing * 1.4,
    );
  }

  /// Get responsive card height for product cards
  static double getCardHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 250.0,
      mobile: 270.0,
      tablet: 290.0,
      desktop: 320.0,
    );
  }

  /// Get responsive image height for product cards
  static double getImageHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 110.0,
      mobile: 130.0,
      tablet: 140.0,
      desktop: 160.0,
    );
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 14.0,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    return getResponsiveValue(
      context,
      smallMobile: baseSize * 0.9,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.2,
    );
  }

  /// Get responsive section height for horizontal lists
  static double getSectionHeight(
    BuildContext context, {
    bool hasSpecialOffer = false,
  }) {
    final baseHeight = hasSpecialOffer ? 290.0 : 280.0;
    return getResponsiveValue(
      context,
      smallMobile: baseHeight,
      mobile: baseHeight,
      tablet: baseHeight + 20,
      desktop: baseHeight + 40,
    );
  }

  /// Get responsive horizontal list item width
  static double getHorizontalItemWidth(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 150.0,
      mobile: 170.0,
      tablet: 200.0,
      desktop: 220.0,
    );
  }

  /// Get responsive margin between horizontal items
  static double getHorizontalItemMargin(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 10.0,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  /// Get responsive compact card height for featured products
  static double getCompactCardHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 80.0,
      mobile: 100.0,
      tablet: 110.0,
      desktop: 120.0,
    );
  }

  /// Get responsive compact card image width
  static double getCompactCardImageWidth(BuildContext context) {
    return getResponsiveValue(
      context,
      smallMobile: 75.0,
      mobile: 85.0,
      tablet: 95.0,
      desktop: 105.0,
    );
  }
}

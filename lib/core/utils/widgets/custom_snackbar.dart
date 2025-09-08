import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constant/font_manger.dart';
import '../constant/styles_manger.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    // Remove any existing snackbar
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: FontConstant.cairo,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ).animate().slideY(begin: 1.0, end: 0.0).fadeIn(),
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  // Helper method to get appropriate message based on locale
  static String getLocalizedMessage({
    required BuildContext context,
    required String messageAr,
    required String messageEn,
  }) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? messageAr : messageEn;
  }
}

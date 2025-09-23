import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';

/// Enhanced error dialog with better UX and localized messages
class EnhancedErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final int? statusCode;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final bool showRetry;
  final bool showGoBack;
  final IconData? icon;

  const EnhancedErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.statusCode,
    this.onRetry,
    this.onGoBack,
    this.showRetry = true,
    this.showGoBack = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _getErrorColor(statusCode).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? _getErrorIcon(statusCode),
                size: 32,
                color: _getErrorColor(statusCode),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: getBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            // Status Code (if available)
            if (statusCode != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Error Code: $statusCode',
                  style: getRegularStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                if (showGoBack) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onGoBack ?? () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        localizations.goBack,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  if (showRetry) const SizedBox(width: 12),
                ],

                if (showRetry)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        localizations.retryRequest,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (!showRetry && !showGoBack)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        localizations.cancel,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get appropriate color based on status code
  Color _getErrorColor(int? statusCode) {
    if (statusCode == null) return Colors.red;

    if (statusCode >= 400 && statusCode < 500) {
      // Client errors - orange/amber
      return Colors.orange;
    } else if (statusCode >= 500) {
      // Server errors - red
      return Colors.red;
    } else {
      // Other errors - grey
      return Colors.grey;
    }
  }

  /// Get appropriate icon based on status code
  IconData _getErrorIcon(int? statusCode) {
    if (statusCode == null) return Icons.error_outline;

    switch (statusCode) {
      case 401:
      case 403:
        return Icons.lock_outline;
      case 404:
        return Icons.search_off;
      case 408:
      case 504:
        return Icons.access_time;
      case 429:
        return Icons.speed;
      case 500:
      case 502:
      case 503:
        return Icons.dns_outlined;
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return Icons.warning_amber_outlined;
        } else if (statusCode >= 500) {
          return Icons.error_outline;
        } else {
          return Icons.info_outline;
        }
    }
  }

  /// Show enhanced error dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    int? statusCode,
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    bool showRetry = true,
    bool showGoBack = false,
    IconData? icon,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnhancedErrorDialog(
        title: title,
        message: message,
        statusCode: statusCode,
        onRetry: onRetry,
        onGoBack: onGoBack,
        showRetry: showRetry,
        showGoBack: showGoBack,
        icon: icon,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/utils/common/custom_button.dart';

class OrderSuccessDialog extends StatelessWidget {
  final String orderId;
  final VoidCallback onContinueShopping;

  const OrderSuccessDialog({
    super.key,
    required this.orderId,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),

            const SizedBox(height: 24),

            // Success Title
            Text(
              AppLocalizations.of(context)!.orderPlacedSuccessfully,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Order ID
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'رقم الطلب: #$orderId',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Success Message
            Text(
              'سيتم التواصل معك قريباً لتأكيد الطلب وتحديد موعد التوصيل',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Continue Shopping Button
            CustomButton(
              text: 'متابعة التسوق',
              onPressed: onContinueShopping,
              width: double.infinity,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),

            const SizedBox(height: 12),

            // Track Order Button (Optional)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Navigate to orders page
              },
              child: Text(
                'تتبع الطلب',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String orderId,
    required VoidCallback onContinueShopping,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrderSuccessDialog(
        orderId: orderId,
        onContinueShopping: onContinueShopping,
      ),
    );
  }
}

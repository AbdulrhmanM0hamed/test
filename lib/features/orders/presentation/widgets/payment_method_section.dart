import 'package:flutter/material.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.paymentMethod,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          
          // Cash on Delivery Option
          _buildPaymentOption(
            context: context,
            value: 'cash_on_delivery',
            title: AppLocalizations.of(context)!.cashOnDelivery,
            subtitle: AppLocalizations.of(context)!.payWhenYouReceive,
            icon: Icons.money,
            isEnabled: true,
          ),
          
          const SizedBox(height: 12),
          
          // Online Payment Option (Disabled)
          _buildPaymentOption(
            context: context,
            value: 'online',
            title: AppLocalizations.of(context)!.onlinePayment,
            subtitle: AppLocalizations.of(context)!.comingSoon,
            icon: Icons.credit_card,
            isEnabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
  }) {
    final isSelected = selectedPaymentMethod == value;
    
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => onPaymentMethodChanged(value) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected && isEnabled
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.3),
                width: isSelected && isEnabled ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected && isEnabled
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected && isEnabled
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected && isEnabled
                        ? AppColors.primary
                        : Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: isEnabled
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected && isEnabled)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  )
                else if (!isEnabled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.comingSoon,
                      style: getRegularStyle(
                        fontSize: FontSize.size10,
                        fontFamily: FontConstant.cairo,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

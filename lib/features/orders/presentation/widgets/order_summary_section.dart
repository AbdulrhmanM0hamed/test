import 'package:flutter/material.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class OrderSummarySection extends StatelessWidget {
  final double cartTotal;
  final double shippingCost;
  final double discountAmount;
  final double finalTotal;

  const OrderSummarySection({
    super.key,
    required this.cartTotal,
    required this.shippingCost,
    required this.discountAmount,
    required this.finalTotal,
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
            AppLocalizations.of(context)!.orderSummary,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          
          // Cart Subtotal
          _buildSummaryRow(
            context: context,
            label: AppLocalizations.of(context)!.subtotal,
            value: '${cartTotal.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
            isRegular: true,
          ),
          
          const SizedBox(height: 12),
          
          // Shipping Cost
          _buildSummaryRow(
            context: context,
            label: AppLocalizations.of(context)!.shipping,
            value: shippingCost > 0 
                ? '${shippingCost.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}'
                : AppLocalizations.of(context)!.free,
            isRegular: true,
          ),
          
          // Discount (if applied)
          if (discountAmount > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              context: context,
              label: AppLocalizations.of(context)!.discount,
              value: '-${discountAmount.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
              isRegular: true,
              valueColor: Colors.green,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          
          const SizedBox(height: 16),
          
          // Total
          _buildSummaryRow(
            context: context,
            label: AppLocalizations.of(context)!.total,
            value: '${finalTotal.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
            isRegular: false,
          ),
          
          const SizedBox(height: 16),
          
          // Savings indicator (if discount applied)
          if (discountAmount > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.savings_outlined,
                    color: Colors.green[700],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.youSave} ${discountAmount.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                    style: getMediumStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool isRegular,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isRegular
              ? getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )
              : getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
        ),
        Text(
          value,
          style: isRegular
              ? getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                )
              : getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.primary,
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../orders/domain/entities/order_item.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/domain/entities/order_actions_helper.dart';
import '../../../orders/presentation/cubit/orders_cubit/orders_cubit.dart';
import '../../../orders/presentation/widgets/order_action_dialog.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;
  final VoidCallback onTap;
  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)?.localeName == 'ar';
    final orderStatus = OrderStatus.fromString(order.status);
    final statusColor =
        orderStatus?.color ?? OrderStatus.getColorFromHex(order.statusColor);
    final statusText =
        orderStatus?.getLocalizedName(isArabic == true) ?? order.status;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with order number and status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.orderNumber,
                            style: getRegularStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${order.orderNumber}',
                            style: getBoldStyle(
                              fontSize: FontSize.size16,
                              fontFamily: FontConstant.cairo,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider
                Container(height: 1, color: Colors.grey.withValues(alpha: 0.1)),

                const SizedBox(height: 16),

                // Price and currency
                Row(
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.totalAmount,
                      style: getRegularStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${order.totalPrice.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Refund status if applicable
                if (order.refunded == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.refunded,
                          style: getSemiBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Action buttons and view details
                _buildActionButtons(context, isArabic == true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isArabic) {
    final canCancel = OrderActionsHelper.canCancelOrder(order.status);
    final canReturn = OrderActionsHelper.canReturnOrder(order.status);

    return Column(
        children: [
          // Action buttons row
          if (canCancel || canReturn) ...[
            Row(
              children: [
                // Cancel button
                if (canCancel) ...[
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      text: OrderActionsHelper.getCancelButtonText(isArabic),
                      icon: Icons.cancel_outlined,
                      color: Colors.red[600]!,
                      onPressed: () => _showCancelDialog(context, isArabic),
                    ),
                  ),
                  if (canReturn) const SizedBox(width: 12),
                ],

                // Return button
                if (canReturn)
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      text: OrderActionsHelper.getReturnButtonText(isArabic),
                      icon: Icons.assignment_return_outlined,
                      color: Colors.orange[600]!,
                      onPressed: () => _showReturnDialog(context, isArabic),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // View details button
          Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: onTap,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  AppLocalizations.of(context)!.viewDetails,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    text,
                    style: getMediumStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, bool isArabic) {
    OrderActionDialog.showCancelDialog(
      context: context,
      title: OrderActionsHelper.getCancelDialogTitle(isArabic),
      message: OrderActionsHelper.getCancelDialogMessage(isArabic),
      confirmText: isArabic ? 'نعم، إلغاء' : 'Yes, Cancel',
      cancelText: isArabic ? 'تراجع' : 'Go Back',
      onConfirm: () => context.read<OrdersCubit>().cancelOrder(order.id),
    );
  }

  void _showReturnDialog(BuildContext context, bool isArabic) {
    OrderActionDialog.showReturnDialog(
      context: context,
      title: OrderActionsHelper.getReturnDialogTitle(isArabic),
      message: OrderActionsHelper.getReturnDialogMessage(isArabic),
      confirmText: isArabic ? 'نعم، طلب الإرجاع' : 'Yes, Request Return',
      cancelText: isArabic ? 'تراجع' : 'Go Back',
      onConfirm: () => context.read<OrdersCubit>().returnOrder(order.id),
    );
  }
}

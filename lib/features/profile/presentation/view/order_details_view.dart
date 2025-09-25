import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_cubit.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_state.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../orders/domain/entities/order_details.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/domain/entities/order_actions_helper.dart';
import '../../../orders/presentation/widgets/order_action_dialog.dart';
import '../widgets/order_product_item_card.dart';

class OrderDetailsView extends StatefulWidget {
  static const String routeName = '/order-details';
  final int orderId;

  const OrderDetailsView({super.key, required this.orderId});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.orderDetails),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrderDetailsError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            } else if (state is OrderActionSuccess) {
              final isArabic = AppLocalizations.of(context)?.localeName == 'ar';

              // Determine the appropriate success message based on the action type
              String successMessage;
              if (state.message.toLowerCase().contains('cancel') ||
                  state.message.contains('إلغاء') ||
                  state.message.contains('ألغي')) {
                successMessage = OrderActionsHelper.getCancelSuccessMessage(
                  isArabic == true,
                );
              } else if (state.message.toLowerCase().contains('return') ||
                  state.message.contains('إرجاع') ||
                  state.message.contains('ارجاع')) {
                successMessage = OrderActionsHelper.getReturnSuccessMessage(
                  isArabic == true,
                );
              } else {
                // Fallback to server message
                successMessage = state.message;
              }

              CustomSnackbar.showSuccess(
                context: context,
                message: successMessage,
              );
              // Refresh order details
              context.read<OrdersCubit>().getOrderDetails(widget.orderId);
            } else if (state is OrderActionError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return _buildLoadingState();
            } else if (state is OrderDetailsLoaded) {
              return _buildLoadedState(context, state.orderDetails);
            } else if (state is OrderDetailsError) {
              return _buildErrorState(context, state);
            }
            return _buildInitialState(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CustomProgressIndicator());
  }

  Widget _buildLoadedState(BuildContext context, OrderDetails orderDetails) {
    final isArabic = AppLocalizations.of(context)?.localeName == 'ar';
    final orderStatus = OrderStatus.fromString(orderDetails.status);
    final statusColor =
        orderStatus?.color ??
        OrderStatus.getColorFromHex(orderDetails.statusColor);
    final statusText =
        orderStatus?.getLocalizedName(isArabic == true) ?? orderDetails.status;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header Card
          _buildOrderHeaderCard(context, orderDetails, statusColor, statusText),

          const SizedBox(height: 16),

          // Customer Information Card
          _buildCustomerInfoCard(context, orderDetails),

          const SizedBox(height: 16),

          // Order Products Card
          _buildOrderProductsCard(context, orderDetails),

          const SizedBox(height: 16),

          // Order Summary Card
          _buildOrderSummaryCard(context, orderDetails),

          const SizedBox(height: 16),

          // Action buttons
          _buildActionButtons(context, orderDetails),
        ],
      ),
    );
  }

  Widget _buildOrderHeaderCard(
    BuildContext context,
    OrderDetails orderDetails,
    Color statusColor,
    String statusText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.orderNumber,
                      style: getRegularStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${orderDetails.orderNumber}',
                      style: getBoldStyle(
                        fontSize: FontSize.size18,
                        fontFamily: FontConstant.cairo,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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
                  style: getBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${AppLocalizations.of(context)!.orderDate}: ${orderDetails.issueDate}',
                style: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard(
    BuildContext context,
    OrderDetails orderDetails,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.customerInformation,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            context,
            Icons.email_outlined,
            AppLocalizations.of(context)!.email,
            orderDetails.customerEmail,
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            context,
            Icons.phone_outlined,
            AppLocalizations.of(context)!.phoneNumber,
            orderDetails.customerPhone,
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            context,
            Icons.location_on_outlined,
            AppLocalizations.of(context)!.address,
            orderDetails.customerAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderProductsCard(
    BuildContext context,
    OrderDetails orderDetails,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.orderItems,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),

          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderDetails.orderProducts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = orderDetails.orderProducts[index];
              return OrderProductItemCard(product: product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    BuildContext context,
    OrderDetails orderDetails,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.orderSummary,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),

          const SizedBox(height: 16),

          _buildSummaryRow(
            context,
            AppLocalizations.of(context)!.subtotal,
            '${orderDetails.totalProductPrice.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
          ),

          const SizedBox(height: 8),

          _buildSummaryRow(
            context,
            AppLocalizations.of(context)!.shipping,
            '${orderDetails.shipping.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
          ),

          const SizedBox(height: 8),

          _buildSummaryRow(
            context,
            AppLocalizations.of(context)!.taxes,
            '${orderDetails.totalTax.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
          ),

          if (orderDetails.promoCodeDiscountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              context,
              AppLocalizations.of(context)!.discount,
              '-${orderDetails.promoCodeDiscountAmount.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
              isDiscount: true,
            ),
          ],

          const SizedBox(height: 12),

          Container(height: 1, color: Colors.grey.withValues(alpha: 0.2)),

          const SizedBox(height: 12),

          _buildSummaryRow(
            context,
            AppLocalizations.of(context)!.total,
            '${orderDetails.totalOrderPrice.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currency}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                )
              : getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
        ),
        Text(
          value,
          style: isTotal
              ? getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.primary,
                )
              : getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: isDiscount
                      ? Colors.green
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, OrderDetailsError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.error,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<OrdersCubit>().getOrderDetails(widget.orderId);
            },
            icon: const Icon(Icons.refresh),
            label: Text(
              AppLocalizations.of(context)!.retry,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    // Trigger the API call when in initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().getOrderDetails(widget.orderId);
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingOrderDetails,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderDetails orderDetails) {
    final isArabic = AppLocalizations.of(context)?.localeName == 'ar';
    final canCancel = OrderActionsHelper.canCancelOrder(orderDetails.status);
    final canReturn = OrderActionsHelper.canReturnOrder(orderDetails.status);

    if (!canCancel && !canReturn) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic == true ? 'إجراءات الطلب' : 'Order Actions',
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Cancel button
              if (canCancel) ...[
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    text: OrderActionsHelper.getCancelButtonText(
                      isArabic == true,
                    ),
                    icon: Icons.cancel_outlined,
                    color: Colors.red[600]!,
                    onPressed: () => _showCancelDialog(
                      context,
                      isArabic == true,
                      orderDetails.id,
                    ),
                  ),
                ),
                if (canReturn) const SizedBox(width: 12),
              ],

              // Return button
              if (canReturn)
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    text: OrderActionsHelper.getReturnButtonText(
                      isArabic == true,
                    ),
                    icon: Icons.assignment_return_outlined,
                    color: Colors.orange[600]!,
                    onPressed: () => _showReturnDialog(
                      context,
                      isArabic == true,
                      orderDetails.id,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
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
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
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

  void _showCancelDialog(BuildContext context, bool isArabic, int orderId) {
    OrderActionDialog.showCancelDialog(
      context: context,
      title: OrderActionsHelper.getCancelDialogTitle(isArabic),
      message: OrderActionsHelper.getCancelDialogMessage(isArabic),
      confirmText: isArabic ? 'نعم، إلغاء' : 'Yes, Cancel',
      cancelText: isArabic ? 'تراجع' : 'Go Back',
      onConfirm: () => context.read<OrdersCubit>().cancelOrder(orderId),
    );
  }

  void _showReturnDialog(BuildContext context, bool isArabic, int orderId) {
    OrderActionDialog.showReturnDialog(
      context: context,
      title: OrderActionsHelper.getReturnDialogTitle(isArabic),
      message: OrderActionsHelper.getReturnDialogMessage(isArabic),
      confirmText: isArabic ? 'نعم، طلب الإرجاع' : 'Yes, Request Return',
      cancelText: isArabic ? 'تراجع' : 'Go Back',
      onConfirm: () => context.read<OrdersCubit>().returnOrder(orderId),
    );
  }
}

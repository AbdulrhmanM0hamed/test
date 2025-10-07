import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/profile/presentation/view/order_details_view.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_cubit.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetailsView extends StatelessWidget {
  final int notificationId;

  const NotificationDetailsView({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DependencyInjection.getIt<NotificationDetailsCubit>()
            ..getNotificationDetails(notificationId),
      child: const NotificationDetailsViewBody(),
    );
  }
}

class NotificationDetailsViewBody extends StatelessWidget {
  const NotificationDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.notificationDetails,
      ),
      body: BlocBuilder<NotificationDetailsCubit, NotificationDetailsState>(
        builder: (context, state) {
          if (state is NotificationDetailsLoading) {
            return const Center(child: CustomProgressIndicator());
          }

          if (state is NotificationDetailsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is NotificationDetailsLoaded) {
            return _buildNotificationDetails(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationDetails(
    BuildContext context,
    NotificationDetailsLoaded state,
  ) {
    final notification = state.notification;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and status
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getNotificationColor(
                            notification.type,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getNotificationTypeLabel(context, notification.type),
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 12,
                                color: _getNotificationColor(notification.type),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.updatedAt != null
                                  ? timeago.format(
                                      notification.updatedAt!,
                                      locale: 'ar',
                                    )
                                  : AppLocalizations.of(context)!.justNow,
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 11,
                                color: Colors.grey[600]!,
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
                          color: notification.seen
                              ? Colors.green.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          notification.seen
                              ? AppLocalizations.of(context)!.seen
                              : AppLocalizations.of(context)!.newnot,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 11,
                            color: notification.seen
                                ? Colors.green[700]!
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    notification.title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    notification.description,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 14,
                      color: Colors.grey[700]!,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 20),

                  // Order Information Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.orderNumber,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 13,
                            color: Colors.grey[600]!,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.orderId.toString(),
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Actions Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.availableActions,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                DependencyInjection.getIt<OrdersCubit>()
                                  ..getOrderDetails(notification.orderId),
                            child: OrderDetailsView(
                              orderId: notification.orderId,
                            ),
                          ),
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.viewOrderDetails,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.errorOccurred,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.couldNotLoadNotificationDetails,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.back),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'system':
        return Icons.info_outline;
      case 'delivery':
        return Icons.local_shipping_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return AppColors.primary;
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      case 'delivery':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  String _getNotificationTypeLabel(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return AppLocalizations.of(context)!.notificationTypeOrder;
      case 'promotion':
        return AppLocalizations.of(context)!.notificationTypePromotion;
      case 'system':
        return AppLocalizations.of(context)!.notificationTypeSystem;
      case 'delivery':
        return AppLocalizations.of(context)!.notificationTypeDelivery;
      default:
        return AppLocalizations.of(context)!.notificationTypeDefault;
    }
  }
}

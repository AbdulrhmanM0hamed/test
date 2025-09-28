import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';

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
      appBar: const CustomAppBar(title: 'تفاصيل الإشعار'),
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
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Icon and Status
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _getNotificationColor(
                            notification.type,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
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
                              _getNotificationTypeLabel(notification.type),
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 12,
                                color: _getNotificationColor(notification.type),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeago.format(
                                notification.updatedAt,
                                locale: 'ar',
                              ),
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 11,
                                color: Colors.grey,
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
                          notification.seen ? 'مقروء' : 'جديد',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 11,
                            color: notification.seen
                                ? Colors.green
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    notification.title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      notification.description,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: 15,
                        color: Colors.grey[700]!,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  // Order ID Section
                  if (notification.orderId != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'رقم الطلب',
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: 13,
                              color: AppColors.primary,
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
                                notification.orderId!,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: 16,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          if (notification.orderId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    'الإجراءات المتاحة',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to order details
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => OrderDetailsView(orderId: notification.orderId!),
                        // ));
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('عرض تفاصيل الطلب'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
              'حدث خطأ',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
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
              label: const Text('العودة'),
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

  String _getNotificationTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return 'إشعار طلب';
      case 'promotion':
        return 'عرض خاص';
      case 'system':
        return 'إشعار النظام';
      case 'delivery':
        return 'إشعار التوصيل';
      default:
        return 'إشعار';
    }
  }
}

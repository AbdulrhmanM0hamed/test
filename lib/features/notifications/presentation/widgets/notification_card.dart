import 'package:flutter/material.dart';

import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import '../../domain/entities/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.seen
            ? Colors.white
            : AppColors.primary.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.seen
              ? Colors.grey.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getNotificationColor().withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getNotificationIcon(),
                    color: _getNotificationColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Time Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(
                              notification.createdAt,
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
                      const SizedBox(height: 6),

                      // Description
                      Text(
                        notification.description,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 13,
                          color: Colors.grey[600]!,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Order ID if available
                      if (notification.orderId != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'طلب رقم: ${notification.orderId}',
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Unread Indicator
                if (!notification.seen)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4, right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type.toLowerCase()) {
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

  Color _getNotificationColor() {
    switch (notification.type.toLowerCase()) {
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
}

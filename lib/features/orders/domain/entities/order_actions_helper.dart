import 'order_status.dart';

/// Helper class to determine which actions are available for an order
class OrderActionsHelper {
  /// Determines if cancel button should be shown for the given status
  static bool canCancelOrder(String status) {
    final orderStatus = OrderStatus.fromString(status);
    
    // Can cancel only if order is new or in progress
    return orderStatus == OrderStatus.newOrder || 
           orderStatus == OrderStatus.inProgress;
  }

  /// Determines if return button should be shown for the given status
  static bool canReturnOrder(String status) {
    final orderStatus = OrderStatus.fromString(status);
    
    // Can return only if order is delivered
    return orderStatus == OrderStatus.delivered;
  }

  /// Gets the appropriate button text for cancel action
  static String getCancelButtonText(bool isArabic) {
    return isArabic ? 'إلغاء الطلب' : 'Cancel Order';
  }

  /// Gets the appropriate button text for return action
  static String getReturnButtonText(bool isArabic) {
    return isArabic ? 'إرجاع الطلب' : 'Return Order';
  }

  /// Gets confirmation dialog title for cancel action
  static String getCancelDialogTitle(bool isArabic) {
    return isArabic ? 'تأكيد إلغاء الطلب' : 'Confirm Order Cancellation';
  }

  /// Gets confirmation dialog message for cancel action
  static String getCancelDialogMessage(bool isArabic) {
    return isArabic 
        ? 'هل أنت متأكد من أنك تريد إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.'
        : 'Are you sure you want to cancel this order? This action cannot be undone.';
  }

  /// Gets confirmation dialog title for return action
  static String getReturnDialogTitle(bool isArabic) {
    return isArabic ? 'تأكيد طلب الإرجاع' : 'Confirm Return Request';
  }

  /// Gets confirmation dialog message for return action
  static String getReturnDialogMessage(bool isArabic) {
    return isArabic 
        ? 'هل تريد طلب إرجاع هذا الطلب؟ سيتم مراجعة طلبك من قبل فريق خدمة العملاء.'
        : 'Do you want to request a return for this order? Your request will be reviewed by our customer service team.';
  }

  /// Gets success message for return action
  static String getReturnSuccessMessage(bool isArabic) {
    return isArabic 
        ? 'تم استلام طلب الإرجاع بنجاح! سيتم مراجعة طلبك وسيتم التواصل معك قريباً'
        : 'Return request received successfully! Your request will be reviewed and we will contact you soon';
  }

  /// Gets success message for cancel action
  static String getCancelSuccessMessage(bool isArabic) {
    return isArabic 
        ? 'تم إلغاء الطلب بنجاح'
        : 'Order cancelled successfully';
  }
}

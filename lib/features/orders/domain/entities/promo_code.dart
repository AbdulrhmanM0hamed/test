import 'package:equatable/equatable.dart';

class PromoCode extends Equatable {
  final String id;
  final String code;
  final String from;
  final String to;
  final int maximumTimesOfUse;
  final int numberOfTimesUsed;
  final String dedicatedTo;
  final String type; // 'amount' or 'percent'
  final String status;
  final double value;
  final int adminId;
  final String createdAt;
  final String updatedAt;

  const PromoCode({
    required this.id,
    required this.code,
    required this.from,
    required this.to,
    required this.maximumTimesOfUse,
    required this.numberOfTimesUsed,
    required this.dedicatedTo,
    required this.type,
    required this.status,
    required this.value,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate discount amount based on type and cart total
  double calculateDiscount(double cartTotal) {
    if (type == 'amount') {
      return value;
    } else if (type == 'percent') {
      return (cartTotal * value) / 100;
    }
    return 0.0;
  }

  /// Check if promo code is valid
  bool get isValid => status == '1';

  /// Check if promo code has remaining uses
  bool get hasRemainingUses => numberOfTimesUsed < maximumTimesOfUse;

  @override
  List<Object> get props => [
        id,
        code,
        from,
        to,
        maximumTimesOfUse,
        numberOfTimesUsed,
        dedicatedTo,
        type,
        status,
        value,
        adminId,
        createdAt,
        updatedAt,
      ];
}

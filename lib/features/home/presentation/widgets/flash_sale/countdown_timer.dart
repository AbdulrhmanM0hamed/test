import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';

/// مكون العداد التنازلي للفلاش سيل
class CountdownTimer extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;

  const CountdownTimer({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.09),
            blurRadius: 0,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'ينتهي في:',
            style: getMediumStyle(fontFamily: FontConstant.cairo),
          ),
          const SizedBox(width: 8),
          _buildTimeContainer(hours.toString().padLeft(2, '0')),
          _buildTimeSeparator(),
          _buildTimeContainer(minutes.toString().padLeft(2, '0')),
          _buildTimeSeparator(),
          _buildTimeContainer(seconds.toString().padLeft(2, '0')),
        ],
      ),
    );
  }

  /// إنشاء حاوية رقم الوقت
  Widget _buildTimeContainer(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  /// إنشاء الفاصل بين أرقام الوقت
  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

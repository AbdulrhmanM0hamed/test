import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/countdown_timer.dart';

/// رأس قسم الفلاش سيل
class FlashSaleHeader extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;

  const FlashSaleHeader({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عنوان القسم
          _buildSectionTitle(),

          // العداد التنازلي
          CountdownTimer(hours: hours, minutes: minutes, seconds: seconds),
        ],
      ),
    );
  }

  /// إنشاء عنوان القسم
  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'عروض حصرية',
          style: getBoldStyle(fontSize: 18, fontFamily: FontConstant.cairo),
        ),
      ],
    );
  }
}

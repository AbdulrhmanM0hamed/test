import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLastPage;

  const NextButton({
    Key? key,
    required this.onPressed,
    required this.isLastPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withOpacity(0.3),
          child: Center(
            child: Icon(
              // إظهار علامة الصح في الشاشة الأخيرة أو السهم في الشاشات الأخرى
              isLastPage
                  ? Icons
                        .check // علامة صح للشاشة الأخيرة
                  : isRTL
                  ? CupertinoIcons.chevron_left
                  : CupertinoIcons.chevron_right,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

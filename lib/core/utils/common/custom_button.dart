import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [backgroundColor!.withOpacity(0.9), backgroundColor!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix != null) prefix!,
        Text(
          text,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: textColor,
          ),
        ),
        if (suffix != null) suffix!,
      ],
    );
  }
}

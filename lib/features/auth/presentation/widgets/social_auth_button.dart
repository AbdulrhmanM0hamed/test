import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class SocialAuthButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialAuthButton({
    Key? key,
    required this.iconPath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: SvgPicture.asset(iconPath, width: 24, height: 24)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';

/// ويدجت شريط التطبيق المخصص لصفحة الفئات
class CategoryAppBar extends StatelessWidget {
  const CategoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAnimations.slideFromTop(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.products,
              style: getBoldStyle(
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  AppAssets.notificationIcon,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

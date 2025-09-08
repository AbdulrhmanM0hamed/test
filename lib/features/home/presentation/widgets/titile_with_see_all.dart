import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/generated/l10n.dart';
import 'package:flutter/material.dart';

class TitileWithSeeAll extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool showSeeAll;

  const TitileWithSeeAll({
    Key? key,
    required this.title,
    required this.onPressed,
    this.showSeeAll = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
              title,
              style: getBoldStyle(fontSize: 16, fontFamily: FontConstant.cairo),
            ),
          ],
        ),
        if (showSeeAll)
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  S.of(context).seeAll,
                  style: getMediumStyle(
                    fontSize: 14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

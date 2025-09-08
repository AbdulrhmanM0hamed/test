import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/generated/l10n.dart';

class RegistrationTermsCheckbox extends StatelessWidget {
  final bool acceptTerms;
  final Function(bool?) onChanged;

  const RegistrationTermsCheckbox({
    super.key,
    required this.acceptTerms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: acceptTerms,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: onChanged,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!acceptTerms),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'أوافق على ',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' الشروط والأحكام',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' و ',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'سياسة الخصوصية',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class CountrySelector extends StatelessWidget {
  final String? selectedCountry;
  final Function(String) onCountrySelected;

  const CountrySelector({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'اختر دولتك',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _CountryOption(
                  countryName: 'مصر',
                  countryCode: 'egypt',
                  flagPath: 'assets/images/egypt.svg',
                  isSelected: selectedCountry == 'egypt',
                  onTap: () => onCountrySelected('egypt'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CountryOption(
                  countryName: 'السعودية',
                  countryCode: 'saudi',
                  flagPath: 'assets/images/suidi.svg',
                  isSelected: selectedCountry == 'saudi',
                  onTap: () => onCountrySelected('saudi'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CountryOption extends StatelessWidget {
  final String countryName;
  final String countryCode;
  final String flagPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountryOption({
    required this.countryName,
    required this.countryCode,
    required this.flagPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  flagPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              countryName,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class RegistrationPersonalInfo extends StatelessWidget {
  final DateTime? selectedBirthDate;
  final String? selectedGender;
  final VoidCallback onBirthDateTap;
  final Function(String) onGenderSelected;

  const RegistrationPersonalInfo({
    super.key,
    required this.selectedBirthDate,
    required this.selectedGender,
    required this.onBirthDateTap,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // Birth Date Field
        _buildFieldWithLabel(
          label: 'التاريخ',
          child: GestureDetector(
            onTap: onBirthDateTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedBirthDate != null
                        ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                        : 'اختر تاريخ الميلاد',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: selectedBirthDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gender Selection
        _buildFieldWithLabel(
          label: 'الجنس',
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onGenderSelected('male'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedGender == 'male'
                            ? AppColors.primary
                            : AppColors.border,
                        width: selectedGender == 'male' ? 2 : 1,
                      ),
                      color: selectedGender == 'male'
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          color: selectedGender == 'male'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ذكر',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: selectedGender == 'male'
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => onGenderSelected('female'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedGender == 'female'
                            ? AppColors.primary
                            : AppColors.border,
                        width: selectedGender == 'female' ? 2 : 1,
                      ),
                      color: selectedGender == 'female'
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          color: selectedGender == 'female'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'أنثى',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: selectedGender == 'female'
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldWithLabel({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';

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
          label: AppLocalizations.of(context)!.birthDate,
          child: GestureDetector(
            onTap: onBirthDateTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedBirthDate != null
                        ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                        : AppLocalizations.of(context)!.selectBirthDate,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
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
          label: AppLocalizations.of(context)!.gender,
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
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : Colors.grey[650],
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
                          AppLocalizations.of(context)!.male,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: selectedGender == 'male'
                                ? AppColors.primary
                                : Theme.of(context).brightness ==
                                      Brightness.light
                                ? AppColors.black
                                : AppColors.white,
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
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : Colors.grey[650],
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
                          AppLocalizations.of(context)!.female,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: selectedGender == 'female'
                                ? AppColors.primary
                                : Theme.of(context).brightness ==
                                      Brightness.light
                                ? AppColors.black
                                : AppColors.white,
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
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

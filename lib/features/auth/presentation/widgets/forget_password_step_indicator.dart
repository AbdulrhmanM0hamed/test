import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/l10n/l10n.dart';

class ForgetPasswordStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ForgetPasswordStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: [
          // Step counter text
          Text(
            '${l10n.step} ${currentStep + 1} / $totalSteps',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Progress indicator with proper layout
          SizedBox(
            height: 60,
            child: Stack(
              children: [
                // Background progress line
                Positioned(
                  top: 15,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                // Active progress line
                if (currentStep > 0)
                  Positioned(
                    top: 15,
                    left: 16,
                    child: Container(
                      width:
                          (MediaQuery.of(context).size.width - 72) *
                          (currentStep / (totalSteps - 1)),
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                // Step circles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(totalSteps, (index) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= currentStep
                            ? AppColors.primary
                            : Colors.white,
                        border: Border.all(
                          color: index <= currentStep
                              ? AppColors.primary
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: [
                          if (index <= currentStep)
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Center(
                        child: index < currentStep
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: getBoldStyle(
                                  fontSize: FontSize.size12,
                                  fontFamily: FontConstant.cairo,
                                  color: index <= currentStep
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Step labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel(l10n.email, 0),
              _buildStepLabel(l10n.verificationCode, 1),
              _buildStepLabel(l10n.newPassword, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String label, int stepIndex) {
    return Expanded(
      child: Text(
        label,
        textAlign: stepIndex == 0
            ? TextAlign.start
            : stepIndex == 2
            ? TextAlign.end
            : TextAlign.center,
        style: stepIndex == currentStep
            ? getSemiBoldStyle(
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              )
            : getRegularStyle(
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
                color: stepIndex <= currentStep
                    ? AppColors.primary
                    : Colors.grey[500],
              ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;
  final int index; // Add index parameter to know which background to use

  const OnboardingItem({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    // التحقق من اتجاه اللغة
    final bool isLTR = Directionality.of(context) == TextDirection.ltr;

    // تحديد رقم الصورة الخلفية
    int getBackgroundNumber() {
      if (isLTR) {
        // في الإنجليزية
        return index + 1;
      } else {
        // في العربية
        return 3 - index;
      }
    }

    final int backgroundNumber = getBackgroundNumber();

    return Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // زخارف الفراشات - توزيع عشوائي لإضافة لمسة جمالية
          _buildButterflies(),

          // Background wavy image
          Positioned.fill(
            top: 180,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:
                  MediaQuery.of(context).size.height *
                  0.4, // تحديد ارتفاع ثابت للخلفية
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/on_boarding_background_$backgroundNumber.png',
                  ),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Background yellow curve at the bottom
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Center image
                    Image.asset(model.image, fit: BoxFit.contain),
                  ],
                ),
              ),

              // Title text
              Text(
                model.title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size24,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              // Space between title and description
              const SizedBox(height: 16),

              // Description text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  model.description,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Add space at the bottom
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  // دالة لإضافة الفراشات في صفحات الـ onboarding
  Widget _buildButterflies() {
    return Stack(
      children: [
        // فراشة 1
        Positioned(
          top: 80,
          right: 20,
          child: Image.asset(AppAssets.flutterColor, height: 30),
        ),

        // فراشة 2
        Positioned(
          top: 150,
          left: 40,
          child: Image.asset(AppAssets.flutterOutline, height: 25),
        ),

        // فراشة 3
        Positioned(
          bottom: 180,
          right: 50,
          child: Image.asset(AppAssets.flutterOutline, height: 20),
        ),

        // فراشة 4
        Positioned(
          bottom: 90,
          left: 30,
          child: Image.asset(AppAssets.flutterColor, height: 22),
        ),
      ],
    );
  }
}

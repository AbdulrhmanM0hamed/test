import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/features/auth/presentation/view/login_view.dart';

class LoginPromptWidget extends StatelessWidget {
  const LoginPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'أنت غير مسجل دخول',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size24,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                'يرجى تسجيل الدخول للوصول إلى حسابك الشخصي وإدارة معلوماتك',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Login Button
              CustomButton(
                text: 'تسجيل الدخول',
                onPressed: () {
                  Navigator.pushNamed(context, LoginView.routeName);
                },
              ),
              const SizedBox(height: 16),
              
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟ ',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'إنشاء حساب جديد',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

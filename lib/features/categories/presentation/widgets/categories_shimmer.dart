import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6, // عدد العناصر المؤقتة
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شيمر للصورة الدائرية
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // شيمر للنص
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 4),
                // شيمر للسطر الثاني من النص (أقصر)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  height: 10,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoryShimmerCard extends StatelessWidget {
  const CategoryShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // شيمر للصورة مع تأثير نابض
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey.withValues(alpha: 0.3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey.withValues(alpha: 0.2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // شيمر للنص الرئيسي
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            height: 14,
            width: 55,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 4),
          // شيمر للنص الثانوي
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            height: 10,
            width: 35,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

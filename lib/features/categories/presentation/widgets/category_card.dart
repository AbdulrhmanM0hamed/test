import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/categories/data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool hasOpacity;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.width = 170,
    this.height = 170,
    this.hasOpacity = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // بطاقة أساسية
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: hasOpacity
                  ? const Color(0xFF3D5B96).withOpacity(0.7)
                  : const Color(0xFF3D5B96),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // منطقة الصورة (تأخذ معظم البطاقة)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Image.asset(
                      category.imageUrl,
                      width: width * 0.5, // تصغير الصورة أكثر
                      height: height * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // اسم التصنيف في الأسفل
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // رمز الدبوس الذهبي في الزاوية
          Positioned(
            top: 5,
            left: 5,
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(AppAssets.pinIcon),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final CategoryItem category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = true;
        });

        // تأثير الضغط
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _isPressed = false;
            });
            widget.category.onTap();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 65,
              width: 65,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.secondary.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.05),
                    blurRadius: _isPressed ? 12 : 8,
                    spreadRadius: _isPressed ? 1 : 0,
                  ),
                ],
              ),
              child: Image.asset(widget.category.image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            // العنوان
            Text(
              widget.category.title,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final String image;
  final VoidCallback onTap;

  CategoryItem({required this.title, required this.image, required this.onTap});
}

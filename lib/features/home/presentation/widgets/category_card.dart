import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        width: 90,
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.2),
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.white,
              blurRadius: _isPressed ? 8 : 9,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // صورة القسم
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isPressed
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.category.icon.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: widget.category.icon,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.category, size: 30),
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : Image.asset(widget.category.icon, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 6),
            // اسم القسم
            Text(
              widget.category.title,
              style: getSemiBoldStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: _isPressed
                    ? AppColors.primary.withValues(alpha: 0.7)
                    : Colors.grey.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
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
  final String icon;
  final VoidCallback onTap;

  CategoryItem({required this.title, required this.icon, required this.onTap});
}

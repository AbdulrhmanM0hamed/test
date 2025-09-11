import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/features/categories/data/models/category_model.dart';

class CategoryTabs extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel selectedCategory;
  final Function(CategoryModel) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimations.slideFromLeft(
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.id == selectedCategory.id;

            return GestureDetector(
              onTap: () => onCategorySelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 85,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected 
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: isSelected ? 8 : 6,
                      spreadRadius: isSelected ? 1 : 0,
                      offset: Offset(0, isSelected ? 2 : 1),
                    ),
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: const Offset(0, 0.5),
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container للصورة مع خلفية دائرية
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: category.imageUrl,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.category,
                                size: 16,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // النص
                      Flexible(
                        child: Text(
                          category.name,
                          style: getSemiBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: isSelected ? Colors.white : Colors.grey[650],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

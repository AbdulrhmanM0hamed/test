import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';

/// عنصر فلتر للفلاش سيل
class FlashSaleFilter extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final Function(int) onFilterSelected;
  final AnimationController animationController;

  const FlashSaleFilter({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterSelected,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return _buildFilterItem(context, index, isSelected);
        },
      ),
    );
  }

  /// بناء عنصر الفلتر الفردي
  Widget _buildFilterItem(BuildContext context, int index, bool isSelected) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final double scale = isSelected
            ? 1.0
            : 0.9 + (animationController.value * 0.1);

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () {
              onFilterSelected(index);
            },
            child: _buildFilterContainer(context, index, isSelected),
          ),
        );
      },
    );
  }

  /// بناء حاوية الفلتر
  Widget _buildFilterContainer(
    BuildContext context,
    int index,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade400,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          filters[index],
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

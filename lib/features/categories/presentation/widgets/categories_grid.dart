import 'package:flutter/material.dart';
import 'package:test/features/categories/data/models/category_model.dart';
import 'package:test/features/categories/presentation/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel)? onCategoryTap;

  const CategoriesGrid({super.key, required this.categories, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final int row = index ~/ 2;
        final int column = index % 2;

        final bool hasOpacity = (row + column) % 2 == 1;

        return CategoryCard(
          category: categories[index],
          width: double.infinity,
          height: double.infinity,
          hasOpacity: hasOpacity,
          onTap: () {
            if (onCategoryTap != null) {
              onCategoryTap!(categories[index]);
            }
          },
        );
      },
    );
  }
}

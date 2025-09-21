import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/categories/presentation/widgets/categories_shimmer.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';
import 'package:test/features/home/presentation/cubit/main_category_state.dart';
import 'package:test/features/home/presentation/widgets/category_card.dart';
import 'package:test/features/home/presentation/widgets/section_header.dart';
import 'package:test/l10n/app_localizations.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان مع زر المشاهدة
        SectionHeader(
          onSeeAll: () {
            Navigator.pushNamed(context, '/all-categories');
          },
          title: AppLocalizations.of(context)!.categories,
          icon: Icons.category,
          iconColor: Colors.blue,
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
        ),

        // الفئات
        const ShoppingCategories(),
      ],
    );
  }
}

class ShoppingCategories extends StatelessWidget {
  const ShoppingCategories({super.key});

  void _handleCategoryTap(
    BuildContext context,
    String categorySlug,
    String categoryName,
    int categoryId,
  ) {
    // Navigate to categories view with mainCategoryId filter
    Navigator.pushNamed(
      context,
      '/categories',
      arguments: {'mainCategoryId': categoryId, 'categoryName': categoryName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCategoryCubit, MainCategoryState>(
      builder: (context, state) {
        if (state is MainCategoryLoading) {
          return const CategoriesShimmer();
        } else if (state is MainCategoryLoaded) {
          // Filter only categories that should appear on home page
          final homeCategories = state.categories
              .where((category) => category.home)
              .toList();

          return SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: homeCategories.length,
              itemBuilder: (context, index) {
                final category = homeCategories[index];
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: 1.0,
                  curve: Curves.easeInOut,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    builder: (context, double scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: CategoryCard(
                      category: CategoryItem(
                        title: category.name,
                        image: category.icon,
                        onTap: () => _handleCategoryTap(
                          context,
                          category.slug,
                          category.name,
                          category.id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is MainCategoryError) {
          return SizedBox(
            height: 130,
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

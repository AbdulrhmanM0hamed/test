import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/categories/presentation/widgets/categories_shimmer.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_cubit.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_state.dart';
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

class ShoppingCategories extends StatefulWidget {
  const ShoppingCategories({super.key});

  @override
  State<ShoppingCategories> createState() => _ShoppingCategoriesState();
}

class _ShoppingCategoriesState extends State<ShoppingCategories> {
  String? _currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = Localizations.localeOf(context).languageCode;
    
    // If locale changed, refresh the data
    if (_currentLocale != null && _currentLocale != newLocale) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SubCategoryCubit>().getSubCategories();
      });
    }
    _currentLocale = newLocale;
  }

  void _handleSubCategoryTap(
    BuildContext context,
    String categorySlug,
    String categoryName,
    int subCategoryId,
  ) {
    // Navigate to categories view with subCategoryId filter
    Navigator.pushNamed(
      context,
      '/categories-with-back',
      arguments: {
        'subCategoryId': subCategoryId,
        'categoryName': categoryName,
        'showSearchOnly': true, // Flag to show only search and products
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryCubit, SubCategoryState>(
      builder: (context, state) {
        if (state is SubCategoryLoading) {
          return const CategoriesShimmer();
        } else if (state is SubCategoryLoaded) {
          // Show first 5 sub-categories for home page
          final homeSubCategories = state.subCategories.take(5).toList();

          return SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: homeSubCategories.length,
              itemBuilder: (context, index) {
                final subCategory = homeSubCategories[index];
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
                        title: subCategory.name,
                        icon: subCategory.icon,
                        onTap: () => _handleSubCategoryTap(
                          context,
                          subCategory.slug,
                          subCategory.name,
                          subCategory.id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is SubCategoryError) {
          return SizedBox(
            height: 130,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مشكلة في الاتصال',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تحقق من الإنترنت وحاول مرة أخرى',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

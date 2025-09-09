import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/widgets/categories_shimmer.dart';
import 'package:test/features/home/presentation/widgets/category_card.dart';
import 'package:test/features/home/presentation/widgets/titile_with_see_all.dart';
import 'package:test/generated/l10n.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان مع زر المشاهدة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitileWithSeeAll(
            title: S.of(context).categories,
            onPressed: () {},
          ),
        ),

        // الفئات
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt.get<DepartmentCubit>()
                ..getDepartments(),
          child: const ShoppingCategories(),
        ),
      ],
    );
  }
}

class ShoppingCategories extends StatelessWidget {
  const ShoppingCategories({super.key});

  void _handleCategoryTap(String departmentSlug, String departmentName) {
    // هنا يمكن إضافة منطق الانتقال إلى صفحة الفئة المحددة
    print('تم النقر على القسم: $departmentName - $departmentSlug');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return const CategoriesShimmer();
        } else if (state is DepartmentLoaded) {
          return SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.departments.length,
              itemBuilder: (context, index) {
                final department = state.departments[index];
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
                        title: department.name,
                        image: department.image,
                        onTap: () => _handleCategoryTap(
                          department.slug,
                          department.name,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is DepartmentError) {
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

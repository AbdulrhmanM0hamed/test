import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/categories/domain/entities/department.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';
import 'package:test/features/categories/presentation/widgets/products_grid_widget.dart';
import 'package:test/features/categories/presentation/widgets/search_bar_widget.dart';
import 'package:test/l10n/app_localizations.dart';

/// صفحة عرض الفئات والمنتجات مع نظام الفلترة المتقدم
class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int? selectedDepartmentId;
  int? mainCategoryId;
  String? categoryName;
  bool _hasAppliedFilter = false;

  @override
  void initState() {
    super.initState();
    // Extract navigation arguments after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          mainCategoryId = args['mainCategoryId'] as int?;
          categoryName = args['categoryName'] as String?;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt.get<DepartmentCubit>()
                ..getDepartments(),
        ),
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt.get<ProductsFilterCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Apply the main category filter after providers are available (only once)
          if (mainCategoryId != null && !_hasAppliedFilter) {
            _hasAppliedFilter = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProductsFilterCubit>().updateMainCategory(mainCategoryId!);
            });
          }
          
          return Scaffold(
        appBar: AppBar(
          title: Text(categoryName ?? AppLocalizations.of(context)!.categories),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // شريط البحث مع الفلترة المتقدمة
              const SearchBarWidget(),

              // علامات تبويب الأقسام (مخفية عند الفلترة بالفئة الرئيسية)
              if (mainCategoryId == null)
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, departmentState) {
                    if (departmentState is DepartmentLoading) {
                      return const SizedBox(
                        height: 60,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (departmentState is DepartmentLoaded) {
                      final departments = departmentState.departments;

                      if (departments.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // تحديد القسم الأول افتراضياً
                      if (selectedDepartmentId == null) {
                        selectedDepartmentId = departments.first.id;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<ProductsFilterCubit>().updateFilter(
                            departmentId: selectedDepartmentId,
                          );
                        });
                      }

                      return _buildDepartmentTabs(departments);
                    }

                    if (departmentState is DepartmentError) {
                      return Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            departmentState.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

              // شبكة المنتجات مع الفلترة
              Expanded(
                child: BlocBuilder<ProductsFilterCubit, ProductsFilterState>(
                  builder: (context, state) {
                    if (state.isLoading && state.products.isEmpty) {
                      return const CustomProgressIndicator();
                    }

                    if (state.error != null && state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.error!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProductsFilterCubit>().refresh();
                              },
                              child: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.products.isEmpty && !state.isLoading) {
                      // Check if no filter is applied
                      if (state.filter.departmentId == null &&
                          state.filter.mainCategoryId == null &&
                          state.filter.subCategoryId == null &&
                          (state.filter.keyword == null ||
                              state.filter.keyword!.isEmpty)) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'اختر قسماً أو استخدم البحث لعرض المنتجات',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'يمكنك أيضاً استخدام الفلتر المتقدم للبحث الدقيق',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.noProductsInCategory,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    return ProductsGridWidget(
                      products: state.products,
                      onProductTap: (product) {
                        print('🔍 Categories: Product tapped: ${product.name}');
                        Navigator.pushNamed(
                          context,
                          '/product-details',
                          arguments: product.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentTabs(List<Department> departments) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          final isSelected = selectedDepartmentId == department.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDepartmentId = department.id;
              });

              context.read<ProductsFilterCubit>().updateFilter(
                departmentId: selectedDepartmentId,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              width: 120,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
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
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: department.image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: department.icon,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.category_outlined,
                                size: 24,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            )
                          : Icon(
                              Icons.category_outlined,
                              size: 24,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // اسم القسم
                  Text(
                    department.name,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: isSelected ? AppColors.primary : Colors.grey[700]!,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

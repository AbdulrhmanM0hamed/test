import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/l10n/app_localizations.dart';

import 'package:test/features/categories/data/models/category_model.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/cubit/products_cubit.dart';
import 'package:test/features/categories/presentation/cubit/products_state.dart';
import 'package:test/features/categories/presentation/widgets/app_bar_widget.dart';
import 'package:test/features/categories/presentation/widgets/category_tabs.dart';
import 'package:test/features/categories/presentation/widgets/products_grid_widget.dart';
import 'package:test/features/categories/presentation/widgets/search_bar_widget.dart';

/// صفحة عرض الفئات والمنتجات
class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  /// الفئة المحددة حاليًا
  CategoryModel? selectedCategory;
  
  /// القسم المحدد حاليًا
  String? selectedDepartmentName;

  /// متحكم حقل البحث
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          create: (context) => DependencyInjection.getIt.get<ProductsCubit>(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // شريط التطبيق
              const CategoryAppBar(),

              // شريط البحث
              SearchBarWidget(
                controller: searchController,
                onFilterPressed: () {},
              ),

              // علامات تبويب الفئات
              BlocBuilder<DepartmentCubit, DepartmentState>(
                builder: (context, state) {
                  if (state is DepartmentLoaded) {
                    // استخدام الأقسام مباشرة بدلاً من الفئات
                    final departments = state.departments;

                    if (departments.isNotEmpty &&
                        selectedDepartmentName == null) {
                      selectedDepartmentName = departments.first.name;
                      // تحميل المنتجات للقسم الأول
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<ProductsCubit>().getProductsByDepartment(
                          selectedDepartmentName!,
                        );
                      });
                    }

                    // تحويل الأقسام إلى CategoryModel للعرض
                    final categories = departments
                        .map(
                          (dept) => CategoryModel(
                            id: dept.id.toString(),
                            name: dept.name,
                            imageUrl: dept.image,
                            itemsCount: dept.countOfProduct,
                          ),
                        )
                        .toList();

                    return categories.isNotEmpty
                        ? CategoryTabs(
                            categories: categories,
                            selectedCategory: categories.firstWhere(
                              (cat) => cat.name == selectedDepartmentName,
                              orElse: () => categories.first,
                            ),
                            onCategorySelected: (category) {
                              setState(() {
                                selectedDepartmentName = category.name;
                              });
                              // تحميل المنتجات للقسم المحدد
                              context
                                  .read<ProductsCubit>()
                                  .getProductsByDepartment(category.name);
                            },
                          )
                        : const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),

              // شبكة المنتجات
              Expanded(
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return const CustomProgressIndicator();
                    } else if (state is ProductsLoaded) {
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
                    } else if (state is ProductsError) {
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
                              state.message,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedDepartmentName != null) {
                                  context
                                      .read<ProductsCubit>()
                                      .getProductsByDepartment(
                                        selectedDepartmentName!,
                                      );
                                }
                              },
                              child: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(child: CustomProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

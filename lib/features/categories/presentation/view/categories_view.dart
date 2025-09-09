import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/categories/data/models/category_model.dart';
import 'package:test/features/categories/data/models/dummy_products.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/widgets/app_bar_widget.dart';
import 'package:test/features/categories/presentation/widgets/category_tabs.dart';
import 'package:test/features/categories/presentation/widgets/products_grid_widget.dart';
import 'package:test/features/categories/presentation/widgets/search_bar_widget.dart';
import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';

/// صفحة عرض الفئات والمنتجات
class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  /// الفئة المحددة حاليًا
  CategoryModel? selectedCategory;

  /// متحكم حقل البحث
  final TextEditingController searchController = TextEditingController();

  /// منتجات مصنفة حسب الفئة
  late Map<int, List<Product>> categoryProducts;

  @override
  void initState() {
    super.initState();
    // تهيئة المنتجات الوهمية
    categoryProducts = DummyProducts.getCategoryProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DependencyInjection.getIt.get<DepartmentCubit>()..getDepartments(),
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
                    // تحويل الأقسام إلى فئات
                    final categories = state.departments
                        .expand((dept) => dept.categories)
                        .map(
                          (cat) => CategoryModel(
                            id: cat.id.toString(),
                            name: cat.name,
                            imageUrl: cat.image,
                            itemsCount: 0,
                          ),
                        )
                        .toList();

                    if (categories.isNotEmpty && selectedCategory == null) {
                      selectedCategory = categories.first;
                    }

                    return categories.isNotEmpty
                        ? CategoryTabs(
                            categories: categories,
                            selectedCategory:
                                selectedCategory ?? categories.first,
                            onCategorySelected: (category) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          )
                        : const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),

              // شبكة المنتجات
              ProductsGridWidget(
                products: selectedCategory != null
                    ? categoryProducts[int.tryParse(selectedCategory!.id) ??
                              1] ??
                          []
                    : [],
                onProductTap: (product) {
                  // التنقل إلى صفحة تفاصيل المنتج
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

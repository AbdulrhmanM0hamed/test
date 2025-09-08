import 'package:test/features/categories/data/models/category_model.dart';
import 'package:flutter/material.dart';

import 'package:test/features/categories/data/models/categories_data.dart';
import 'package:test/features/categories/data/models/dummy_products.dart';
import 'package:test/features/categories/presentation/widgets/app_bar_widget.dart';
import 'package:test/features/categories/presentation/widgets/category_tabs.dart';
import 'package:test/features/categories/presentation/widgets/products_grid_widget.dart';
import 'package:test/features/categories/presentation/widgets/search_bar_widget.dart';
import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';

/// صفحة عرض الفئات والمنتجات
class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  /// قائمة جميع الفئات
  late List<CategoryModel> allCategories;

  /// الفئة المحددة حاليًا
  late CategoryModel selectedCategory;

  /// متحكم حقل البحث
  final TextEditingController searchController = TextEditingController();

  /// منتجات مصنفة حسب الفئة
  late Map<int, List<Product>> categoryProducts;

  @override
  void initState() {
    super.initState();
    // تهيئة الفئات
    allCategories = getDummyCategories();
    // تعيين الفئة الافتراضية
    selectedCategory = allCategories.first;
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
    return Scaffold(
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
            CategoryTabs(
              categories: allCategories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            // شبكة المنتجات
            ProductsGridWidget(
              products: categoryProducts[int.parse(selectedCategory.id)] ?? [],
              onProductTap: (product) {
                // التنقل إلى صفحة تفاصيل المنتج
              },
            ),
          ],
        ),
      ),
    );
  }
}

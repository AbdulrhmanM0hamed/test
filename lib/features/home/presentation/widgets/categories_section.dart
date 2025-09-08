import 'package:test/features/home/presentation/widgets/category_card.dart';
import 'package:test/features/home/presentation/widgets/titile_with_see_all.dart';
import 'package:test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/app_assets.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

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
        const ShoppingCategories(),
      ],
    );
  }
}

class ShoppingCategories extends StatefulWidget {
  const ShoppingCategories({Key? key}) : super(key: key);

  @override
  State<ShoppingCategories> createState() => _ShoppingCategoriesState();
}

class _ShoppingCategoriesState extends State<ShoppingCategories> {
  late List<CategoryItem> categories;

  @override
  void initState() {
    super.initState();

    // قائمة الفئات
    categories = [
      CategoryItem(
        title: 'طعام',
        image: AppAssets.foodImage,
        onTap: () => _handleCategoryTap(0),
      ),
      CategoryItem(
        title: 'ملابس',
        image: AppAssets.wearsImage,
        onTap: () => _handleCategoryTap(1),
      ),
      CategoryItem(
        title: 'تجميل',
        image: AppAssets.beautyImage,
        onTap: () => _handleCategoryTap(2),
      ),
      CategoryItem(
        title: 'صيدلية',
        image: AppAssets.pharmacyImage,
        onTap: () => _handleCategoryTap(3),
      ),
      CategoryItem(
        title: 'إلكترونيات',
        image: AppAssets.electronicsImage,
        onTap: () => _handleCategoryTap(4),
      ),
      CategoryItem(
        title: 'ماكينات القهوة',
        image: AppAssets.machinesImage,
        onTap: () => _handleCategoryTap(5),
      ),
    ];
  }

  void _handleCategoryTap(int index) {
    // هنا يمكن إضافة منطق الانتقال إلى صفحة الفئة المحددة
    // لاحقا سيتم استبدال هذا بانتقال فعلي إلى صفحة المنتجات حسب الفئة
    print('تم النقر على الفئة: ${categories[index].title}');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // إضافة تأثير الظهور التدريجي مع حركة
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
              child: CategoryCard(category: categories[index]),
            ),
          );
        },
      ),
    );
  }
}

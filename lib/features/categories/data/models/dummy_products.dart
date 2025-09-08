import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';

/// فئة لإدارة بيانات المنتجات الوهمية المصنفة حسب الفئات
class DummyProducts {
  /// الحصول على منتجات مصنفة حسب الفئة
  static Map<int, List<Product>> getCategoryProducts() {
    final Map<int, List<Product>> categoryProducts = {};

    // منتجات فئة الملابس (ID: 1)
    categoryProducts[1] = [
      Product(
        name: 'قميص أزرق',
        price: 299.99,
        oldPrice: 329.99,
        discount: 10,
        image: AppAssets.watchImage,
        rating: 4.5,
        ratingCount: 120,
        isBestSeller: false,
      ),
      Product(
        name: 'بنطلون جينز',
        price: 399.99,
        oldPrice: 399.99,
        discount: 0,
        image: AppAssets.watchImage,
        rating: 4.2,
        ratingCount: 85,
        isBestSeller: true,
      ),
      Product(
        name: 'تيشيرت أبيض',
        price: 199.99,
        oldPrice: 209.99,
        discount: 5,
        image: AppAssets.watchImage,
        rating: 4.0,
        ratingCount: 65,
        isBestSeller: false,
      ),
    ];

    // منتجات فئة الإلكترونيات (ID: 2)
    categoryProducts[2] = [
      Product(
        name: 'سماعات لاسلكية',
        price: 599.99,
        oldPrice: 699.99,
        discount: 15,
        image: AppAssets.watchImage,
        rating: 4.8,
        ratingCount: 210,
        isBestSeller: true,
      ),
      Product(
        name: 'هاتف ذكي',
        price: 2999.99,
        oldPrice: 2999.99,
        discount: 0,
        image: AppAssets.watchImage,
        rating: 4.7,
        ratingCount: 320,
        isBestSeller: false,
      ),
    ];

    // منتجات فئة الأحذية (ID: 3)
    categoryProducts[3] = [
      Product(
        name: 'حذاء رياضي',
        price: 499.99,
        oldPrice: 599.99,
        discount: 20,
        image: AppAssets.watchImage,
        rating: 4.6,
        ratingCount: 95,
        isBestSeller: false,
      ),
      Product(
        name: 'حذاء كاجوال',
        price: 399.99,
        oldPrice: 399.99,
        discount: 0,
        image: AppAssets.watchImage,
        rating: 4.3,
        ratingCount: 78,
        isBestSeller: true,
      ),
    ];

    // منتجات فئة الإكسسوارات (ID: 4)
    categoryProducts[4] = [
      Product(
        name: 'ساعة يد',
        price: 799.99,
        oldPrice: 839.99,
        discount: 5,
        image: AppAssets.watchImage,
        rating: 4.9,
        ratingCount: 156,
        isBestSeller: true,
      ),
      Product(
        name: 'نظارة شمسية',
        price: 299.99,
        oldPrice: 299.99,
        discount: 0,
        image: AppAssets.watchImage,
        rating: 4.4,
        ratingCount: 87,
        isBestSeller: false,
      ),
    ];

    // منتجات فئة العناية الشخصية (ID: 5)
    categoryProducts[5] = [
      Product(
        name: 'عطر رجالي',
        price: 899.99,
        oldPrice: 999.99,
        discount: 10,
        image: AppAssets.watchImage,
        rating: 4.7,
        ratingCount: 124,
        isBestSeller: false,
      ),
    ];

    return categoryProducts;
  }
}

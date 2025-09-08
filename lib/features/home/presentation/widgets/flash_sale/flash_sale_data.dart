import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_product_model.dart';

/// مزود بيانات منتجات الفلاش سيل
class FlashSaleData {
  /// الحصول على قائمة منتجات الفلاش سيل
  static List<FlashSaleProduct> getFlashSaleProducts() {
    return [
      FlashSaleProduct(
        id: '1',
        title: 'سنيكرز',
        image: AppAssets.shoe2Image,
        discountPercentage: '40-60',
        originalPrice: 900,
        discountedPrice: 540,
        isFavorite: false,
      ),
      FlashSaleProduct(
        id: '2',
        title: 'أحذية الجري',
        image: AppAssets.shoeImage,
        discountPercentage: 'خصم يصل لـ40%',
        originalPrice: 750,
        discountedPrice: 450,
        isFavorite: true,
      ),
      FlashSaleProduct(
        id: '3',
        title: 'ساعات يد',
        image: AppAssets.watchImage,
        discountPercentage: 'خصم يصل لـ40%',
        originalPrice: 1200,
        discountedPrice: 720,
        isFavorite: false,
      ),
      FlashSaleProduct(
        id: '4',
        title: 'سماعات بلوتوث',
        image: AppAssets.airpodsImage,
        discountPercentage: '40-60',
        originalPrice: 500,
        discountedPrice: 300,
        isFavorite: true,
      ),
    ];
  }

  /// الحصول على قائمة فلاتر الفلاش سيل
  static List<String> getFlashSaleFilters() {
    return ['الكل', 'الأجدد', 'الأكثر إعجابا', 'الأكثر مبيعا'];
  }
}

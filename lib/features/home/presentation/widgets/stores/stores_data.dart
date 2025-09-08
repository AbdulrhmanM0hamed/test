import 'package:test/core/utils/constant/app_assets.dart';
import 'store_model.dart';

// قائمة المتاجر الوهمية
List<Store> getDummyStores() {
  return [
    Store(
      id: '1',
      name: 'العدلي لتجارة الالكترونيات',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.machinesImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل حسب البائع',
    ),
    Store(
      id: '2',
      name: 'العدلي لتجارة الالكترونيات',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.electronicsImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    Store(
      id: '3',
      name: 'العدلي لتجارة الالكترونيات',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.shoeImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    Store(
      id: '4',
      name: 'جاكوار للمواد الغذائية',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.watchImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    Store(
      id: '5',
      name: 'الأمير للمواد الغذائية',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.foodImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    Store(
      id: '6',
      name: 'العدلي لتجارة الالكترونيات',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.electronicsImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    // متاجر إضافية في الصفحة التالية
    Store(
      id: '7',
      name: 'العدلي لتجارة الالكترونيات',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.machinesImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
    Store(
      id: '8',
      name: 'جاكوار للمواد الغذائية',
      rating: 4.0,
      reviews: 254,
      imageUrl: AppAssets.foodImage,
      logoUrl: 'https://via.placeholder.com/100',
      deliveryType: 'توصيل مجاني',
    ),
  ];
}

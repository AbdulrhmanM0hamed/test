// import 'package:flutter/material.dart';
// import 'package:test/core/utils/animations/custom_progress_indcator.dart';
// import 'package:test/core/utils/constant/font_manger.dart';
// import 'package:test/core/utils/constant/styles_manger.dart';
// import 'package:test/core/utils/theme/app_colors.dart';
// import 'package:test/features/categories/domain/entities/product.dart';

// class ProductCardNew extends StatelessWidget {
//   final Product product;
//   final VoidCallback onTap;

//   const ProductCardNew({super.key, required this.product, required this.onTap});

//   /// تقليم اسم المنتج لتجنب overflow
//   String _truncateProductName(String name) {
//     const int maxWords = 4;
//     final words = name.split(' ');
//     if (words.length <= maxWords) {
//       return name;
//     }
//     return '${words.take(maxWords).join(' ')}...';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.08),
//               blurRadius: 8,
//               spreadRadius: 0,
//               offset: const Offset(0, 2),
//             ),
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.04),
//               blurRadius: 4,
//               spreadRadius: 0,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // صورة المنتج
//             Expanded(
//               flex: 3,
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Image.network(
//                     product.image,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         color: Colors.grey.withValues(alpha: 0.1),
//                         child: const CustomProgressIndicator(size: 30),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey.withValues(alpha: 0.1),
//                         child: const Center(
//                           child: Icon(
//                             Icons.image_not_supported,
//                             size: 40,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             // معلومات المنتج
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // اسم المنتج
//                     Text(
//                       _truncateProductName(product.name),
//                       style: getSemiBoldStyle(
//                         fontSize: FontSize.size13,
//                         fontFamily: FontConstant.cairo,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),

//                     // السعر
//                     Row(
//                       children: [
//                         if (product.hasDiscount) ...[
//                           // السعر بعد الخصم
//                           Text(
//                             '${product.finalPrice.toStringAsFixed(0)} ${product.currency}',
//                             style: getBoldStyle(
//                               fontSize: FontSize.size14,
//                               fontFamily: FontConstant.cairo,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           // السعر الأصلي مشطوب
//                           Text(
//                             '${product.price.toStringAsFixed(0)}',
//                             style: getMediumStyle(
//                               fontSize: FontSize.size12,
//                               fontFamily: FontConstant.cairo,
//                               color: Colors.grey,
//                             ).copyWith(decoration: TextDecoration.lineThrough),
//                           ),
//                         ] else ...[
//                           // السعر العادي
//                           Text(
//                             '${product.price.toStringAsFixed(0)} ${product.currency}',
//                             style: getBoldStyle(
//                               fontSize: FontSize.size14,
//                               fontFamily: FontConstant.cairo,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),

//                     const Spacer(),

//                     // حالة التوفر
//                     Row(
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: product.isAvailable
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           product.isAvailable ? 'متوفر' : 'غير متوفر',
//                           style: getRegularStyle(
//                             fontSize: FontSize.size12,
//                             fontFamily: FontConstant.cairo,
//                             color: product.isAvailable
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                         const Spacer(),
//                         if (product.hasDiscount)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               '${product.discountPercentage.toStringAsFixed(0)}%',
//                               style: getBoldStyle(
//                                 fontSize: FontSize.size10,
//                                 fontFamily: FontConstant.cairo,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

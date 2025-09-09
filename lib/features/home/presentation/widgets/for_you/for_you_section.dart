// import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';
// import 'package:test/features/home/presentation/widgets/titile_with_see_all.dart';
// import 'package:flutter/material.dart';
// import '../product_card.dart';

// /// قسم المنتجات المعروضة لك
// class ForYouSectionWidget extends StatelessWidget {
//   final String title;
//   final List<Product> products;
//   final VoidCallback? onSeeAllPressed;
//   final Function(Product product)? onProductTap;

//   const ForYouSectionWidget({
//     super.key,
//     required this.title,
//     required this.products,
//     this.onSeeAllPressed,
//     this.onProductTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TitileWithSeeAll(
//             title: title,
//             onPressed: onSeeAllPressed ?? () {},
//           ),
//         ),
//         const SizedBox(height: 12),
//         _buildProductList(context),
//       ],
//     );
//   }

//   Widget _buildProductList(BuildContext context) {
//     if (products.isEmpty) {
//       return const SizedBox(
//         height: 200,
//         child: Center(
//           child: Text(
//             'لا توجد منتجات حاليًا',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     return SizedBox(
//       height: 230,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: products.length,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         clipBehavior: Clip.none,
//         itemBuilder: (context, index) {
//           final isFirst = index == 0;
//           final isLast = index == products.length - 1;

//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: ProductCard(
//               product: products[index],
//               onTap: onProductTap != null
//                   ? () => onProductTap!(products[index])
//                   : null,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

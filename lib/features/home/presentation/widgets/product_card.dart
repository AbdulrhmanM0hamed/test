// import 'package:test/core/utils/constant/app_assets.dart';
// import 'package:test/core/utils/constant/font_manger.dart';
// import 'package:test/core/utils/constant/styles_manger.dart';
// import 'package:test/core/utils/theme/app_colors.dart';
// import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class ProductCard extends StatefulWidget {
//   final Product product;
//   final VoidCallback? onTap;

//   const ProductCard({super.key, required this.product, this.onTap});

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   bool _isPressed = false;
//   bool _isFavorite = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.2, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     setState(() => _isPressed = true);
//     Future.delayed(const Duration(milliseconds: 150), () {
//       if (mounted) {
//         setState(() => _isPressed = false);
//         if (widget.onTap != null) {
//           widget.onTap!();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return GestureDetector(
//       onTap: _handleTap,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: AnimatedScale(
//           scale: _isPressed ? 0.96 : 1.0,
//           duration: const Duration(milliseconds: 150),
//           child: Container(
//             width: 160,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Theme.of(context).cardColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha:0.15),
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [_buildProductImage(), _buildProductDetails()],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage() {
//     return Stack(
//       children: [
//         Hero(
//           tag: widget.product.image,
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.asset(
//               widget.product.image,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         if (widget.product.isBestSeller)
//           Positioned(
//             top: 8,
//             left: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: AppColors.secondary,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 'الأكثر مبيعاً',
//                 style: getMediumStyle(
//                   fontSize: FontSize.size11,
//                   fontFamily: FontConstant.cairo,
//                   color: AppColors.black,
//                 ),
//               ),
//             ),
//           ),
//         Positioned(
//           top: 8,
//           right: 8,
//           child: GestureDetector(
//             onTap: () => setState(() => _isFavorite = !_isFavorite),
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha:0.8),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 _isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: _isFavorite ? Colors.red : Colors.grey,
//                 size: 18,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductDetails() {
//     final discountedPrice = widget.product.price;
//     final originalPrice = widget.product.oldPrice;
//     final hasDiscount = widget.product.discount > 0;

//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.product.name,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: getSemiBoldStyle(
//               fontSize: FontSize.size12,
//               fontFamily: FontConstant.cairo,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 '${discountedPrice.toInt()} ج.م',
//                 style: getBoldStyle(
//                   fontFamily: FontConstant.cairo,
//                   fontSize: FontSize.size14,
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? AppColors.white
//                       : AppColors.primary,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               if (hasDiscount)
//                 Text(
//                   '${originalPrice.toInt()}',
//                   style: const TextStyle(
//                     fontSize: FontSize.size12,
//                     color: Colors.grey,
//                     decoration: TextDecoration.lineThrough,
//                     fontFamily: FontConstant.cairo,
//                   ),
//                 ),
//               const SizedBox(width: 4),
//               if (hasDiscount) ...[
//                 Text(
//                   '${widget.product.discount}% خصم',
//                   style: getBoldStyle(
//                     fontSize: FontSize.size11,
//                     fontFamily: FontConstant.cairo,
//                     color: AppColors.secondary,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 '(${widget.product.ratingCount})',
//                 style: getMediumStyle(
//                   fontSize: FontSize.size12,
//                   fontFamily: FontConstant.cairo,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(width: 2),
//               Text(
//                 '${widget.product.rating}',
//                 style: getSemiBoldStyle(
//                   fontSize: FontSize.size12,
//                   fontFamily: FontConstant.cairo,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               SvgPicture.asset(AppAssets.starIcon, width: 14, height: 14),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

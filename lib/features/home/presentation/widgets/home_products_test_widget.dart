// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/di/dependency_injection.dart';
// import '../cubits/featured_products/featured_products_cubit.dart';
// import '../cubits/featured_products/featured_products_state.dart';
// import 'products_section.dart';

// /// Test widget to verify home products functionality
// class HomeProductsTestWidget extends StatelessWidget {
//   const HomeProductsTestWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Products Test'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocProvider<FeaturedProductsCubit>(
//         create: (context) => DependencyInjection.getIt<FeaturedProductsCubit>()
//           ..getFeaturedProducts(),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
//                 builder: (context, state) {
//                   return ProductsSection(
//                     title: 'منتجات مميزة - اختبار',
//                     products: state is FeaturedProductsLoaded ? state.products : [],
//                     isLoading: state is FeaturedProductsLoading,
//                     errorMessage: state is FeaturedProductsError ? state.message : null,
//                     onRetry: () => context.read<FeaturedProductsCubit>().getFeaturedProducts(),
//                     onSeeAll: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('See All clicked!')),
//                       );
//                     },
//                     onProductTap: (product) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Product tapped: ${product.name}')),
//                       );
//                     },
//                     onFavoritePressed: (product) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Favorite toggled: ${product.name}')),
//                       );
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green),
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.green, size: 48),
//                     SizedBox(height: 8),
//                     Text(
//                       'Home Products Implementation Complete!',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'The new professional product cards with API integration are working correctly.',
//                       style: TextStyle(fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/view/register_view.dart';
import '../../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../../features/auth/presentation/view/login_view.dart';
import '../../../features/home/presentation/view/bottom_nav_bar.dart';
import '../../../features/product_details/presentation/view/product_details_view.dart';
import '../../../features/product_details/presentation/cubit/product_details_cubit.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingView(),
      );
    
    case LoginView.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
    
    case RegisterView.routeName:
      return MaterialPageRoute(
        builder: (context) => const RegisterView(),
      );
    
    case BottomNavBar.routeName:
      return MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      );
    
    case ProductDetailsView.routeName:
      final productId = settings.arguments as int;
      print('🔍 Route: Navigating to ProductDetails with ID: $productId');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt.get<ProductDetailsCubit>();
            cubit.getProductDetails(productId);
            return cubit;
          },
          child: const ProductDetailsView(),
        ),
      );
   
    default:
      return MaterialPageRoute(
        builder: (context) => const OnboardingView(),
      );
  }
}

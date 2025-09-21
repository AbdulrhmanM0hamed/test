import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/view/forget_password_view_new.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/features/wishlist/presentation/view/wishlist_view.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/auth/presentation/view/register_view.dart';
import 'package:test/features/categories/presentation/view/categories_view.dart';
import 'package:test/features/home/presentation/view/all_categories_view.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';
import '../../../features/splash/presentation/view/splash_view.dart';
import '../../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../../features/auth/presentation/view/login_view.dart';
import '../../../features/home/presentation/view/bottom_nav_bar.dart';
import '../../../features/product_details/presentation/view/product_details_view.dart';
import '../../../features/product_details/presentation/cubit/product_details_cubit.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  print('🔍 Navigation: Attempting to navigate to route: ${settings.name}');

  switch (settings.name) {
    case SplashView.routeName:
      print('🔍 Navigation: Navigating to SplashView');
      return MaterialPageRoute(builder: (context) => const SplashView());

    case OnboardingView.routeName:
      print('🔍 Navigation: Navigating to OnboardingView');
      return MaterialPageRoute(builder: (context) => const OnboardingView());

    case LoginView.routeName:
      print('🔍 Navigation: Navigating to LoginView');
      return MaterialPageRoute(builder: (context) => const LoginView());

    case RegisterView.routeName:
      print('🔍 Navigation: Navigating to RegisterView');
      return MaterialPageRoute(builder: (context) => const RegisterView());

    case BottomNavBar.routeName:
      print('🔍 Navigation: Navigating to BottomNavBar (Home)');
      return MaterialPageRoute(builder: (context) => const BottomNavBar());

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
    case ForgetPasswordViewNew.routeName:
      print('🔍 Navigation: Navigating to ForgotPasswordView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DependencyInjection.getIt<ForgetPasswordCubit>(),
          child: const ForgetPasswordViewNew(),
        ),
      );

    case WishlistView.routeName:
      print('🔍 Navigation: Navigating to WishlistView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<WishlistCubit>();
            cubit.getMyWishlist();
            return cubit;
          },
          child: const WishlistView(),
        ),
      );

    case '/all-categories':
      print('🔍 Navigation: Navigating to AllCategoriesView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<MainCategoryCubit>();
            cubit.getMainCategories();
            return cubit;
          },
          child: const AllCategoriesView(),
        ),
      );

    case '/categories':
      print('🔍 Navigation: Navigating to CategoriesView');
      return MaterialPageRoute(
        builder: (context) => const CategoriesView(),
        settings: settings, // Pass arguments through settings
      );

    default:
      print(
        '🔍 Navigation: Unknown route ${settings.name}, defaulting to OnboardingView',
      );
      return MaterialPageRoute(builder: (context) => const OnboardingView());
  }
}

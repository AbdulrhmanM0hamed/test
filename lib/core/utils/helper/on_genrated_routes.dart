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
import 'package:test/features/home/presentation/view/latest_products_view.dart';
import 'package:test/features/home/presentation/view/featured_products_view.dart';
import 'package:test/features/home/presentation/view/best_seller_products_view.dart';
import 'package:test/features/home/presentation/view/special_offers_view.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';
import 'package:test/features/home/presentation/cubits/latest_products/latest_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/featured_products/featured_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/best_seller_products/best_seller_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/special_offer_products/special_offer_products_cubit.dart';
import 'package:test/features/orders/presentation/views/checkout_view.dart';
import 'package:test/features/orders/presentation/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:test/features/orders/presentation/cubit/addresses_cubit/addresses_cubit.dart';
import 'package:test/features/orders/presentation/cubit/promo_code_cubit/promo_code_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/orders/presentation/widgets/address_management_view.dart';
import 'package:test/features/orders/presentation/widgets/add_edit_address_view.dart';
import 'package:test/features/orders/domain/entities/address.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_cubit.dart';
import 'package:test/features/profile/presentation/view/my_orders_view.dart';
import 'package:test/features/profile/presentation/view/order_details_view.dart';
import 'package:test/features/notifications/presentation/view/notifications_view.dart';
import 'package:test/features/notifications/presentation/view/notification_details_view.dart';
import 'package:test/features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../features/splash/presentation/view/splash_view.dart';
import '../../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../../features/auth/presentation/view/login_view.dart';
import '../../../features/home/presentation/view/bottom_nav_bar.dart';
import '../../../features/product_details/presentation/view/product_details_view.dart';
import '../../../features/product_details/presentation/cubit/product_details_cubit.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  //print('🔍 Navigation: Attempting to navigate to route: ${settings.name}');

  switch (settings.name) {
    case SplashView.routeName:
      //print('🔍 Navigation: Navigating to SplashView');
      return MaterialPageRoute(builder: (context) => const SplashView());

    case OnboardingView.routeName:
      //print('🔍 Navigation: Navigating to OnboardingView');
      return MaterialPageRoute(builder: (context) => const OnboardingView());

    case LoginView.routeName:
      //print('🔍 Navigation: Navigating to LoginView');
      return MaterialPageRoute(builder: (context) => const LoginView());

    case RegisterView.routeName:
      //print('🔍 Navigation: Navigating to RegisterView');
      return MaterialPageRoute(builder: (context) => const RegisterView());

    case BottomNavBar.routeName:
      //print('🔍 Navigation: Navigating to BottomNavBar (Home)');
      return MaterialPageRoute(builder: (context) => const BottomNavBar());

    case ProductDetailsView.routeName:
      final productId = settings.arguments as int;
      //print('🔍 Route: Navigating to ProductDetails with ID: $productId');
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
      //print('🔍 Navigation: Navigating to ForgotPasswordView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DependencyInjection.getIt<ForgetPasswordCubit>(),
          child: const ForgetPasswordViewNew(),
        ),
      );

    case WishlistView.routeName:
      //print('🔍 Navigation: Navigating to WishlistView');
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
      //print('🔍 Navigation: Navigating to AllCategoriesView');
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
      //print('🔍 Navigation: Navigating to CategoriesView');
      return MaterialPageRoute(
        builder: (context) => const CategoriesView(),
        settings: settings, // Pass arguments through settings
      );

    case '/categories-with-back':
      //print('🔍 Navigation: Navigating to CategoriesView with back button');
      return MaterialPageRoute(
        builder: (context) => const CategoriesView(showBackButton: true),
        settings: settings, // Pass arguments through settings
      );

    case '/latest-products':
      //print('🔍 Navigation: Navigating to LatestProductsView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<LatestProductsCubit>();
            cubit.getLatestProducts();
            return cubit;
          },
          child: const LatestProductsView(),
        ),
      );

    case '/featured-products':
      //print('🔍 Navigation: Navigating to FeaturedProductsView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<FeaturedProductsCubit>();
            cubit.getFeaturedProducts();
            return cubit;
          },
          child: const FeaturedProductsView(),
        ),
      );

    case '/best-seller-products':
      //print('🔍 Navigation: Navigating to BestSellerProductsView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<BestSellerProductsCubit>();
            cubit.getBestSellerProducts();
            return cubit;
          },
          child: const BestSellerProductsView(),
        ),
      );

    case '/special-offers':
      //print('🔍 Navigation: Navigating to SpecialOffersView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit =
                DependencyInjection.getIt<SpecialOfferProductsCubit>();
            cubit.getSpecialOfferProducts();
            return cubit;
          },
          child: const SpecialOffersView(),
        ),
      );

    case CheckoutView.routeName:
      //print('🔍 Navigation: Navigating to CheckoutView');
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final cubit = DependencyInjection.getIt<CheckoutCubit>();
                return cubit;
              },
            ),
            BlocProvider(
              create: (context) {
                final cubit = DependencyInjection.getIt<AddressesCubit>();
                cubit.getAddresses();
                return cubit;
              },
            ),
            BlocProvider(
              create: (context) => DependencyInjection.getIt<PromoCodeCubit>(),
            ),
            BlocProvider(
              create: (context) {
                final cubit = DependencyInjection.getIt<CartCubit>();
                cubit.getCart();
                return cubit;
              },
            ),
          ],
          child: const CheckoutView(),
        ),
      );

    case '/address-management':
      //print('🔍 Navigation: Navigating to AddressManagementView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<AddressesCubit>();
            cubit.getAddresses();
            return cubit;
          },
          child: const AddressManagementView(),
        ),
      );

    case '/add-edit-address':
      //print('🔍 Navigation: Navigating to AddEditAddressView');
      final address = settings.arguments as Address?;
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<AddressesCubit>();
            cubit.getAddresses();
            return cubit;
          },
          child: AddEditAddressView(address: address),
        ),
      );

    case MyOrdersView.routeName:
      //print('🔍 Navigation: Navigating to MyOrdersView');
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<OrdersCubit>();
            cubit.getMyOrders();
            return cubit;
          },
          child: const MyOrdersView(),
        ),
      );

    case OrderDetailsView.routeName:
      //print('🔍 Navigation: Navigating to OrderDetailsView');
      final orderId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = DependencyInjection.getIt<OrdersCubit>();
            cubit.getOrderDetails(orderId);
            return cubit;
          },
          child: OrderDetailsView(orderId: orderId),
        ),
      );

    case '/notifications':
      //print('🔍 Navigation: Navigating to NotificationsView');
      return MaterialPageRoute(builder: (context) => const NotificationsView());

    case '/notification-details':
      //print('🔍 Navigation: Navigating to NotificationDetailsView');
      final notificationId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) =>
            NotificationDetailsView(notificationId: notificationId),
      );

    default:
      //print('🔍 Navigation: Unknown route ${settings.name}, defaulting to OnboardingView');
      return MaterialPageRoute(builder: (context) => const OnboardingView());
  }
}

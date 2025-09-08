import 'package:flutter/material.dart';
import '../../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../../features/auth/presentation/view/login_view.dart';
import '../../../features/auth/presentation/view/register_view.dart';
import '../../../features/home/presentation/view/bottom_nav_bar.dart';

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
   
    default:
      return MaterialPageRoute(
        builder: (context) => const OnboardingView(),
      );
  }
}

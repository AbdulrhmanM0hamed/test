import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/app_startup_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AppStartupService _startupService;

  @override
  void initState() {
    super.initState();
    _startupService = AppStartupService.instance;
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimationSequence() async {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Start fade animation
    _fadeController.forward();

    // Start app initialization in background (non-blocking)
    _startupService.initializeApp();

    // Wait for animation to complete then navigate
    await Future.delayed(const Duration(milliseconds: 3000));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final nextRoute = appStateService.getInitialRoute();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(nextRoute);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with fade effect
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      AppAssets.logo,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // App name with fade
                // FadeTransition(
                //   opacity: _fadeAnimation,
                //   child: Column(
                //     children: [
                //       Text(
                //         'e-RAMO Store',
                //         style: TextStyle(
                //           fontSize: 32,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.primary,
                //           letterSpacing: 2,
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         'Your Shopping Experience',
                //         style: TextStyle(
                //           fontSize: 16,
                //           color: Colors.grey[600],
                //           letterSpacing: 1,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 60),

                // Custom loading indicator with GIF
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const CustomProgressIndicator(size: 90),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

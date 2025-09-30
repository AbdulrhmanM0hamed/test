import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_item.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/next_button.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/app_state_service.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingModel> _onboardingData = [];
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() {
    _onboardingData = [
      OnboardingModel(
        image: AppAssets.onboarding_1,
        title: AppLocalizations.of(context)!.easyShoppingExperience,
        description: AppLocalizations.of(context)!.easyShoppingExperienceDesc,
      ),
      OnboardingModel(
        image: AppAssets.onboarding_2,
        title: AppLocalizations.of(context)!.highQualityProducts,
        description: AppLocalizations.of(context)!.highQualityProductsDesc,
      ),
      OnboardingModel(
        image: AppAssets.onboarding_3,
        title: AppLocalizations.of(context)!.fastDelivery,
        description: AppLocalizations.of(context)!.fastDeliveryDesc,
      ),
    ];
    setState(() {
      _isDataInitialized = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    await appStateService.setOnboardingCompleted(true);
    Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    if (!_isDataInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      Directionality.of(context) == TextDirection.rtl
                          ? 'تخطي'
                          : 'Skip',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                      ),
                    ),
                  ),
                  _buildLanguageSwitch(),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                pageSnapping: true,
                physics: const PageScrollPhysics(),
                padEnds: false,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return OnboardingItem(
                    model: _onboardingData[index],
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDotsIndicator(
                    dotsCount: _onboardingData.length,
                    position: _currentPage,
                  ),
                  NextButton(
                    onPressed: _nextPage,
                    isLastPage: _currentPage == _onboardingData.length - 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSwitch() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return _buildLanguageToggle(languageService);
      },
    );
  }

  Widget _buildLanguageToggle(LanguageService languageService) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) {
              // تأثير الضغط
            },
            onTap: () async {
              // تأخير لإظهار الانيميشن قبل تغيير اللغة
              await Future.delayed(const Duration(milliseconds: 200));
              languageService.toggleLanguage();
              // Refresh onboarding data after language change
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initData();
              });
            },
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600), // زيادة المدة
        curve: Curves.elasticOut, // منحنى أكثر وضوحاً
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            // إضافة توهج عند التفاعل
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background flags
            Positioned(
              left: 4,
              top: 4,
              child: AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 500,
                ), // مدة أطول للشفافية
                opacity: languageService.isArabic ? 0.3 : 0.7,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.egypt,
                      width: 16,
                      height: 16,
                      // إزالة colorFilter لإظهار الألوان الطبيعية
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 500,
                ), // مدة أطول للشفافية
                opacity: languageService.isArabic ? 0.7 : 0.3,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.england,
                      width: 16,
                      height: 16,
                      // إزالة colorFilter لإظهار الألوان الطبيعية
                    ),
                  ),
                ),
              ),
            ),
            // Moving ball
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800), // مدة أطول للكورة
              curve: Curves.bounceOut, // منحنى مع ارتداد
              left: languageService.isArabic ? 4 : 37,
              top: 4,
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 400,
                    ), // مدة أطول لتبديل العلم
                    child: SvgPicture.asset(
                      languageService.isArabic
                          ? AppAssets.egypt
                          : AppAssets.england,
                      key: ValueKey(languageService.isArabic),
                      width: 18,
                      height: 18,
                      // إزالة colorFilter لإظهار الألوان الطبيعية للعلم
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

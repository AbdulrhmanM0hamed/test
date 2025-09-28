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
        return GestureDetector(
          onTap: () {
            languageService.toggleLanguage();
            // Refresh onboarding data after language change
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initData();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Arabic Flag
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: languageService.isArabic
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: languageService.isArabic
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: AnimatedRotation(
                    turns: languageService.isArabic ? 0 : 0.5,
                    duration: const Duration(milliseconds: 400),
                    child: SvgPicture.asset(
                      AppAssets.egypt,
                      width: 20,
                      height: 20,
                      colorFilter: languageService.isArabic
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // English Flag
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: !languageService.isArabic
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: !languageService.isArabic
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: AnimatedRotation(
                    turns: !languageService.isArabic ? 0 : -0.5,
                    duration: const Duration(milliseconds: 400),
                    child: SvgPicture.asset(
                      AppAssets.england,
                      width: 20,
                      height: 20,
                      colorFilter: !languageService.isArabic
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

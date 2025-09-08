import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_item.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/next_button.dart';
import '../../../../generated/l10n.dart';
import '../../../../features/auth/presentation/view/login_view.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/app_state_service.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingView({Key? key}) : super(key: key);

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
        title: S.of(context).easyShoppingExperience,
        description: S.of(context).easyShoppingExperienceDesc,
      ),
      OnboardingModel(
        image: AppAssets.onboarding_2,
        title: S.of(context).highQualityProducts,
        description: S.of(context).highQualityProductsDesc,
      ),
      OnboardingModel(
        image: AppAssets.onboarding_3,
        title: S.of(context).fastDelivery,
        description: S.of(context).fastDeliveryDesc,
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
    Navigator.pushReplacementNamed(context, LoginView.routeName);
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
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton(
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
}

import 'package:test/features/profile/presentation/view/profile_wrapper.dart';
import 'package:test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/home/presentation/view/home_page.dart';
import 'package:test/features/categories/presentation/view/categories_view.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/features/home/presentation/widgets/login_prompt_widget.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/home';

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _HomeViewState();
}

class _HomeViewState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn = appStateService.isLoggedIn() && !appStateService.hasLoggedOut();
    
    _screens = [
      const HomePage(),
      const CategoriesView(),
      const Center(child: Text('Favorites')),
      const Center(child: Text('Cart')),
      isLoggedIn ? const ProfileWrapper() : const LoginPromptWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: _buildCustomBottomNavBar(),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            0,
            AppAssets.homeIcon,
            AppAssets.homeIconOutline,
            S.of(context).home,
          ),
          _buildNavItem(
            1,
            AppAssets.categoryIcon,
            AppAssets.categoryIconOutline,
            S.of(context).categories,
          ),
          _buildNavItem(
            2,
            AppAssets.favoriteIcon,
            AppAssets.favoriteIconOutline,
            S.of(context).favorite,
          ),
          _buildNavItem(
            3,
            AppAssets.cartIcon,
            AppAssets.cartIconOutline,
            S.of(context).cart,
          ),
          _buildNavItem(
            4,
            AppAssets.profileIcon,
            AppAssets.profileIconOutline,
            S.of(context).profile,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String activeIcon,
    String inactiveIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: isSelected
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

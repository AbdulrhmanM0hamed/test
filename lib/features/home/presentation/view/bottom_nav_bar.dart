import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/features/profile/presentation/view/profile_wrapper.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/home/presentation/view/home_page.dart';
import 'package:test/features/categories/presentation/view/categories_view.dart';
import 'package:test/features/wishlist/presentation/view/wishlist_view.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/view/cart_view.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/cart_global_service.dart';
import 'package:test/features/home/presentation/widgets/login_prompt_widget.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/home';

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _HomeViewState();

  // Static method to navigate to home tab from other widgets
  static void navigateToHome() {
    _HomeViewState._instance?._onNavItemTapped(0);
  }
}

class _HomeViewState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  late CartCubit _cartCubit;
  late WishlistCubit _wishlistCubit;

  // Static reference to allow access from other widgets
  static _HomeViewState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _initializeScreens();
    _initializeCartGlobalService();
  }

  Future<void> _initializeCartGlobalService() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    debugPrint('🔐 BottomNavBar: User logged in: $isLoggedIn');

    if (isLoggedIn) {
      debugPrint('🚀 BottomNavBar: Initializing CartGlobalService...');
      await CartGlobalService.instance.initialize();
      debugPrint('✅ BottomNavBar: CartGlobalService initialized');
    }
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  void _initializeScreens() {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    // Initialize cubits for logged in users
    if (isLoggedIn) {
      _cartCubit = DependencyInjection.getIt<CartCubit>()..getCart();
      _wishlistCubit = DependencyInjection.getIt<WishlistCubit>()
        ..getMyWishlist();
    }

    _screens = [
      isLoggedIn
          ? MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _cartCubit),
                BlocProvider.value(value: _wishlistCubit),
              ],
              child: const HomePage(),
            )
          : const HomePage(),
      const CategoriesView(),
      isLoggedIn
          ? MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _cartCubit),
                BlocProvider.value(value: _wishlistCubit),
              ],
              child: const WishlistView(),
            )
          : const LoginPromptWidget(),
      isLoggedIn
          ? BlocProvider.value(value: _cartCubit, child: const CartView())
          : const LoginPromptWidget(),
      isLoggedIn ? const ProfileWrapper() : const LoginPromptWidget(),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return Scaffold(
      body: isLoggedIn
          ? MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _cartCubit),
                BlocProvider.value(value: _wishlistCubit),
              ],
              child: IndexedStack(index: _selectedIndex, children: _screens),
            )
          : IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: isLoggedIn
            ? MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _cartCubit),
                  BlocProvider.value(value: _wishlistCubit),
                ],
                child: _buildCustomBottomNavBar(),
              )
            : _buildCustomBottomNavBar(),
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
            1,
            AppAssets.categoryIcon,
            AppAssets.categoryIconOutline,
            AppLocalizations.of(context)!.categories,
          ),
          _buildNavItem(
            2,
            AppAssets.favoriteIcon,
            AppAssets.favoriteIconOutline,
            AppLocalizations.of(context)!.favorite,
          ),
          _buildNavItem(
            0,
            AppAssets.homeIcon,
            AppAssets.homeIconOutline,
            AppLocalizations.of(context)!.home,
          ),
          _buildCartNavItem(),
          _buildNavItem(
            4,
            AppAssets.profileIcon,
            AppAssets.profileIconOutline,
            AppLocalizations.of(context)!.profile,
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
    final isHomeIcon = index == 0; // Home is at index 0

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Special design for home icon
          if (isHomeIcon) ...[
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ] else ...[
            // Regular design for other icons
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
          ],
          const SizedBox(height: 2),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: isHomeIcon ? FontSize.size11 : FontSize.size10,
              color: isSelected
                  ? (isHomeIcon
                        ? AppColors.primary
                        : Theme.of(context).textTheme.bodyMedium?.color)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartNavItem() {
    final index = 3;
    final isSelected = _selectedIndex == index;
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
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
                  isSelected ? AppAssets.cartIcon : AppAssets.cartIconOutline,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppLocalizations.of(context)!.cart,
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
          // Cart Badge
          if (isLoggedIn)
            Positioned(
              right: 8,
              top: -2,
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  int itemCount = 0;
                  if (state is CartLoaded) {
                    itemCount = state.cart.totalQuantity;
                  }
                  debugPrint('🔢 BottomNavBar Badge: Cart state: ${state.runtimeType}, count: $itemCount');
                  if (itemCount > 0) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        itemCount > 99 ? '99+' : itemCount.toString(),
                        style: getBoldStyle(
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}

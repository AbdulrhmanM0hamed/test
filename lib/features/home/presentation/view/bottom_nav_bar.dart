import 'dart:async';
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
import 'package:test/features/wishlist/presentation/view/offline_wishlist_view.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/view/cart_view.dart';
import 'package:test/features/cart/presentation/view/offline_cart_view.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/core/services/offline_cart_service.dart';
import 'package:test/core/services/offline_wishlist_service.dart';
import 'package:test/features/home/presentation/widgets/login_prompt_widget.dart';
import 'package:test/features/home/presentation/widgets/lazy_tab_wrapper.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/home';

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _HomeViewState();

  // Static method to navigate to home tab from other widgets
  static void navigateToHome() {
    _HomeViewState._instance?._onNavItemTapped(0);
  }

  // Static method to force refresh after login
  static void forceRefreshAfterLogin() {
    _HomeViewState._instance?._forceRefreshAfterLogin();
  }
}

class _HomeViewState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List<Widget> _screens = [];
  CartCubit? _cartCubit;
  WishlistCubit? _wishlistCubit;
  late AppStateService _appStateService;
  bool _lastLoginState = false;
  Timer? _loginStateTimer;

  // Static reference to allow access from other widgets
  static _HomeViewState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _appStateService = DependencyInjection.getIt.get<AppStateService>();
    _lastLoginState =
        _appStateService.isLoggedIn() && !_appStateService.hasLoggedOut();
    _initializeScreens();
    _initializeCartGlobalService();

    // Start periodic check for login state changes
    _startLoginStateMonitoring();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if login state has changed and reinitialize if needed
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    // If login state changed, reinitialize screens
    if (_shouldReinitialize(isLoggedIn)) {
      debugPrint(
        '🔄 BottomNavBar: Login state changed, reinitializing screens',
      );
      // Add a small delay to ensure GlobalCubitService is properly initialized
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _initializeScreens();
          // Force a rebuild to ensure UI updates with new cubit instances
          setState(() {});
        }
      });
    }
  }

  bool _shouldReinitialize(bool currentLoginState) {
    // Check if we have global cubits initialized but user is not logged in
    // or if we don't have global cubits but user is logged in
    final hasGlobalCubits = GlobalCubitService.instance.cartCubit != null;
    return (hasGlobalCubits && !currentLoginState) ||
        (!hasGlobalCubits && currentLoginState);
  }

  Future<void> _initializeCartGlobalService() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    debugPrint('🔐 BottomNavBar: User logged in: $isLoggedIn');

    if (isLoggedIn) {
      debugPrint(
        '🚀 BottomNavBar: Lazy loading - CartGlobalService will load when needed',
      );
      // Don't initialize immediately - let it load when user accesses cart/wishlist
    }
  }

  void _startLoginStateMonitoring() {
    _loginStateTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final currentLoginState =
          _appStateService.isLoggedIn() && !_appStateService.hasLoggedOut();
      if (currentLoginState != _lastLoginState) {
        debugPrint(
          '🔄 BottomNavBar: Login state changed from $_lastLoginState to $currentLoginState',
        );
        _lastLoginState = currentLoginState;

        // Reinitialize screens with fresh cubit instances
        _initializeScreens();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _loginStateTimer?.cancel();
    _instance = null;
    super.dispose();
  }

  void _initializeScreens() {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    // Initialize global cubit service only if logged in (but don't load data yet)
    if (isLoggedIn) {
      GlobalCubitService.instance.initialize();
      // Always get fresh cubit references from GlobalCubitService
      _cartCubit = GlobalCubitService.instance.cartCubit;
      _wishlistCubit = GlobalCubitService.instance.wishlistCubit;
      debugPrint(
        '🌍 BottomNavBar: Using global cubit instances (lazy loading enabled)',
      );
    } else {
      // Clear global cubits if user logged out
      if (GlobalCubitService.instance.cartCubit != null) {
        debugPrint(
          '🧹 BottomNavBar: Clearing global cubits for logged out user',
        );
        GlobalCubitService.instance.reset();
      }
      _cartCubit = null;
      _wishlistCubit = null;
    }

    _screens = [
      // Home tab - always loads immediately
      const HomePage(),

      // Categories tab - no auth required, loads immediately
      const CategoriesView(),

      // Wishlist tab - lazy load with auth check
      LazyTabWrapper(
        requiresAuth: false, // Allow offline wishlist access
        requiresWishlistData:
            isLoggedIn, // Only require wishlist data for logged-in users
        child: isLoggedIn ? const WishlistView() : const OfflineWishlistView(),
      ),

      // Cart tab - lazy load with auth check
      LazyTabWrapper(
        requiresAuth: false, // Allow offline cart access
        requiresCartData:
            isLoggedIn, // Only require cart data for logged-in users
        child: isLoggedIn ? const CartView() : const OfflineCartView(),
      ),

      // Profile tab - no data loading needed
      isLoggedIn ? const ProfileWrapper() : const LoginPromptWidget(),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _forceRefreshAfterLogin() {
    debugPrint('🔄 BottomNavBar: Force refreshing after login...');
    if (mounted) {
      // Force reinitialize screens with fresh cubit instances
      _initializeScreens();
      // Force a complete rebuild
      setState(() {});
      debugPrint('✅ BottomNavBar: Force refresh completed');
    } else {
      debugPrint('⚠️ BottomNavBar: Widget not mounted, skipping refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    // Get fresh cubit references from GlobalCubitService if logged in
    final cartCubit = isLoggedIn ? GlobalCubitService.instance.cartCubit : null;
    final wishlistCubit = isLoggedIn
        ? GlobalCubitService.instance.wishlistCubit
        : null;

    return Scaffold(
      body: isLoggedIn && cartCubit != null && wishlistCubit != null
          ? MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cartCubit),
                BlocProvider.value(value: wishlistCubit),
              ],
              child: IndexedStack(index: _selectedIndex, children: _screens),
            )
          : IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: isLoggedIn && cartCubit != null && wishlistCubit != null
            ? MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: cartCubit),
                  BlocProvider.value(value: wishlistCubit),
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
          _buildWishlistNavItem(),
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

  Widget _buildWishlistNavItem() {
    final index = 2;
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
                  isSelected
                      ? AppAssets.favoriteIcon
                      : AppAssets.favoriteIconOutline,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppLocalizations.of(context)!.favorite,
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
          // Wishlist Badge - works for both logged in and offline users
          Positioned(
            right: 8,
            top: -2,
            child: isLoggedIn && _wishlistCubit != null
                ? BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      int itemCount = 0;
                      if (state is WishlistLoaded) {
                        itemCount = state.wishlistResponse.count;
                      }
                      debugPrint(
                        '❤️ BottomNavBar Badge: Wishlist state: ${state.runtimeType}, count: $itemCount',
                      );
                      if (itemCount > 0) {
                        return _buildBadge(itemCount);
                      }
                      return const SizedBox.shrink();
                    },
                  )
                : FutureBuilder<int>(
                    future: OfflineWishlistService.instance
                        .getWishlistItemCount(),
                    builder: (context, snapshot) {
                      final itemCount = snapshot.data ?? 0;
                      if (itemCount > 0) {
                        return _buildBadge(itemCount);
                      }
                      return const SizedBox.shrink();
                    },
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
          // Cart Badge - works for both logged in and offline users
          Positioned(
            right: 8,
            top: -2,
            child: isLoggedIn && _cartCubit != null
                ? BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      int itemCount = 0;
                      if (state is CartLoaded) {
                        itemCount = state.cart.totalQuantity;
                      }
                      debugPrint(
                        '🛒 BottomNavBar Badge: Cart state: ${state.runtimeType}, count: $itemCount',
                      );
                      if (itemCount > 0) {
                        return _buildBadge(itemCount);
                      }
                      return const SizedBox.shrink();
                    },
                  )
                : FutureBuilder<int>(
                    future: OfflineCartService.instance.getCartItemCount(),
                    builder: (context, snapshot) {
                      final itemCount = snapshot.data ?? 0;
                      if (itemCount > 0) {
                        return _buildBadge(itemCount);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(int itemCount) {
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
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
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
}

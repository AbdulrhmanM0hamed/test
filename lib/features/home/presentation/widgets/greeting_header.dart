import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:test/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/features/profile/presentation/view/my_orders_view.dart';
import 'package:test/features/wishlist/presentation/view/wishlist_view.dart';
import 'package:test/core/utils/widgets/logout_confirmation_dialog.dart';
import 'header_search_bar.dart';
import 'location_selector_header.dart';

class GreetingHeader extends StatefulWidget {
  final String location;
  final int notificationCount;

  const GreetingHeader({
    super.key,
    required this.location,
    required this.notificationCount,
  });

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 10,
          20,
          20,
        ),
        child: Column(
          children: [
            // Top Row - Menu, Greeting, Actions
            Row(
              children: [
                // Menu Button
                _buildMenuButton(),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          String username = AppLocalizations.of(
                            context,
                          )!.guest; // Default fallback

                          if (state is ProfileLoaded) {
                            username = state.userProfile.displayName;
                          }

                          return Text(
                            _getGreeting(context, username),
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      const LocationSelectorHeader(),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Actions Row
                Row(
                  children: [
                    //    _buildLanguageSwitch(),
                    const SizedBox(width: 12),
                    _buildNotificationButton(),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search Bar with required providers
            MultiBlocProvider(
              providers: [
                BlocProvider<ProductsFilterCubit>.value(
                  value: DependencyInjection.getIt<ProductsFilterCubit>(),
                ),
                BlocProvider<WishlistCubit>.value(
                  value: DependencyInjection.getIt<WishlistCubit>(),
                ),
                BlocProvider<CartCubit>.value(
                  value: DependencyInjection.getIt<CartCubit>(),
                ),
              ],
              child: const HeaderSearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: () => _showDrawer(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(Icons.menu_rounded, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildNotificationButton() {
    // Check if user is logged in
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/notifications');
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: SvgPicture.asset(
              AppAssets.notificationIcon,
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          // Show notification badge only for logged in users
          if (isLoggedIn)
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                int unreadCount = 0;
                if (state is NotificationsLoaded) {
                  unreadCount = state.unreadCount;
                }

                if (unreadCount > 0) {
                  return Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Get NotificationsCubit from current context before opening dialog
    final notificationsCubit = BlocProvider.of<NotificationsCubit>(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: notificationsCubit,
          child: SlideTransition(
            position: Tween<Offset>(
              // Arabic: slide from right (1.0, 0.0), English: slide from left (-1.0, 0.0)
              begin: isArabic
                  ? const Offset(1.0, 0.0)
                  : const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: Align(
              // Arabic: align to right, English: align to left
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: _buildDraggableDrawer(dialogContext, isArabic),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableDrawer(BuildContext context, bool isArabic) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Close drawer when swiping in the opposite direction
        if ((isArabic && details.delta.dx > 0) ||
            (!isArabic && details.delta.dx < 0)) {
          if (details.delta.dx.abs() > 5) {
            Navigator.pop(context);
          }
        }
      },
      child: _buildDrawer(isArabic),
    );
  }

  Widget _buildDrawer(bool isArabic) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          // Arabic: round left corners, English: round right corners
          topLeft: isArabic ? const Radius.circular(32) : Radius.zero,
          bottomLeft: isArabic ? const Radius.circular(32) : Radius.zero,
          topRight: isArabic ? Radius.zero : const Radius.circular(32),
          bottomRight: isArabic ? Radius.zero : const Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            // Arabic: shadow to left, English: shadow to right
            offset: isArabic ? const Offset(-5, 0) : const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top + 20,
              24,
              24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                // Arabic: round top-left, English: round top-right
                topLeft: isArabic ? const Radius.circular(32) : Radius.zero,
                topRight: isArabic ? Radius.zero : const Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'القائمة'
                            : 'Menu',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size20,
                          color: Colors.white,
                        ).copyWith(decoration: TextDecoration.none),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Language switcher in header
                _buildLanguageSwitcherInDrawer(),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  title: AppLocalizations.of(context)!.myOrders,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MyOrdersView.routeName);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_outline_rounded,
                  title: AppLocalizations.of(context)!.favorite,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, WishlistView.routeName);
                  },
                ),
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    int unreadCount = 0;
                    if (state is NotificationsLoaded) {
                      unreadCount = state.unreadCount;
                    }

                    return _buildDrawerItem(
                      icon: Icons.notifications_outlined,
                      title: AppLocalizations.of(context)!.notifications,
                      badge: unreadCount > 0 ? unreadCount.toString() : null,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/notifications');
                      },
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.category_outlined,
                  title: AppLocalizations.of(context)!.categories,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/all-categories');
                  },
                ),
                const SizedBox(height: 16),
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.article_outlined,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'المدونة'
                      : 'Blog',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/blogs');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.support_agent_rounded,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'التواصل'
                      : 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contact-us');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline_rounded,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'حول التطبيق'
                      : 'About App',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'الأسئلة الشائعة'
                      : 'FAQ',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.description_outlined,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'الشروط والأحكام'
                      : 'Terms & Conditions',
                  onTap: () =>
                      Navigator.pushNamed(context, '/terms-and-conditions'),
                ),
                const SizedBox(height: 16),
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(height: 8),
                // Login/Logout Button based on user state
                Builder(
                  builder: (context) {
                    final appStateService =
                        DependencyInjection.getIt<AppStateService>();
                    final isLoggedIn =
                        appStateService.isLoggedIn() &&
                        !appStateService.hasLoggedOut();

                    if (isLoggedIn) {
                      // Show Logout Button for logged in users
                      return _buildDrawerItem(
                        icon: Icons.logout_rounded,
                        title: AppLocalizations.of(context)!.logout,
                        onTap: () {
                          Navigator.pop(context);
                          LogoutConfirmationDialog.showWithDI(context);
                        },
                        isDestructive: true,
                      );
                    } else {
                      // Show Login Button for guests
                      return _buildDrawerItem(
                        icon: Icons.login_rounded,
                        title: AppLocalizations.of(context)!.login,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/login');
                        },
                        isDestructive: false,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // e-RAMO Developer Section
                _buildDeveloperSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Icon container with gradient
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDestructive
                          ? [
                              Colors.red.withValues(alpha: 0.1),
                              Colors.red.withValues(alpha: 0.05),
                            ]
                          : [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDestructive
                          ? Colors.red.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                          color: AppColors.black,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Badge and arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.red.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          badge,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[500],
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcherInDrawer() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.language_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Spacer(),
              // Professional Toggle Switch
              _buildLanguageToggle(languageService),
            ],
          ),
        );
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
          color: Colors.white.withValues(alpha: 0.2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
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
              color: Colors.white.withValues(alpha: 0.3),
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
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.egypt,
                      width: 16,
                      height: 16,
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
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.england,
                      width: 16,
                      height: 16,
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

  String _getGreeting(BuildContext context, String username) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = AppLocalizations.of(context)!.goodMorning;
    } else if (hour < 17) {
      greeting = AppLocalizations.of(context)!.goodAfternoon;
    } else {
      greeting = AppLocalizations.of(context)!.goodEvening;
    }

    return '$greeting $username';
  }

  Widget _buildDeveloperSection() {
    return GestureDetector(
      onTap: () => _showDeveloperDialog(),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text Content (Left side)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sopieh Coffee',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Developed by e-RAMO V 1.0.0',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // e-RAMO Logo (Right side)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo_eRamo.png',
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.code_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // e-RAMO Logo (Larger)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo_eRamo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.code_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Company Name
              Text(
                'e-RAMO for Digital Solution',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Version
              Text(
                'Version 1.0.0',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 24),

              // Contact Information
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  children: [
                    // Phone Number
                    _buildContactItem(
                      icon: Icons.phone_rounded,
                      title:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'رقم الهاتف'
                          : 'Phone Number',
                      value: '+20 1011559674',
                      onTap: () => _launchPhone('+201011559674'),
                    ),

                    const SizedBox(height: 16),

                    // Website
                    _buildContactItem(
                      icon: Icons.language_rounded,
                      title:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'الموقع الإلكتروني'
                          : 'Website',
                      value: 'www.e-ramo.net',
                      onTap: () => _launchWebsite('https://www.e-ramo.net/'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Thank You Message
              Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'شكراً لاستخدام تطبيقنا'
                    : 'Thank you for using our app',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  Future<void> _launchWebsite(String url) async {
    final Uri websiteUri = Uri.parse(url);
    try {
      if (await canLaunchUrl(websiteUri)) {
        await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }
}

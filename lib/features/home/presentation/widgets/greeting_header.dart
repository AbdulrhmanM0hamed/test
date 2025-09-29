import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/features/profile/presentation/view/my_orders_view.dart';
import 'package:test/features/wishlist/presentation/view/wishlist_view.dart';
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

  Widget _buildLanguageSwitch() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return GestureDetector(
          onTap: () {
            languageService.toggleLanguage();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
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
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: languageService.isArabic
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
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
                      width: 22,
                      height: 22,
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
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: !languageService.isArabic
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
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
                      width: 22,
                      height: 22,
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

  Widget _buildNotificationButton() {
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
          if (widget.notificationCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    widget.notificationCount > 9
                        ? '9+'
                        : widget.notificationCount.toString(),
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(
            // Arabic: slide from right (1.0, 0.0), English: slide from left (-1.0, 0.0)
            begin: isArabic ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: Align(
            // Arabic: align to right, English: align to left
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: _buildDrawer(),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
                        ),
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
                _buildDrawerItem(
                  icon: Icons.notifications_outlined,
                  title: AppLocalizations.of(context)!.notifications,
                  badge: widget.notificationCount > 0
                      ? widget.notificationCount.toString()
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
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
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.support_agent_rounded,
                  title: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'التواصل'
                      : 'Contact Us',
                  onTap: () => Navigator.pop(context),
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
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
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
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
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
              Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'اللغة'
                    : 'Language',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  languageService.toggleLanguage();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        languageService.isArabic
                            ? AppAssets.egypt
                            : AppAssets.england,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        languageService.isArabic ? 'عربي' : 'EN',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/generated/l10n.dart';

class GreetingHeader extends StatefulWidget {
  final String username;
  final String location;
  final int notificationCount;

  const GreetingHeader({
    super.key,
    required this.username,
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
                      Text(
                        _getGreeting(context),
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildLocationRow(),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Actions Row
                Row(
                  children: [
                    _buildLanguageSwitch(),
                    const SizedBox(width: 12),
                    _buildNotificationButton(),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search Bar integrated in header
            _buildSearchBar(),
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

  Widget _buildLocationRow() {
    return GestureDetector(
      onTap: () {
        // Handle location change
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 4),
            Text(
              widget.location,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Colors.white.withValues(alpha: 0.7),
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
        // Handle notification tap
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'القائمة',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size20,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildDrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'طلباتي',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_outline_rounded,
                  title: 'المفضلة',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.notifications_outlined,
                  title: 'الإشعارات',
                  badge: widget.notificationCount > 0
                      ? widget.notificationCount.toString()
                      : null,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.article_outlined,
                  title: 'المدونة',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.support_agent_rounded,
                  title: 'التواصل',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'حول التطبيق',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'الأسئلة الشائعة',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.description_outlined,
                  title: 'الشروط والأحكام',
                  onTap: () => Navigator.pop(context),
                ),
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
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[50],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.black,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing:
            trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
      ),
    );
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = S.of(context).goodMorning;
    } else if (hour < 17) {
      greeting = S.of(context).goodAfternoon;
    } else {
      greeting = S.of(context).goodEvening;
    }

    return '$greeting ${widget.username}';
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size14,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'البحث عن المنتجات...',
          hintStyle: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

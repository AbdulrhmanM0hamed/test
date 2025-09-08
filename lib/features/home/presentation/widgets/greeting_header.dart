import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/generated/l10n.dart';

class GreetingHeader extends StatelessWidget {
  final String username;
  final String location;
  final int notificationCount;

  const GreetingHeader({
    Key? key,
    required this.username,
    required this.location,
    required this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Greeting and Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Text
                Text(
                  _getGreeting(context),
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size20,
                  ),
                ),
                const SizedBox(height: 6),

                // Location Row
                GestureDetector(
                  onTap: () {
                    // Handle location change
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        S.of(context).changeLocation,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right side - Notification Icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(
                  AppAssets.notificationIcon,
                  height: 24,
                  width: 24,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.primary,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  top: -2,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount > 9
                            ? '9+'
                            : notificationCount.toString(),
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
        ],
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

    return '$greeting $username';
  }
}

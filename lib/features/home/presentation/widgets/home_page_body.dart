import 'package:test/features/home/presentation/widgets/for_you/data.dart';
import 'package:test/features/home/presentation/widgets/for_you/for_you_section.dart';
import 'package:test/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:test/features/home/presentation/widgets/greeting_header.dart';
import 'package:test/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:test/features/home/presentation/widgets/offers_section.dart';
import 'package:test/features/home/presentation/widgets/categories_section.dart';
import 'package:test/features/home/presentation/widgets/flash_sale_section.dart';
import 'package:test/features/home/presentation/widgets/stores/stores_showcase.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get user name from preferences or state management
    final String username =
        'User'; // Replace with actual username from user state

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting and Notification Header
          GreetingHeader(
            username: username,
            location: 'Dubai, UAE', // This would come from user location state
            notificationCount: 6,
          ),

          // Custom Search Bar
          CustomSearchBar(),

          // Offers Section with Slider
          const OffersSection(),

          // Categories Section
          const SizedBox(height: 20),
          const CategoriesSection(),

          // Flash Sale Section
          const SizedBox(height: 20),
          const FlashSaleSection(),

          // For You Section
          const SizedBox(height: 20),
          ForYouSectionWidget(
            title: S.of(context).highQualityProducts,
            products: recommendedProducts,
          ),

          // Stores Showcase Section
          const SizedBox(height: 20),
          const StoresShowcaseSection(),

          // Footer space
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

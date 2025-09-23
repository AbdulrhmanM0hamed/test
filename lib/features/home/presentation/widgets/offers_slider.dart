import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class OffersSlider extends StatefulWidget {
  const OffersSlider({super.key});

  @override
  State<OffersSlider> createState() => _OffersSliderState();
}

class _OffersSliderState extends State<OffersSlider>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // يمكن استبدال هذه القائمة بالصور الفعلية التي تريدها
  final List<String> _offerImages = [
    AppAssets.offerImage,
    AppAssets.offerImage, // استخدم صور مختلفة في التطبيق الفعلي
    AppAssets.offerImage,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // تغيير الصفحة تلقائيًا كل 5 ثواني
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentPage < _offerImages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _offerImages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              _animationController.reset();
              _animationController.forward();
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildOfferItem(_offerImages[index]),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildOfferItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // صورة العرض
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // ظل تدريجي للنص
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // نص العرض
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),

            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _offerImages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: _currentPage == index ? 24 : 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? AppColors.secondary
                  : AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/responsive/responsive_helper.dart';
import 'package:test/features/categories/domain/entities/sub_category.dart';

/// كارت احترافي لعرض الفئات الفرعية مع الوصف والتفاصيل
class SubCategoryCard extends StatefulWidget {
  final SubCategory subCategory;
  final VoidCallback onTap;

  const SubCategoryCard({
    super.key,
    required this.subCategory,
    required this.onTap,
  });

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  /// تقصير النص إلى كلمتين مع إضافة نقاط
  String _getTruncatedTitle(String title) {
    final words = title.trim().split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return title;
    if (words.length <= 2) {
      return title;
    }
    return '${words[0]} ${words[1]}...';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveBorderRadius(context),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: _isPressed ? 12 : 8,
                    offset: Offset(0, _isPressed ? 6 : 4),
                    spreadRadius: _isPressed ? 2 : 0,
                  ),
                ],
                border: Border.all(
                  color: _isPressed
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  width: _isPressed ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة الفئة
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            ResponsiveHelper.getResponsiveBorderRadius(context),
                          ),
                          topRight: Radius.circular(
                            ResponsiveHelper.getResponsiveBorderRadius(context),
                          ),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            ResponsiveHelper.getResponsiveBorderRadius(context),
                          ),
                          topRight: Radius.circular(
                            ResponsiveHelper.getResponsiveBorderRadius(context),
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.subCategory.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.coffee,
                                      size: 32,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'صورة',
                                      style: getRegularStyle(
                                        fontSize: FontSize.size10,
                                        fontFamily: FontConstant.cairo,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // تدرج لوني للنص
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // محتوى الكارت
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getResponsiveSpacing(context, 12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // اسم الفئة (كلمتين فقط مع نقاط)
                          Text(
                            _getTruncatedTitle(widget.subCategory.name),
                            style: getSemiBoldStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, FontSize.size14),
                              fontFamily: FontConstant.cairo,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),

                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                          ),

                          // الوصف أو الملخص
                          if (widget.subCategory.summary != null &&
                              widget.subCategory.summary!.isNotEmpty)
                            Text(
                              widget.subCategory.summary!,
                              style: getRegularStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      FontSize.size11,
                                    ),
                                fontFamily: FontConstant.cairo,
                                color: Colors.grey[600]!,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Text(
                              'اكتشف مجموعة متنوعة من المنتجات',
                              style: getRegularStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      FontSize.size11,
                                    ),
                                fontFamily: FontConstant.cairo,
                                color: Colors.grey[600]!,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                          const Spacer(),

                          // شريط التقدم أو المؤشر
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  8,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: ResponsiveHelper.getResponsiveIconSize(
                                  context,
                                  12,
                                ),
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_product_model.dart';

/// بطاقة عرض منتج فلاش سيل
class FlashSaleProductCard extends StatefulWidget {
  final FlashSaleProduct product;

  const FlashSaleProductCard({Key? key, required this.product})
    : super(key: key);

  @override
  State<FlashSaleProductCard> createState() => _FlashSaleProductCardState();
}

class _FlashSaleProductCardState extends State<FlashSaleProductCard>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  bool _isPressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;

    // إنشاء تأثير النبض للسعر المخفض
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // تشغيل تأثير النبض بشكل متكرر
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCardTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        decoration: _buildCardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImageSection(),
              _buildProductDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// التعامل مع النقر على البطاقة
  void _handleCardTap() {
    setState(() {
      _isPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
        // التنقل إلى صفحة تفاصيل المنتج
        print('تم النقر على المنتج: ${widget.product.title}');
      }
    });
  }

  /// إنشاء تزيين البطاقة
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// إنشاء قسم صورة المنتج
  Widget _buildProductImageSection() {
    return Stack(
      children: [
        // صورة المنتج
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(widget.product.image, fit: BoxFit.contain),
          ),
        ),

        // شارة الخصم
        Positioned(bottom: 8, right: 8, child: _buildDiscountBadge()),

        // زر المفضلة
        Positioned(top: 8, right: 8, child: _buildFavoriteButton()),
      ],
    );
  }

  /// إنشاء شارة الخصم
  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        widget.product.discountPercentage is String
            ? 'خصم ${widget.product.discountPercentage}'
            : 'خصم ${widget.product.discountPercentage}%',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// إنشاء زر المفضلة
  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : Colors.grey,
          size: 18,
        ),
      ),
    );
  }

  /// إنشاء قسم تفاصيل المنتج
  Widget _buildProductDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم المنتج
          Text(
            widget.product.title,
            style: getSemiBoldStyle(
              fontSize: 14,
              fontFamily: FontConstant.cairo,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // السعر
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // السعر المخفض
              _buildDiscountedPrice(),

              // السعر الأصلي
              Text(
                '${widget.product.originalPrice}',
                style: TextStyle(
                  fontSize: FontSize.size13,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إنشاء عرض السعر المخفض
  Widget _buildDiscountedPrice() {
    return Text(
      '${widget.product.discountedPrice} درهم',
      style: getSemiBoldStyle(fontSize: 14, fontFamily: FontConstant.cairo),
    );
  }
}

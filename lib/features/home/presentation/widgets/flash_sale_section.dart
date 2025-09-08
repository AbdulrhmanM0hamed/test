import 'package:flutter/material.dart';
import 'dart:async';

import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_header.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_filter.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_products_grid.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_data.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_product_model.dart';

/// قسم الفلاش سيل الرئيسي في الصفحة الرئيسية
class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection>
    with SingleTickerProviderStateMixin {
  int _selectedFilterIndex = 0;
  late Timer _timer;
  int _hours = 56;
  int _minutes = 12;
  int _seconds = 2;
  late AnimationController _animationController;

  late List<String> _filters;
  late List<FlashSaleProduct> _products;

  @override
  void initState() {
    super.initState();

    // تهيئة البيانات
    _filters = FlashSaleData.getFlashSaleFilters();
    _products = FlashSaleData.getFlashSaleProducts();

    // بدء العداد التنازلي
    _startTimer();

    // إنشاء وحدة تحكم الرسوم المتحركة
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // تشغيل الرسوم المتحركة
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  /// بدء العداد التنازلي
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              // وقت الخصم انتهى
              timer.cancel();
            }
          }
        }
      });
    });
  }

  /// معالجة اختيار فلتر
  void _handleFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });

    // إعادة تشغيل الرسوم المتحركة عند تغيير الفلتر
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // عنوان وعداد تنازلي
        FlashSaleHeader(hours: _hours, minutes: _minutes, seconds: _seconds),

        // فلتر المنتجات
        FlashSaleFilter(
          filters: _filters,
          selectedIndex: _selectedFilterIndex,
          onFilterSelected: _handleFilterSelected,
          animationController: _animationController,
        ),

        // شبكة المنتجات
        FlashSaleProductsGrid(
          products: _products,
          animationController: _animationController,
        ),
      ],
    );
  }
}

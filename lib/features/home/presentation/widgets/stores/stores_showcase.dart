import 'package:test/features/home/presentation/widgets/titile_with_see_all.dart';
import 'package:flutter/material.dart';

import 'store_card.dart';
import 'store_model.dart';
import 'stores_data.dart';

class StoresShowcaseSection extends StatelessWidget {
  const StoresShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Store> stores = getDummyStores();
    final double rowHeight = 90.0; // ارتفاع كل صف
    final double spacingBetweenRows = 16.0; // المسافة بين الصفوف

    // حساب الارتفاع الإجمالي (3 صفوف + 2 مسافات بينها + هامش أمان)
    final double totalHeight = (rowHeight * 3) + (spacingBetweenRows * 2) + 10;
    final double screenWidth = MediaQuery.of(context).size.width;
    // تقليل الهامش بين الكروت لتوفير مساحة أكبر
    final double cardWidth =
        (screenWidth - 20) / 2; // عرض البطاقة أكبر بتقليل الهوامش

    return SizedBox(
      height: totalHeight + 50, // إضافة ارتفاع للعنوان
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitileWithSeeAll(title: "متاجرنا المميزة ", onPressed: () {}),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero, // تقليل الهوامش الجانبية
                itemCount: (stores.length / 6).ceil(),
                itemBuilder: (context, pageIndex) {
                  return _buildStoresPage(
                    context,
                    pageIndex,
                    stores,
                    cardWidth,
                    rowHeight,
                    spacingBetweenRows,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء صفحة كاملة من المتاجر (3 صفوف)
  Widget _buildStoresPage(
    BuildContext context,
    int pageIndex,
    List<Store> stores,
    double cardWidth,
    double rowHeight,
    double spacingBetweenRows,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 4, // تقليل الهوامش
      child: Column(
        children: [
          // الصف الأول
          SizedBox(
            height: rowHeight,
            child: _buildStoreRow(context, pageIndex * 6, stores, cardWidth),
          ),
          SizedBox(height: spacingBetweenRows),
          // الصف الثاني
          SizedBox(
            height: rowHeight,
            child: _buildStoreRow(
              context,
              pageIndex * 6 + 2,
              stores,
              cardWidth,
            ),
          ),
          SizedBox(height: spacingBetweenRows),
          // الصف الثالث
          SizedBox(
            height: rowHeight,
            child: _buildStoreRow(
              context,
              pageIndex * 6 + 4,
              stores,
              cardWidth,
            ),
          ),
        ],
      ),
    );
  }

  // بناء صف من المتاجر (كل صف يحتوي على بطاقتين)
  Widget _buildStoreRow(
    BuildContext context,
    int startIndex,
    List<Store> stores,
    double cardWidth,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // البطاقة الأولى
        if (startIndex < stores.length)
          StoreCard(store: stores[startIndex], width: cardWidth),
        const SizedBox(width: 8), // تقليل المسافة بين البطاقات
        // البطاقة الثانية
        if (startIndex + 1 < stores.length)
          StoreCard(store: stores[startIndex + 1], width: cardWidth),
      ],
    );
  }
}

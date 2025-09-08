import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'store_model.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final double width;

  const StoreCard({super.key, required this.store, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المتجر
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image.asset(
              store.imageUrl,
              width: 75,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),

          // تفاصيل المتجر
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 10,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // اسم المتجر
                  Text(
                    store.name,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 12,
                    ),
                  ),

                  // التقييم
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "(${store.reviews})",
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        store.rating.toString(),
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        AppAssets.starIcon,
                        width: 14,
                        height: 14,
                      ),
                    ],
                  ),

                  // نوع التوصيل
                  Text(
                    store.deliveryType,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 11,
                      color: store.deliveryType.contains("مجاني")
                          ? Colors.amber
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

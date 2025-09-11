import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/product_details.dart';

class ProductReviewsSection extends StatelessWidget {
  final List<UserReview> reviews;

  const ProductReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 15,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.customerReviews,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                 
                ),
              ),
              const Spacer(),
              Text(
                '${reviews.length} ${AppLocalizations.of(context)!.reviews}',
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[650],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length > 3 ? 3 : reviews.length,
            separatorBuilder: (context, index) => const Divider(height: 32),
            itemBuilder: (context, index) {
              return _buildReviewItem(reviews[index]);
            },
          ),
          if (reviews.length > 3) ...[
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to all reviews page
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.viewAllReviews,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewItem(UserReview review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedNetworkImage(
            imageUrl: review.userImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[650],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.person, color: Colors.grey[400], size: 30),
            ),
            errorWidget: (context, url, error) => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[650],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.person, color: Colors.grey[650], size: 30),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Review content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User name and rating
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.userName,
                      style: getBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                       
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.star ? Icons.star : Icons.star_border,
                        color: AppColors.starActive,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Review text
              Text(
                review.review,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[650],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

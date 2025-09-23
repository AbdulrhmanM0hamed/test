import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test/l10n/app_localizations.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/entities/product_details.dart';

class AllReviewsBottomSheet extends StatelessWidget {
  final List<UserReview> reviews;
  final String productName;

  const AllReviewsBottomSheet({
    super.key,
    required this.reviews,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.customerReviews,
                        style: getBoldStyle(
                          fontSize: FontSize.size20,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reviews.length} ${AppLocalizations.of(context)!.reviews}',
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          
          // Divider
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          
          // Reviews List
          Expanded(
            child: reviews.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 32,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, index) {
                      return _buildReviewItem(reviews[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noReviewsYet,
            style: getSemiBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.beFirstToReview,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(UserReview review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // User avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: review.userImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[500],
                      size: 24,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[500],
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // User name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: getBoldStyle(
                        fontSize: FontSize.size15,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.star ? Icons.star : Icons.star_border,
                            color: index < review.star 
                                ? Colors.amber 
                                : Colors.grey[400],
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${review.star}/5',
                          style: getMediumStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Review text
          Text(
            review.review,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/features/product_details/presentation/cubit/product_review_cubit.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/validators/form_validators_clean.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/app_state_service.dart';
import '../../../../core/di/dependency_injection.dart';

class AddReviewDialog extends StatefulWidget {
  final int productId;
  final VoidCallback? onReviewSubmitted;

  const AddReviewDialog({
    super.key,
    required this.productId,
    this.onReviewSubmitted,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedStars = 0;
  final bool _isSubmitting = false;
  String? _validationError;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rate_review,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.addReview,
                    style: getBoldStyle(
                      fontSize: FontSize.size18,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey[600],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Star Rating Section
            Text(
              AppLocalizations.of(context)!.rating,
              style: getSemiBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStars = index + 1;
                      _validationError =
                          null; // Clear error when user selects stars
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: index < _selectedStars
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),

            if (_selectedStars > 0) ...[
              const SizedBox(height: 8),
              Text(
                _getRatingText(_selectedStars),
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.primary,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Review Text Section
            Text(
              AppLocalizations.of(context)!.reviewText,
              style: getSemiBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: 4,
                    maxLength: 500,
                    onChanged: (value) => setState(() {
                      _validationError = null; // Clear error when user types
                    }),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.writeYourReview,
                      hintStyle: getRegularStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[500],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      counterText: '${_reviewController.text.length}/500',
                      counterStyle: getRegularStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Validation Error Display
            if (_validationError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: getMediumStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            AppLocalizations.of(context)!.submitReview,
                            style: getSemiBoldStyle(
                              fontSize: FontSize.size16,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int stars) {
    switch (stars) {
      case 1:
        return AppLocalizations.of(context)!.veryPoor;
      case 2:
        return AppLocalizations.of(context)!.poor;
      case 3:
        return AppLocalizations.of(context)!.average;
      case 4:
        return AppLocalizations.of(context)!.good;
      case 5:
        return AppLocalizations.of(context)!.excellent;
      default:
        return '';
    }
  }

  void _submitReview() {
    // Clear previous validation error
    setState(() {
      _validationError = null;
    });

    // Check if user is logged in first
    final appStateService = DependencyInjection.getIt<AppStateService>();
    if (!appStateService.isLoggedIn()) {
      Navigator.of(context).pop(); // Close current dialog
      _showLoginRequiredDialog();
      return;
    }

    // Validate star rating using FormValidators
    final ratingError = FormValidators.validateStarRating(
      _selectedStars,
      context,
    );
    if (ratingError != null) {
      setState(() {
        _validationError = ratingError;
      });
      return;
    }

    final reviewText = _reviewController.text;

    // Validate review text using FormValidators
    final reviewError = FormValidators.validateReviewText(reviewText, context);
    if (reviewError != null) {
      setState(() {
        _validationError = reviewError;
      });
      return;
    }

    // All validations passed, submit the review
    context.read<ProductReviewCubit>().submitReview(
      productId: widget.productId,
      review: reviewText,
      star: _selectedStars,
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.login, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.loginRequired,
              style: getBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.loginRequiredToReview,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          CustomButton(
            width: 150,
            height: 50,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/login');
            },

            text: AppLocalizations.of(context)!.login,
          ),
        ],
      ),
    );
  }
}

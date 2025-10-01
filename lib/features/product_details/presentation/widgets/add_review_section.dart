import 'package:flutter/material.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/app_state_service.dart';
import '../../../../core/di/dependency_injection.dart';

class AddReviewSection extends StatefulWidget {
  final int productId;
  final VoidCallback? onReviewAdded;

  const AddReviewSection({
    super.key,
    required this.productId,
    this.onReviewAdded,
  });

  @override
  State<AddReviewSection> createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
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
          // Header
          Row(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.addReview,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Rating section
          Text(
            AppLocalizations.of(context)!.rateProduct,
            style: getSemiBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: index < _selectedRating
                        ? Colors.amber
                        : Colors.grey[400],
                    size: 32,
                  ),
                ),
              );
            }),
          ),

          if (_selectedRating > 0) ...[
            const SizedBox(height: 8),
            Text(
              _getRatingText(_selectedRating),
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Review text field
          Text(
            AppLocalizations.of(context)!.writeReview,
            style: getSemiBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.reviewHint,
                hintStyle: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[650],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Submit button
          CustomButton(
            text: AppLocalizations.of(context)!.submitReview,
            onPressed: _canSubmit() ? _submitReview : null,
            isLoading: _isSubmitting,
            backgroundColor: _canSubmit()
                ? AppColors.primary
                : AppColors.secondary,
            height: 50,
            prefix: _isSubmitting
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.send, size: 20, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _selectedRating > 0 &&
        _reviewController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  String _getRatingText(int rating) {
    final context = this.context;
    switch (rating) {
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

  Future<void> _submitReview() async {
    if (!_canSubmit()) return;

    // Check if user is logged in
    final appStateService = DependencyInjection.getIt<AppStateService>();
    if (!appStateService.isLoggedIn()) {
      _showLoginRequiredDialog();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement API call to submit review
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        CustomSnackbar.showSuccess(
          context: context,
          message: AppLocalizations.of(context)!.reviewSubmittedSuccessfully,
        );
        
        // Clear form
        _reviewController.clear();
        setState(() {
          _selectedRating = 0;
        });
        
        // Call callback
        widget.onReviewAdded?.call();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.reviewSubmissionError,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.login,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

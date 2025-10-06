import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../cubit/blog_details/blog_details_cubit.dart';

class AddCommentWidget extends StatefulWidget {
  final int blogId;
  final bool isLoading;
  final VoidCallback onCommentAdded;

  const AddCommentWidget({
    super.key,
    required this.blogId,
    required this.isLoading,
    required this.onCommentAdded,
  });

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn = appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Comment Header
          Row(
            children: [
              Icon(
                Icons.add_comment_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Comment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Comment Input
          if (!isLoggedIn)
            _buildLoginPrompt(context)
          else
            _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.login,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Login to Comment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please login to your account to add a comment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.login),
            label: Text(AppLocalizations.of(context)!.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded 
              ? AppColors.primary 
              : AppColors.grey.withOpacity(0.3),
          width: _isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Comment Text Field
          TextField(
            controller: _commentController,
            focusNode: _focusNode,
            maxLines: _isExpanded ? 4 : 1,
            decoration: InputDecoration(
              hintText: 'Write your comment here...',
              hintStyle: TextStyle(
                color: AppColors.grey,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
            onTap: () {
              if (!_isExpanded) {
                setState(() {
                  _isExpanded = true;
                });
              }
            },
            onChanged: (value) {
              setState(() {});
            },
          ),

          // Comment Actions (shown when expanded)
          if (_isExpanded) ...[
            Container(
              height: 1,
              color: AppColors.grey.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Character count
                  Text(
                    '${_commentController.text.length}/500',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _commentController.text.length > 500
                          ? AppColors.error
                          : AppColors.grey,
                    ),
                  ),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      TextButton(
                        onPressed: widget.isLoading ? null : () {
                          _commentController.clear();
                          _focusNode.unfocus();
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),

                      // Submit button
                      ElevatedButton(
                        onPressed: _canSubmitComment() ? _submitComment : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: widget.isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canSubmitComment() {
    return !widget.isLoading &&
           _commentController.text.trim().isNotEmpty &&
           _commentController.text.length <= 500;
  }

  void _submitComment() {
    if (!_canSubmitComment()) return;

    final comment = _commentController.text.trim();
    
    context.read<BlogDetailsCubit>().addComment(
      blogId: widget.blogId,
      comment: comment,
    );

    // Clear the form
    _commentController.clear();
    _focusNode.unfocus();
    setState(() {
      _isExpanded = false;
    });

    widget.onCommentAdded();
  }
}

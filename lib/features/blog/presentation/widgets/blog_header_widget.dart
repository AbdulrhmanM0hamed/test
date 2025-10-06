import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../domain/entities/blog.dart';

class BlogHeaderWidget extends StatelessWidget {
  final Blog blog;

  const BlogHeaderWidget({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Blog Image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: blog.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.grey.withOpacity(0.1),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.grey.withOpacity(0.1),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 64,
                color: AppColors.grey,
              ),
            ),
          ),
        ),

        // Blog Header Info
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Title
              Text(
                blog.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Blog Meta Information
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  // Date and Time
                  _buildMetaItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    text: '${blog.createdAtDay} • ${blog.createdAtHour}',
                  ),

                  // Views
                  _buildMetaItem(
                    context,
                    icon: Icons.visibility_outlined,
                    text: '${blog.views} ${AppLocalizations.of(context)!.views}',
                  ),

                  // Comments
                  _buildMetaItem(
                    context,
                    icon: Icons.comment_outlined,
                    text: '${blog.commentsCount} ${AppLocalizations.of(context)!.comments}',
                  ),

                  // Reading Time
                  _buildMetaItem(
                    context,
                    icon: Icons.schedule_outlined,
                    text: '${blog.estimatedReadingTime} ${AppLocalizations.of(context)!.minRead}',
                  ),
                ],
              ),

              // Meta Keywords (if available)
              if (blog.metaKeywords.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: blog.metaKeywords.take(5).map((keyword) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        keyword,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        // Divider
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.grey.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildMetaItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../cubit/blog_details/blog_details_cubit.dart';
import '../cubit/blog_details/blog_details_state.dart';
import '../widgets/blog_content_widget.dart';
import '../widgets/blog_header_widget.dart';
import '../widgets/blog_details_shimmer.dart';

class BlogDetailsView extends StatelessWidget {
  static const String routeName = '/blog-details';
  final int blogId;

  const BlogDetailsView({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogDetailsCubit>(
      create: (context) =>
          DependencyInjection.getIt<BlogDetailsCubit>()..getBlogDetails(blogId),
      child: Scaffold(
        appBar: CustomAppBar(title: AppLocalizations.of(context)!.blog),
        body: BlocConsumer<BlogDetailsCubit, BlogDetailsState>(
          listener: (context, state) {
            if (state is BlogCommentAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is BlogCommentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BlogDetailsLoading) {
              return const BlogDetailsShimmer();
            } else if (state is BlogDetailsLoaded ||
                state is BlogCommentAdding ||
                state is BlogCommentAdded ||
                state is BlogCommentError) {
              final blog = state is BlogDetailsLoaded
                  ? state.blog
                  : state is BlogCommentAdding
                  ? state.blog
                  : state is BlogCommentAdded
                  ? state.blog
                  : (state as BlogCommentError).blog;

              final isAddingComment = state is BlogCommentAdding;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BlogDetailsCubit>().getBlogDetails(blogId);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blog Header
                      BlogHeaderWidget(blog: blog),

                      // Blog Content
                      BlogContentWidget(blog: blog),

                      //   const SizedBox(height: 24),

                      // Comments Section
                      // CommentsSection(
                      //   comments: blog.comments,
                      //   commentsCount: blog.commentsCount,
                      // ),
                      const SizedBox(height: 16),

                      // // Add Comment Section
                      // AddCommentWidget(
                      //   blogId: blog.id,
                      //   isLoading: isAddingComment,
                      //   onCommentAdded: () {
                      //     // Comment will be added via cubit
                      //   },
                      // ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            } else if (state is BlogDetailsError) {
              return _buildErrorState(context, state.message);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorOccurred,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BlogDetailsCubit>().getBlogDetails(blogId);
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
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
      ),
    );
  }
}

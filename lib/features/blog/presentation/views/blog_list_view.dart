import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../cubit/blog_list/blog_list_cubit.dart';
import '../cubit/blog_list/blog_list_state.dart';
import '../cubit/hot_topics/hot_topics_cubit.dart';
import '../widgets/blog_card.dart';
import '../widgets/hot_topics_section.dart';
import '../widgets/blog_shimmer.dart';
import 'blog_details_view.dart';

class BlogListView extends StatefulWidget {
  static const String routeName = '/blogs';

  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  final ScrollController _scrollController = ScrollController();
  bool _listenerAdded = false;

  @override
  void initState() {
    super.initState();
    // Setup scroll listener inside Builder to avoid context issues
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener(BuildContext context) {
    if (!_listenerAdded) {
      _scrollController.addListener(() {
        if (_scrollController.hasClients &&
            _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<BlogListCubit>().loadMoreBlogs();
        }
      });
      _listenerAdded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlogListCubit>(
          create: (context) => DependencyInjection.getIt<BlogListCubit>()
            ..getBlogs(),
        ),
        BlocProvider<HotTopicsCubit>(
          create: (context) => DependencyInjection.getIt<HotTopicsCubit>()
            ..getHotTopics(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.blog,
        ),
        body: Builder(
          builder: (context) {
            // Setup scroll listener here where BlogListCubit is available
            _setupScrollListener(context);

            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  context.read<BlogListCubit>().refreshBlogs(),
                  context.read<HotTopicsCubit>().refreshHotTopics(),
                ]);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Hot Topics Section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 24),
                      child: HotTopicsSection(),
                    ),
                  ),

                  // Blog List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.allBlogs,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Blog List
                  BlocBuilder<BlogListCubit, BlogListState>(
                    builder: (context, state) {
                      if (state is BlogListLoading) {
                        return const SliverToBoxAdapter(
                          child: BlogShimmer(),
                        );
                      } else if (state is BlogListLoaded) {
                        if (state.blogs.isEmpty) {
                          return SliverFillRemaining(
                            child: _buildEmptyState(context),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < state.blogs.length) {
                                return BlogCard(
                                  blog: state.blogs[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      BlogDetailsView.routeName,
                                      arguments: state.blogs[index].id,
                                    );
                                  },
                                );
                              } else if (state is BlogListLoadingMore) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return null;
                            },
                            childCount: state.blogs.length + 
                                (state is BlogListLoadingMore ? 1 : 0),
                          ),
                        );
                      } else if (state is BlogListLoadingMore) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < state.currentBlogs.length) {
                                return BlogCard(
                                  blog: state.currentBlogs[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      BlogDetailsView.routeName,
                                      arguments: state.currentBlogs[index].id,
                                    );
                                  },
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            childCount: state.currentBlogs.length + 1,
                          ),
                        );
                      } else if (state is BlogListError) {
                        return SliverFillRemaining(
                          child: _buildErrorState(context, state.message),
                        );
                      }

                      return const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noBlogsFound,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.checkBackLaterForNewBlogPosts,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BlogListCubit>().refreshBlogs();
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

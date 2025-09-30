import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_cubit.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_state.dart';
import 'package:test/features/categories/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/home/presentation/widgets/sub_category_card.dart';
import 'package:test/core/utils/responsive/responsive_helper.dart';
import 'package:test/l10n/app_localizations.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  static const String routeName = '/all-categories';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubCategoryCubit(
        getSubCategoriesUseCase:
            DependencyInjection.getIt<GetSubCategoriesUseCase>(),
      )..getSubCategories(),
      child: Scaffold(
        appBar: CustomAppBar(title: AppLocalizations.of(context)!.categories),
        body: BlocBuilder<SubCategoryCubit, SubCategoryState>(
          builder: (context, state) {
            if (state is SubCategoryLoading) {
              return const CustomProgressIndicator();
            }

            if (state is SubCategoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SubCategoryCubit>().getSubCategories();
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is SubCategoryLoaded) {
              final categories = state.subCategories;

              if (categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noCategoriesAvailable,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SubCategoryCubit>().getSubCategories();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: ResponsiveHelper.getResponsivePadding(context)
                            .copyWith(
                              bottom: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                16,
                              ),
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.discoverAllCategories,
                              style: getSemiBoldStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      FontSize.size22,
                                    ),
                                fontFamily: FontConstant.cairo,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                8,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.discoverSetsOfProducts,
                              style: getRegularStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      FontSize.size14,
                                    ),
                                fontFamily: FontConstant.cairo,
                                color: Colors.grey[600]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveHelper.getGridCrossAxisCount(context),
                          crossAxisSpacing:
                              ResponsiveHelper.getResponsiveSpacing(
                                context,
                                16,
                              ),
                          mainAxisSpacing:
                              ResponsiveHelper.getResponsiveSpacing(
                                context,
                                16,
                              ),
                          childAspectRatio: ResponsiveHelper.getResponsiveValue(
                            context,
                            smallMobile: 0.7,
                            mobile: 0.72,
                            tablet: 0.8,
                            desktop: 0.85,
                          ),
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final subCategory = categories[index];
                          return SubCategoryCard(
                            subCategory: subCategory,
                            onTap: () =>
                                _navigateToProducts(context, subCategory),
                          );
                        }, childCount: categories.length),
                      ),
                    ),

                    // Bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToProducts(BuildContext context, subCategory) {
    // Navigate to categories view with subCategoryId filter and back button
    Navigator.pushNamed(
      context,
      '/categories-with-back',
      arguments: {
        'subCategoryId': subCategory.id,
        'categoryName': subCategory.name,
        'showSearchOnly': true,
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/home/presentation/cubit/main_category_cubit.dart';
import 'package:test/features/home/presentation/cubit/main_category_state.dart';
import 'package:test/features/home/presentation/widgets/main_category_card.dart';
import 'package:test/l10n/app_localizations.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  static const String routeName = '/all-categories';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DependencyInjection.getIt<MainCategoryCubit>()
        ..getMainCategories(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.categories,
            style: getSemiBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MainCategoryCubit, MainCategoryState>(
          builder: (context, state) {
            if (state is MainCategoryLoading) {
              return const CustomProgressIndicator();
            }
            
            if (state is MainCategoryError) {
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
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainCategoryCubit>().getMainCategories();
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            }
            
            if (state is MainCategoryLoaded) {
              final categories = state.categories;
              
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
                        'لا توجد فئات متاحة حالياً',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MainCategoryCubit>().getMainCategories();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اكتشف جميع الفئات',
                              style: getSemiBoldStyle(
                                fontSize: FontSize.size20,
                                fontFamily: FontConstant.cairo,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تصفح مجموعة واسعة من المنتجات المصنفة حسب الفئات',
                              style: getRegularStyle(
                                fontSize: FontSize.size14,
                                fontFamily: FontConstant.cairo,
                                color: Colors.grey[600]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final category = categories[index];
                          return MainCategoryCard(
                            category: category,
                            onTap: () {
                              _navigateToProducts(context, category);
                            },
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                    
                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
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

  void _navigateToProducts(BuildContext context, category) {
    // Navigate to categories view with mainCategoryId filter
    Navigator.pushNamed(
      context,
      '/categories',
      arguments: {
        'mainCategoryId': category.id,
        'categoryName': category.name,
      },
    );
  }
}

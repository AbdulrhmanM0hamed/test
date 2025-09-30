import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/categories/domain/entities/department.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_state.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/features/categories/presentation/widgets/products_grid_widget.dart';
import 'package:test/features/categories/presentation/widgets/search_bar_widget.dart';
import 'package:test/l10n/app_localizations.dart';

/// صفحة عرض الفئات والمنتجات مع نظام الفلترة المتقدم
class CategoriesView extends StatefulWidget {
  final bool showBackButton;

  const CategoriesView({super.key, this.showBackButton = false});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int? selectedDepartmentId;
  int? mainCategoryId;
  int? subCategoryId;
  String? categoryName;
  bool showSearchOnly = false;
  bool _hasAppliedFilter = false;
  final ScrollController _scrollController = ScrollController();
  bool _scrollListenerAdded = false;

  @override
  void initState() {
    super.initState();

    // Extract navigation arguments after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          mainCategoryId = args['mainCategoryId'] as int?;
          subCategoryId = args['subCategoryId'] as int?;
          categoryName = args['categoryName'] as String?;
          showSearchOnly = args['showSearchOnly'] as bool? ?? false;
        });

        // SubCategory filter will be applied in the Builder where context has access to providers
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt.get<DepartmentCubit>()
                ..getDepartments(),
        ),
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt.get<ProductsFilterCubit>(),
        ),
        BlocProvider.value(
          value:
              GlobalCubitService.instance.wishlistCubit ??
              DependencyInjection.getIt.get<WishlistCubit>(),
        ),
        BlocProvider.value(
          value:
              GlobalCubitService.instance.cartCubit ??
              DependencyInjection.getIt.get<CartCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Setup scroll listener with access to ProductsFilterCubit
          if (!_scrollListenerAdded) {
            _scrollListenerAdded = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.addListener(() {
                if (!mounted || !_scrollController.hasClients) return;

                final pixels = _scrollController.position.pixels;
                final maxExtent = _scrollController.position.maxScrollExtent;
                final threshold = maxExtent - 200;

                print(
                  '🔄 Scroll: pixels=$pixels, maxExtent=$maxExtent, threshold=$threshold',
                );

                if (pixels >= threshold) {
                  context.read<ProductsFilterCubit>().loadMore();
                }
              });
            });
          }

          // Apply filters after providers are available (only once)
          if (!_hasAppliedFilter) {
            _hasAppliedFilter = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mainCategoryId != null) {
                context.read<ProductsFilterCubit>().updateMainCategory(
                  mainCategoryId!,
                );
              } else if (subCategoryId != null) {
                context.read<ProductsFilterCubit>().updateSubCategory(
                  subCategoryId!,
                );
              }
            });
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: categoryName ?? AppLocalizations.of(context)!.categories,
              automaticallyImplyLeading: widget.showBackButton,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // شريط البحث مع الفلترة المتقدمة (إخفاء الفلتر عند الدخول من sub-category)
                  SearchBarWidget(hideFilter: showSearchOnly),

                  // علامات تبويب الأقسام (مخفية عند الفلترة بالفئة الرئيسية أو عند عرض sub-category فقط)
                  if (mainCategoryId == null && !showSearchOnly)
                    BlocBuilder<DepartmentCubit, DepartmentState>(
                      builder: (context, departmentState) {
                        if (departmentState is DepartmentLoading) {
                          return const SizedBox(
                            height: 60,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (departmentState is DepartmentLoaded) {
                          final departments = departmentState.departments;

                          if (departments.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          // تحديد القسم الأول افتراضياً
                          if (selectedDepartmentId == null) {
                            selectedDepartmentId = departments.first.id;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<ProductsFilterCubit>().updateFilter(
                                departmentId: selectedDepartmentId,
                              );
                            });
                          }

                          return _buildDepartmentTabs(departments);
                        }

                        if (departmentState is DepartmentError) {
                          return Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                departmentState.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                  // شبكة المنتجات مع الفلترة
                  Expanded(
                    child: BlocBuilder<ProductsFilterCubit, ProductsFilterState>(
                      builder: (context, state) {
                        if (state.isLoading && state.products.isEmpty) {
                          return const CustomProgressIndicator();
                        }

                        if (state.error != null && state.products.isEmpty) {
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
                                  state.error!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<ProductsFilterCubit>()
                                        .refresh();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.retry,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state.products.isEmpty && !state.isLoading) {
                          // Check if no filter is applied
                          if (state.filter.departmentId == null &&
                              state.filter.mainCategoryId == null &&
                              state.filter.subCategoryId == null &&
                              (state.filter.keyword == null ||
                                  state.filter.keyword!.isEmpty)) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_list_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'اختر قسماً أو استخدم البحث لعرض المنتجات',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'يمكنك أيضاً استخدام الفلتر المتقدم للبحث الدقيق',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noProductsInCategory,
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
                        }

                        return ProductsGridWidget(
                          products: state.products,
                          isLoadingMore: state.isLoadingMore,
                          scrollController: _scrollController,
                          onProductTap: (product) {
                            //print('🔍 Categories: Product tapped: ${product.name}');
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product.id,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentTabs(List<Department> departments) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          final isSelected = selectedDepartmentId == department.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDepartmentId = department.id;
              });

              context.read<ProductsFilterCubit>().updateFilter(
                departmentId: selectedDepartmentId,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              width: 120,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.white,
                    blurRadius: isSelected ? 8 : 9,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // صورة القسم
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: department.image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: department.icon,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.category_outlined,
                                size: 24,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            )
                          : Icon(
                              Icons.category_outlined,
                              size: 24,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // اسم القسم
                  Text(
                    department.name,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.size13,
                      fontFamily: FontConstant.cairo,
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.7)
                          : Colors.grey.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

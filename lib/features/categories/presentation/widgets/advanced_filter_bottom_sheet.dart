import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/categories/domain/entities/department.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/l10n/app_localizations.dart';

/// ويدجت الفلترة المتقدمة مع التسلسل الهرمي للأقسام والفئات
class AdvancedFilterBottomSheet extends StatefulWidget {
  const AdvancedFilterBottomSheet({super.key});

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  Department? selectedDepartment;
  Category? selectedMainCategory;
  SubCategory? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values from ProductsFilterCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromCurrentFilter();
    });
  }

  void _initializeFromCurrentFilter() {
    final filterState = context.read<ProductsFilterCubit>().state;
    final departmentState = context.read<DepartmentCubit>().state;

    if (departmentState is DepartmentLoaded) {
      final departments = departmentState.departments;

      // Find selected department by ID - only if explicitly set
      if (filterState.filter.departmentId != null) {
        final departmentId = int.tryParse(filterState.filter.departmentId!);
        if (departmentId != null) {
          try {
            selectedDepartment = departments.firstWhere(
              (dept) => dept.id == departmentId,
            );
          } catch (e) {
            // Don't select default - keep null if not found
            selectedDepartment = null;
          }
        }
      }

      // Find selected main category - only if explicitly set
      if (filterState.filter.mainCategoryId != null &&
          selectedDepartment != null) {
        try {
          selectedMainCategory = selectedDepartment!.categories.firstWhere(
            (cat) => cat.id == filterState.filter.mainCategoryId,
          );
        } catch (e) {
          // Don't select default - keep null if not found
          selectedMainCategory = null;
        }
      }

      // Find selected sub category - only if explicitly set
      if (filterState.filter.subCategoryId != null &&
          selectedMainCategory != null) {
        try {
          selectedSubCategory = selectedMainCategory!.subCategories.firstWhere(
            (subCat) => subCat.id == filterState.filter.subCategoryId,
          );
        } catch (e) {
          // Don't select default - keep null if not found
          selectedSubCategory = null;
        }
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _applyFilters() {
    context.read<ProductsFilterCubit>().updateFilter(
      departmentId: selectedDepartment?.id,
      mainCategoryId: selectedMainCategory?.id,
      subCategoryId: selectedSubCategory?.id,
    );
    Navigator.pop(context);
  }

  void _clearFilters() {
    final departmentState = context.read<DepartmentCubit>().state;
    int? defaultDepartmentId;

    if (departmentState is DepartmentLoaded &&
        departmentState.departments.isNotEmpty) {
      defaultDepartmentId = departmentState.departments.first.id;
    }

    selectedDepartment = null;
    selectedMainCategory = null;
    selectedSubCategory = null;

    context.read<ProductsFilterCubit>().clearFilters(
      defaultDepartmentId: defaultDepartmentId,
    );

    if (mounted) {
      setState(() {});
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: BlocBuilder<DepartmentCubit, DepartmentState>(
              builder: (context, state) {
                if (state is DepartmentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DepartmentLoaded) {
                  return _buildFilterContent(state.departments);
                } else if (state is DepartmentError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: getRegularStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.advancedFilter,
              style: getBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
                color: AppColors.black,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(List<Department> departments) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department Selection
          _buildSectionTitle(AppLocalizations.of(context)!.selectDepartment),
          const SizedBox(height: 12),
          _buildDepartmentCards(departments),

          if (selectedDepartment != null) ...[
            const SizedBox(height: 24),
            // Main Category Selection
            _buildSectionTitle(
              AppLocalizations.of(context)!.selectMainCategory,
            ),
            const SizedBox(height: 12),
            _buildCategoryCards(selectedDepartment!.categories),
          ],

          if (selectedMainCategory != null &&
              selectedMainCategory!.subCategories.isNotEmpty) ...[
            const SizedBox(height: 24),
            // Sub Category Selection
            _buildSectionTitle(AppLocalizations.of(context)!.selectSubCategory),
            const SizedBox(height: 12),
            _buildSubCategoryCards(selectedMainCategory!.subCategories),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getSemiBoldStyle(
        fontSize: FontSize.size16,
        fontFamily: FontConstant.cairo,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildDepartmentCards(List<Department> departments) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final department = departments[index];
        final isSelected = selectedDepartment?.id == department.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDepartment = department;
              selectedMainCategory = null;
              selectedSubCategory = null;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: department.image.isNotEmpty
                          ? Image.network(
                              department.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.category_outlined,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                    size: 28,
                                  ),
                            )
                          : Icon(
                              Icons.category_outlined,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[600],
                              size: 28,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    department.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.size13,
                      fontFamily: FontConstant.cairo,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${department.countOfProduct} ${AppLocalizations.of(context)!.productsCount}',
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCards(List<Category> categories) {
    return Column(
      children: categories.map((category) {
        final isSelected = selectedMainCategory?.id == category.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMainCategory = category;
              selectedSubCategory = null;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.08),
                  blurRadius: isSelected ? 6 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: category.image.isNotEmpty
                        ? Image.network(
                            category.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.folder_outlined,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[600],
                              size: 24,
                            ),
                          )
                        : Icon(
                            Icons.folder_outlined,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[600],
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubCategoryCards(List<SubCategory> subCategories) {
    return Column(
      children: subCategories.map((subCategory) {
        final isSelected = selectedSubCategory?.id == subCategory.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSubCategory = subCategory;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.08),
                  blurRadius: isSelected ? 6 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(22.5),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.5),
                    child: subCategory.image.isNotEmpty
                        ? Image.network(
                            subCategory.image,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.label_outlined,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[600],
                              size: 22,
                            ),
                          )
                        : Icon(
                            Icons.label_outlined,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[600],
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subCategory.name,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.clearFilters,
                style: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[700]!,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                AppLocalizations.of(context)!.applyFilters,
                style: getSemiBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

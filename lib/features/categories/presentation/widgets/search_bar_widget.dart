import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
import 'package:test/features/categories/presentation/widgets/advanced_filter_bottom_sheet.dart';
import 'package:test/l10n/app_localizations.dart';

/// ويدجت شريط البحث المخصص مع نظام الفلترة المتقدم
class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final bool showFilterBadge;

  const SearchBarWidget({
    super.key,
    this.onSearchChanged,
    this.showFilterBadge = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(_searchController.text);
    }
    context.read<ProductsFilterCubit>().updateKeyword(_searchController.text);
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<ProductsFilterCubit>(),
          ),
          BlocProvider.value(
            value: context.read<DepartmentCubit>(),
          ),
        ],
        child: const AdvancedFilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimations.slideFromRight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchProducts,
                    hintStyle: getRegularStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppAssets.searchIcon,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  AppAssets.icon_filter,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => _showFilterBottomSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

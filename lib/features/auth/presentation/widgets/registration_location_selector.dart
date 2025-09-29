import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/auth/presentation/cubit/location_cubit.dart';
import 'package:test/features/auth/presentation/cubit/location_state.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';
import 'package:provider/provider.dart';
import 'package:test/l10n/app_localizations.dart';

class RegistrationLocationSelector extends StatefulWidget {
  final City? selectedCity;
  final Region? selectedRegion;
  final Function(City) onCitySelected;
  final Function(Region) onRegionSelected;

  const RegistrationLocationSelector({
    super.key,
    required this.selectedCity,
    required this.selectedRegion,
    required this.onCitySelected,
    required this.onRegionSelected,
  });

  @override
  State<RegistrationLocationSelector> createState() =>
      _RegistrationLocationSelectorState();
}

class _RegistrationLocationSelectorState
    extends State<RegistrationLocationSelector> {
  static const int defaultCountryId = 1; // Egypt as default

  @override
  void initState() {
    super.initState();
    // Auto-load cities for default country (Egypt)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationCubit>().getCities(defaultCountryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Column(
          children: [
            // City Selection
            _buildFieldWithLabel(
              label: AppLocalizations.of(context)!.city,
              child: _buildCitySelector(context, state, size),
            ),
            const SizedBox(height: 20),

            // Region Selection (only show if city is selected)
            if (widget.selectedCity != null) ...[
              _buildFieldWithLabel(
                label: AppLocalizations.of(context)!.region,
                child: _buildRegionSelector(context, state, size),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCitySelector(
    BuildContext context,
    LocationState state,
    Size size,
  ) {
    if (state is LocationCitiesLoading) {
      return _buildLoadingState(context, 'جاري تحميل المدن...');
    }

    if (state is LocationCitiesLoaded ||
        state is LocationRegionsLoading ||
        state is LocationRegionsLoaded) {
      List<City> cities = [];
      if (state is LocationCitiesLoaded) {
        cities = state.cities;
      } else if (state is LocationRegionsLoading) {
        cities = state.cities;
      } else if (state is LocationRegionsLoaded) {
        cities = state.cities;
      }

      if (cities.isEmpty) {
        return _buildEmptyState(context, 'لا توجد مدن متاحة');
      }

      return _buildCityGrid(context, cities, size);
    }

    if (state is LocationError) {
      return _buildErrorState(context, state.message);
    }

    return _buildLoadingState(context, 'جاري تحميل المدن...');
  }

  Widget _buildRegionSelector(
    BuildContext context,
    LocationState state,
    Size size,
  ) {
    if (state is LocationRegionsLoading) {
      return _buildLoadingState(context, 'جاري تحميل المناطق...');
    }

    if (state is LocationRegionsLoaded) {
      if (state.regions.isEmpty) {
        return _buildEmptyState(context, 'لا توجد مناطق متاحة');
      }

      return _buildRegionGrid(context, state.regions, size);
    }

    return _buildEmptyState(context, 'اختر المدينة أولاً');
  }

  Widget _buildCityGrid(BuildContext context, List<City> cities, Size size) {
    return SizedBox(
      height: 120,

      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final isSelected = widget.selectedCity?.id == city.id;

          return GestureDetector(
            onTap: () {
              widget.onCitySelected(city);
              context.read<LocationCubit>().getRegions(city.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Container(
                width: 100,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2.5 : 1,
                  ),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.08),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // City Image
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: city.image != null
                              ? CachedNetworkImage(
                                  imageUrl: city.image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: Icon(
                                      Icons.location_city,
                                      color: AppColors.primary,
                                      size: 24.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        child: Icon(
                                          Icons.location_city,
                                          color: AppColors.primary,
                                          size: 24.0,
                                        ),
                                      ),
                                )
                              : Container(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Icon(
                                    Icons.location_city,
                                    color: AppColors.primary,
                                    size: 24.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // City Name
                      Consumer<LanguageService>(
                        builder: (context, languageService, child) {
                          return Text(
                            city.getLocalizedTitle(languageService.isArabic),
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size11,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),

                      // Selection Indicator
                      if (isSelected) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegionGrid(
    BuildContext context,
    List<Region> regions,
    Size size,
  ) {
    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.3),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.width > 600 ? 4 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5,
        ),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];
          final isSelected = widget.selectedRegion?.id == region.id;

          return GestureDetector(
            onTap: () => widget.onRegionSelected(region),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Consumer<LanguageService>(
                  builder: (context, languageService, child) {
                    return Text(
                      region.getLocalizedTitle(languageService.isArabic),
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_off, color: Colors.grey[500], size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.red.withValues(alpha: 0.05),
            Colors.red.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: Colors.red, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<LocationCubit>().getCities(defaultCountryId),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(
              'إعادة المحاولة',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithLabel({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

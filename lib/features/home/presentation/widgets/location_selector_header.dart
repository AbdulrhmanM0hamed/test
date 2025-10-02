import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../location/domain/entities/city.dart';

class LocationSelectorHeader extends StatelessWidget {
  const LocationSelectorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        return GestureDetector(
          onTap: () => _showLocationSelector(context, locationService),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Location icon or city image
                _buildLocationIcon(locationService.selectedCity),
                const SizedBox(width: 4),
                // Location text
                Flexible(
                  child: Consumer<LocationService>(
                    builder: (context, locationService, child) {
                      return Text(
                        _getLocationText(context, locationService),
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 2),
                // Dropdown arrow
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLocationText(
    BuildContext context,
    LocationService locationService,
  ) {
    // Get current locale directly from context as fallback
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Debug logging
    //print('🌍 LocationSelector - Current locale: ${Localizations.localeOf(context).languageCode}',);
    //print('📍 LocationSelector - Using isArabic: $isArabic');

    if (locationService.hasCompleteLocation) {
      // Always use context-based locale, never fallback to service
      //print('🔍 Debug - selectedRegion: ${locationService.selectedRegion}');
      //print('🔍 Debug - selectedCity: ${locationService.selectedCity}');
      //print('🔍 Debug - regions.length: ${locationService.regions.length}');
      //print('🔍 Debug - cities.length: ${locationService.cities.length}');
      
      final region = locationService.selectedRegion?.getLocalizedTitle(isArabic) ??
          (locationService.regions.isNotEmpty
              ? locationService.regions.first.getLocalizedTitle(isArabic)
              : null);
      final city = locationService.selectedCity?.getLocalizedTitle(isArabic) ??
          (locationService.cities.isNotEmpty
              ? locationService.cities.first.getLocalizedTitle(isArabic)
              : null);

      //print('🔍 Debug - region result: $region (isArabic: $isArabic)');
      //print('🔍 Debug - city result: $city (isArabic: $isArabic)');
      
      if (locationService.selectedRegion != null) {
        //print('🔍 Debug - selectedRegion.titleEn: ${locationService.selectedRegion!.titleEn}');
        //print('🔍 Debug - selectedRegion.titleAr: ${locationService.selectedRegion!.titleAr}');
      }
      if (locationService.selectedCity != null) {
        //print('🔍 Debug - selectedCity.titleEn: ${locationService.selectedCity!.titleEn}');
        //print('🔍 Debug - selectedCity.titleAr: ${locationService.selectedCity!.titleAr}');
      }

      final finalText = '${region ?? (isArabic ? 'المنطقة' : 'Region')}، ${city ?? (isArabic ? 'المدينة' : 'City')}';
      //print('🏙️ LocationSelector - Final text: $finalText');
      return finalText;
    } else if (locationService.hasSelectedCity) {
      final cityText = locationService.selectedCity != null
          ? locationService.selectedCity!.getLocalizedTitle(isArabic)
          : (locationService.cities.isNotEmpty
                ? locationService.cities.first.getLocalizedTitle(isArabic)
                : null);
      //print('🏙️ LocationSelector - City only: $cityText');
      return cityText ?? (isArabic ? 'اختر المدينة' : 'Select City');
    } else {
      // Show first available city and region from API
      final cityTitle = locationService.selectedCity?.getLocalizedTitle(isArabic) ?? 
                       (locationService.cities.isNotEmpty 
                           ? locationService.cities.first.getLocalizedTitle(isArabic)
                           : null);
      final regionTitle = locationService.selectedRegion?.getLocalizedTitle(isArabic) ?? 
                         (locationService.regions.isNotEmpty 
                             ? locationService.regions.first.getLocalizedTitle(isArabic)
                             : null);

      if (cityTitle != null && regionTitle != null) {
        //print('🏙️ LocationSelector - API fallback: $regionTitle، $cityTitle');
        return '$regionTitle، $cityTitle';
      } else if (cityTitle != null) {
        //print('🏙️ LocationSelector - API city only: $cityTitle');
        return cityTitle;
      } else {
        final fallbackText =
            AppLocalizations.of(context)?.selectLocation ??
            (isArabic ? 'اختر الموقع' : 'Select Location');
        //print('🏙️ LocationSelector - Fallback: $fallbackText');
        return fallbackText;
      }
    }
  }

  Widget _buildLocationIcon(City? city) {
    if (city?.image != null && city!.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: city.image!,
          width: 25,
          height: 20,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 18,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const SizedBox(
              width: 8,
              height: 8,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ),
          errorWidget: (context, url, error) => _buildDefaultIcon(),
        ),
      );
    }
    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: 18,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Icon(
        Icons.location_on,
        size: 10,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  void _showLocationSelector(
    BuildContext context,
    LocationService locationService,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _LocationSelectorBottomSheet(locationService: locationService),
    );
  }
}

class _LocationSelectorBottomSheet extends StatefulWidget {
  final LocationService locationService;

  const _LocationSelectorBottomSheet({required this.locationService});

  @override
  State<_LocationSelectorBottomSheet> createState() =>
      _LocationSelectorBottomSheetState();
}

class _LocationSelectorBottomSheetState
    extends State<_LocationSelectorBottomSheet> {
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.locationService.selectedCity;

    if (widget.locationService.cities.isEmpty &&
        !widget.locationService.isLoadingCities) {
      widget.locationService.loadCities();
    }

    // Load regions if we have a selected city
    if (_selectedCity != null) {
      widget.locationService.loadRegions(_selectedCity!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(),

          // Content
          Expanded(
            child: Consumer<LocationService>(
              builder: (context, locationService, child) {
                return Column(
                  children: [
                    // Cities Horizontal ListView
                    _buildCitiesHorizontalList(locationService),

                    const SizedBox(height: 20),

                    // Regions Section
                    Expanded(child: _buildRegionsSection(locationService)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.location_on, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.selectLocation,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: AppColors.black,
              ),
            ),
          ),
          if (widget.locationService.hasCompleteLocation)
            TextButton(
              onPressed: () {
                widget.locationService.clearSelectedLocation();
                setState(() {
                  _selectedCity = null;
                });
              },
              child: Text(
                AppLocalizations.of(context)!.clear,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCitiesHorizontalList(LocationService locationService) {
    if (locationService.isLoadingCities) {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CustomProgressIndicator(), const SizedBox(height: 8)],
          ),
        ),
      );
    }

    if (locationService.error != null) {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.errorLoadingCities,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (locationService.cities.isEmpty) {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noCitiesAvailable,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.selectCity,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: locationService.cities.length,
            itemBuilder: (context, index) {
              final city = locationService.cities[index];
              final isSelected = _selectedCity?.id == city.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCity = city;
                  });
                  widget.locationService.selectCity(city);
                  widget.locationService.loadRegions(city.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.only(
                      right: index == locationService.cities.length - 1
                          ? 0
                          : 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
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
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // City Image
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
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
                                          size: 32,
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
                                              size: 32,
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
                                        size: 32,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // City Name
                          Builder(
                            builder: (context) {
                              final isArabic =
                                  Localizations.localeOf(
                                    context,
                                  ).languageCode ==
                                  'ar';
                              return Text(
                                city.getLocalizedTitle(isArabic),
                                style: getMediumStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size12,
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
        ),
      ],
    );
  }

  Widget _buildRegionsSection(LocationService locationService) {
    if (_selectedCity == null) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_searching, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.selectCityFirst,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.selectCityFirst,
              style: getRegularStyle(
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

    if (locationService.isLoadingRegions) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomProgressIndicator(), const SizedBox(height: 16)],
        ),
      );
    }

    if (locationService.error != null) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingRegions,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (_selectedCity != null) {
                  widget.locationService.loadRegions(_selectedCity!.id);
                }
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                AppLocalizations.of(context)!.retry,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (locationService.regions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noRegionsAvailable,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.selectRegion,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
            ),
            itemCount: locationService.regions.length,
            itemBuilder: (context, index) {
              final region = locationService.regions[index];
              final isSelected =
                  locationService.selectedRegion?.id == region.id;

              return GestureDetector(
                onTap: () {
                  locationService.selectRegion(region);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                    child: Builder(
                      builder: (context) {
                        final isArabic =
                            Localizations.localeOf(context).languageCode ==
                            'ar';
                        return Text(
                          region.getLocalizedTitle(isArabic),
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
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/language_service.dart';
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
                  child: Consumer<LanguageService>(
                    builder: (context, languageService, child) {
                      return Text(
                        _getLocationText(
                          context,
                          locationService,
                          languageService,
                        ),
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
    LanguageService languageService,
  ) {
    if (locationService.hasCompleteLocation) {
      final region = locationService.selectedRegionLocalizedTitle;
      final city = locationService.selectedCityLocalizedTitle;
      return '$region، $city';
    } else if (locationService.hasSelectedCity) {
      return locationService.selectedCityLocalizedTitle!;
    } else {
      return AppLocalizations.of(context)!.selectLocation;
    }
  }

  Widget _buildLocationIcon(City? city) {
    if (city?.image != null && city!.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: city.image!,
          width: 18,
          height: 14,
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
  bool _showingRegions = false;

  @override
  void initState() {
    super.initState();
    if (widget.locationService.cities.isEmpty &&
        !widget.locationService.isLoadingCities) {
      widget.locationService.loadCities();
    }
    // If we have a selected city but no regions, show regions directly
    if (widget.locationService.hasSelectedCity &&
        widget.locationService.regions.isEmpty) {
      _showingRegions = true;
      widget.locationService.loadRegions(
        widget.locationService.selectedCity!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                if (_showingRegions) {
                  return _buildRegionsContent(locationService);
                } else {
                  return _buildCitiesContent(locationService);
                }
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
          if (_showingRegions)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showingRegions = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _showingRegions
                  ? AppLocalizations.of(context)!.selectRegion
                  : AppLocalizations.of(context)!.selectCity,
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
                Navigator.pop(context);
              },
              child: Text(
                'مسح',
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

  Widget _buildCitiesContent(LocationService locationService) {
    if (locationService.isLoadingCities) {
      return _buildLoadingState('جاري تحميل المدن...');
    }

    if (locationService.error != null) {
      return _buildErrorState(locationService);
    }

    if (locationService.cities.isEmpty) {
      return _buildEmptyState('لا توجد مدن متاحة', Icons.location_city);
    }

    return _buildCitiesList(locationService);
  }

  Widget _buildRegionsContent(LocationService locationService) {
    if (locationService.isLoadingRegions) {
      return _buildLoadingState('جاري تحميل المناطق...');
    }

    if (locationService.error != null) {
      return _buildErrorState(locationService);
    }

    if (locationService.regions.isEmpty) {
      return _buildEmptyState('لا توجد مناطق متاحة', Icons.map);
    }

    return _buildRegionsList(locationService);
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(LocationService locationService) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.wifi_off_rounded, color: Colors.red, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ في التحميل',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locationService.error ?? 'حدث خطأ غير متوقع',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => locationService.retry(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
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

  Widget _buildCitiesList(LocationService locationService) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: locationService.cities.length,
      itemBuilder: (context, index) {
        final city = locationService.cities[index];
        final isSelected = locationService.selectedCity?.id == city.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            elevation: isSelected ? 8 : 2,
            shadowColor: isSelected
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () async {
                await locationService.selectCity(city);
                setState(() {
                  _showingRegions = true;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                ),
                child: Row(
                  children: [
                    // City Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: _buildProfessionalCityImage(city, isSelected),
                    ),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // City Name
                            Consumer<LanguageService>(
                              builder: (context, languageService, child) {
                                return Text(
                                  city.getLocalizedTitle(
                                    languageService.isArabic,
                                  ),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size18,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),

                            const SizedBox(height: 4),

                            // Subtitle
                            Text(
                              'اختر هذه المدينة',
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size12,
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.8)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Selection Indicator & Arrow
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[600],
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegionsList(LocationService locationService) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: locationService.regions.length,
      itemBuilder: (context, index) {
        final region = locationService.regions[index];
        final isSelected = locationService.selectedRegion?.id == region.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: ListTile(
            onTap: () {
              locationService.selectRegion(region);
              Navigator.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.map,
                size: 16,
                color: isSelected ? AppColors.primary : Colors.grey[600],
              ),
            ),
            title: Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return Text(
                  region.getLocalizedTitle(languageService.isArabic),
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                );
              },
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey[400],
                    size: 24,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildProfessionalCityImage(City city, bool isSelected) {
    if (city.image != null && city.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: city.image!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[200]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  _buildDefaultCityImage(isSelected),
            ),

            // Gradient overlay for better text readability
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Selection overlay
            if (isSelected)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
          ],
        ),
      );
    }

    return _buildDefaultCityImage(isSelected);
  }

  Widget _buildDefaultCityImage(bool isSelected) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primary.withValues(alpha: 0.6),
                ]
              : [Colors.grey[400]!, Colors.grey[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city_rounded,
            size: 24,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (isSelected ? Colors.white : Colors.grey[600])?.withValues(
                alpha: 0.2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'صورة',
              style: TextStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 8,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

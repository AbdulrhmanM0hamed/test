import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/auth/presentation/cubit/location_cubit.dart';
import 'package:test/features/auth/presentation/cubit/location_state.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/region.dart';
import 'package:provider/provider.dart';

class RegistrationLocationSelector extends StatelessWidget {
  final Country? selectedCountry;
  final City? selectedCity;
  final Region? selectedRegion;
  final Function(Country) onCountrySelected;
  final Function(City) onCitySelected;
  final Function(Region) onRegionSelected;

  const RegistrationLocationSelector({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    required this.selectedRegion,
    required this.onCountrySelected,
    required this.onCitySelected,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Column(
          children: [
            // Country Selection
            _buildFieldWithLabel(
              label: 'الدولة',
              child: _buildCountrySelector(context),
            ),
            const SizedBox(height: 16),

            // City Selection (only show if country is selected)
            if (selectedCountry != null) ...[
              _buildFieldWithLabel(
                label: 'المدينة',
                child: _buildCityDropdown(context, state),
              ),
              const SizedBox(height: 16),
            ],

            // Region Selection (only show if city is selected)
            if (selectedCity != null) ...[
              _buildFieldWithLabel(
                label: 'المنطقة',
                child: _buildRegionDropdown(context, state),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCountrySelector(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationCountriesLoading) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'جاري تحميل الدول...',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is LocationCountriesLoaded) {
          return _buildCountryGrid(context, state.countries);
        }

        if (state is LocationCitiesLoading) {
          return Column(
            children: [
              _buildCountryGrid(context, state.countries),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'جاري تحميل المدن...',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        if (state is LocationCitiesLoaded) {
          return _buildCountryGrid(context, state.countries);
        }

        if (state is LocationRegionsLoading) {
          return _buildCountryGrid(context, state.countries);
        }

        if (state is LocationRegionsLoaded) {
          return _buildCountryGrid(context, state.countries);
        }

        if (state is LocationError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.05),
                  Colors.red.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.wifi_off_rounded, color: Colors.red, size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  'خطأ في تحميل الدول',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<LocationCubit>().getCountries(),
                  icon: Icon(Icons.refresh, size: 18),
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

        // Initial state - show loading button
        return GestureDetector(
          onTap: () => context.read<LocationCubit>().getCountries(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.public, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'اختر دولتك',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط لتحميل الدول المتاحة',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryGrid(BuildContext context, List<Country> countries) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        final isSelected = selectedCountry?.id == country.id;
        
        return GestureDetector(
          onTap: () {
            onCountrySelected(country);
            context.read<LocationCubit>().getCities(country.id);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              gradient: isSelected 
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    country.image ?? '',
                    width: 24,
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.flag,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 24,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Consumer<LanguageService>(
                    builder: (context, languageService, child) {
                      return Text(
                        country.getLocalizedTitle(languageService.isArabic),
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCityDropdown(BuildContext context, LocationState state) {
    if (state is LocationCitiesLoaded || state is LocationRegionsLoading || state is LocationRegionsLoaded) {
      List<City> cities = [];
      if (state is LocationCitiesLoaded) {
        cities = state.cities;
      } else if (state is LocationRegionsLoading) {
        cities = state.cities;
      } else if (state is LocationRegionsLoaded) {
        cities = state.cities;
      }

      if (cities.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            color: Colors.grey[100],
          ),
          child: Text(
            'اختر الدولة أولاً',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }
      return DropdownButtonFormField<City>(
        initialValue: selectedCity,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        hint: Text(
          'اختر المدينة',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textSecondary,
          ),
        ),
        items: cities.map((city) {
          return DropdownMenuItem<City>(
            value: city,
            child: Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return Text(
                  city.getLocalizedTitle(languageService.isArabic),
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          );
        }).toList(),
        onChanged: (City? city) {
          if (city != null) {
            onCitySelected(city);
            context.read<LocationCubit>().getRegions(city.id);
          }
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        color: Colors.grey[100],
      ),
      child: Text(
        'اختر الدولة أولاً',
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildRegionDropdown(BuildContext context, LocationState state) {
    if (state is LocationRegionsLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'جاري تحميل المناطق...',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (state is LocationRegionsLoaded) {
      return DropdownButtonFormField<Region>(
        initialValue: selectedRegion,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        hint: Text(
          'اختر المنطقة',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textSecondary,
          ),
        ),
        items: state.regions.map((region) {
          return DropdownMenuItem<Region>(
            value: region,
            child: Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return Text(
                  region.getLocalizedTitle(languageService.isArabic),
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          );
        }).toList(),
        onChanged: (Region? region) {
          if (region != null) {
            onRegionSelected(region);
          }
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        color: Colors.grey[100],
      ),
      child: Text(
        'اختر المدينة أولاً',
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildFieldWithLabel({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

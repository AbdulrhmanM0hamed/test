import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/services/country_service.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../profile/domain/entities/country.dart';

class CountrySelectorHeader extends StatelessWidget {
  const CountrySelectorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryService>(
      builder: (context, countryService, child) {
        return GestureDetector(
          onTap: () => _showCountrySelector(context, countryService),
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
                // Country flag or default icon
                _buildCountryFlag(countryService.selectedCountry),
                const SizedBox(width: 4),
                // Country name or default text - wrapped in Flexible to prevent overflow
                Flexible(
                  child: Text(
                    countryService.selectedCountry?.titleAr ?? 'اختر الدولة',
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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

  Widget _buildCountryFlag(Country? country) {
    if (country?.image != null && country!.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: country.image!,
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
          errorWidget: (context, url, error) => _buildDefaultFlag(),
        ),
      );
    }
    return _buildDefaultFlag();
  }

  Widget _buildDefaultFlag() {
    return Container(
      width: 18,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Icon(
        Icons.public,
        size: 10,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  void _showCountrySelector(BuildContext context, CountryService countryService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CountrySelectorBottomSheet(countryService: countryService),
    );
  }
}

class _CountrySelectorBottomSheet extends StatefulWidget {
  final CountryService countryService;

  const _CountrySelectorBottomSheet({required this.countryService});

  @override
  State<_CountrySelectorBottomSheet> createState() => _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState extends State<_CountrySelectorBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Load countries if not already loaded
    if (widget.countryService.countries.isEmpty && !widget.countryService.isLoading) {
      widget.countryService.loadCountries();
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.public,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اختر الدولة',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: AppColors.black,
                    ),
                  ),
                ),
                if (widget.countryService.hasSelectedCountry)
                  TextButton(
                    onPressed: () {
                      widget.countryService.clearSelectedCountry();
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
          ),

          // Content
          Expanded(
            child: Consumer<CountryService>(
              builder: (context, countryService, child) {
                if (countryService.isLoading) {
                  return _buildLoadingState();
                }

                if (countryService.error != null) {
                  return _buildErrorState(countryService);
                }

                if (countryService.countries.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildCountriesList(countryService);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'جاري تحميل الدول...',
            style: TextStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CountryService countryService) {
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
              child: Icon(
                Icons.wifi_off_rounded,
                color: Colors.red,
                size: 32,
              ),
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
              countryService.error ?? 'حدث خطأ غير متوقع',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => countryService.retry(),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public_off,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد دول متاحة',
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

  Widget _buildCountriesList(CountryService countryService) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: countryService.countries.length,
      itemBuilder: (context, index) {
        final country = countryService.countries[index];
        final isSelected = countryService.selectedCountry?.id == country.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          ),
          child: ListTile(
            onTap: () {
              countryService.selectCountry(country);
              Navigator.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _buildCountryFlagLarge(country),
            title: Text(
              country.titleAr,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  )
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

  Widget _buildCountryFlagLarge(Country country) {
    if (country.image != null && country.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: country.image!,
          width: 32,
          height: 24,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 32,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.flag,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.flag,
        size: 16,
        color: Colors.grey[600],
      ),
    );
  }
}

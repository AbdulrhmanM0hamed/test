import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/services/language_service.dart';
import '../../../location/domain/entities/city.dart' as LocationCity;
import '../../domain/entities/address.dart';
import '../cubit/addresses_cubit.dart';

class AddEditAddressView extends StatefulWidget {
  final Address? address;

  const AddEditAddressView({super.key, this.address});

  @override
  State<AddEditAddressView> createState() => _AddEditAddressViewState();
}

class _AddEditAddressViewState extends State<AddEditAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  String _selectedAddressType = 'home';
  bool _isLoading = false;

  final List<String> _addressTypes = ['home', 'work', 'other'];

  @override
  void initState() {
    super.initState();
    _initializeLocationService();
    if (widget.address != null) {
      _initializeWithExistingAddress();
    }
  }

  void _initializeLocationService() {
    final locationService = Provider.of<LocationService>(
      context,
      listen: false,
    );
    if (locationService.cities.isEmpty && !locationService.isLoadingCities) {
      locationService.loadCities();
    }
  }

  void _initializeWithExistingAddress() {
    final address = widget.address!;
    _addressController.text = address.address;
    _selectedAddressType = address.addressType;

    // Set location based on existing address
    final locationService = Provider.of<LocationService>(
      context,
      listen: false,
    );

    // Find matching city and region in LocationService
    if (address.city != null) {
      final matchingCity = locationService.cities.isNotEmpty
          ? locationService.cities.firstWhere(
              (city) => city.id == address.city!.id,
              orElse: () => locationService.cities.first,
            )
          : null;

      if (matchingCity != null) {
        locationService.selectCity(matchingCity).then((_) {
          if (address.region != null) {
            final matchingRegion = locationService.regions.isNotEmpty
                ? locationService.regions.firstWhere(
                    (region) => region.id == address.region!.id,
                    orElse: () => locationService.regions.first,
                  )
                : null;
            if (matchingRegion != null) {
              locationService.selectRegion(matchingRegion);
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.address == null
              ? AppLocalizations.of(context)!.addAddress
              : AppLocalizations.of(context)!.editAddress,
          style: getBoldStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AddressesCubit, AddressesState>(
        listener: (context, state) {
          if (state is AddressesLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is AddressAdded) {
            setState(() {
              _isLoading = false;
            });
            // Use server message if available, fallback to localized message
            final message = state.message != null
                ? state.message!
                : AppLocalizations.of(context)!.addressAddedSuccessfully;
            CustomSnackbar.showSuccess(context: context, message: message);
            Navigator.of(context).pop();
          } else if (state is AddressUpdated) {
            setState(() {
              _isLoading = false;
            });
            // Use server message if available, fallback to localized message
            final message = state.message != null
                ? state.message!
                : AppLocalizations.of(context)!.addressUpdatedSuccessfully;
            CustomSnackbar.showSuccess(context: context, message: message);
            Navigator.of(context).pop();
          } else if (state is AddressesError) {
            setState(() {
              _isLoading = false;
            });
            CustomSnackbar.showError(context: context, message: state.message);
          } else {
            // Handle other states by stopping loading
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: _isLoading
            ? const Center(child: CustomProgressIndicator())
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Type Section
            _buildAddressTypeSection(),

            const SizedBox(height: 24),

            // Location Selection Section
            _buildLocationSection(),

            const SizedBox(height: 24),

            // Address Details Section
            _buildAddressDetailsSection(),

            const SizedBox(height: 32),

            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.addressType,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: _addressTypes.map((type) {
            final isSelected = _selectedAddressType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAddressType = type;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getAddressTypeText(type),
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.location,
              style: getBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
            const SizedBox(height: 12),

            // City Selection
            Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return _buildLocationSelector(
                  label: AppLocalizations.of(context)!.city,
                  value: locationService.selectedCity != null
                      ? locationService.selectedCity!.getLocalizedTitle(
                          languageService.isArabic,
                        )
                      : null,
                  onTap: () => _showCitySelector(locationService),
                  isLoading: locationService.isLoadingCities,
                );
              },
            ),

            const SizedBox(height: 16),

            // Region Selection
            Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return _buildLocationSelector(
                  label: AppLocalizations.of(context)!.region,
                  value: locationService.selectedRegion != null
                      ? locationService.selectedRegion!.getLocalizedTitle(
                          languageService.isArabic,
                        )
                      : null,
                  onTap: locationService.selectedCity != null
                      ? () => _showRegionSelector(locationService)
                      : null,
                  isLoading: locationService.isLoadingRegions,
                  enabled: locationService.selectedCity != null,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationSelector({
    required String label,
    String? value,
    VoidCallback? onTap,
    bool isLoading = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
              color: enabled
                  ? Theme.of(context).cardColor
                  : Colors.grey.withValues(alpha: 0.1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? AppLocalizations.of(context)!.select,
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: value != null
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Colors.grey,
                    ),
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CustomProgressIndicator(),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: enabled
                        ? Colors.grey
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.addressDetails,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.detailedAddress,
            hintText: AppLocalizations.of(context)!.enterDetailedAddress,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterAddress;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        final canSave =
            locationService.hasCompleteLocation &&
            _addressController.text.trim().isNotEmpty;

        return CustomButton(
          text: widget.address == null
              ? AppLocalizations.of(context)!.addAddress
              : AppLocalizations.of(context)!.updateAddress,
          onPressed: canSave ? _saveAddress : null,
          isLoading: _isLoading,
          width: double.infinity,
        );
      },
    );
  }

  void _showCitySelector(LocationService locationService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CitySelector(locationService: locationService),
    );
  }

  void _showRegionSelector(LocationService locationService) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RegionSelector(locationService: locationService),
    );
  }

  void _saveAddress() {
    // Prevent multiple submissions
    if (_isLoading) return;

    final locationService = Provider.of<LocationService>(
      context,
      listen: false,
    );

    if (_formKey.currentState!.validate() &&
        locationService.selectedCity != null &&
        locationService.selectedRegion != null) {
      final address = Address(
        id: widget.address?.id ?? 0,
        address: _addressController.text,
        addressType: _selectedAddressType,
        country: Country(
          id: 1, // Egypt ID
          name: 'Egypt',
        ),
        city: City(
          id: locationService.selectedCity!.id,
          name: locationService.selectedCity!.titleAr,
        ),
        region: Region(
          id: locationService.selectedRegion!.id,
          name: locationService.selectedRegion!.titleAr,
        ),
        shippingCost: 0.0, // Will be calculated by backend
      );

      if (widget.address == null) {
        context.read<AddressesCubit>().addAddress(address);
      } else {
        context.read<AddressesCubit>().updateAddress(
          widget.address!.id!,
          address,
        );
      }
    }
  }

  String _getAddressTypeText(String type) {
    switch (type) {
      case 'home':
        return AppLocalizations.of(context)!.home;
      case 'work':
        return AppLocalizations.of(context)!.work;
      case 'other':
        return AppLocalizations.of(context)!.other;
      default:
        return type;
    }
  }
}

class _CitySelector extends StatelessWidget {
  final LocationService locationService;

  const _CitySelector({required this.locationService});

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
            child: Text(
              AppLocalizations.of(context)!.selectCity,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
          ),

          // Cities List
          Expanded(
            child: Consumer<LocationService>(
              builder: (context, locationService, child) {
                if (locationService.isLoadingCities) {
                  return const Center(child: CustomProgressIndicator());
                }

                if (locationService.cities.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noCitiesAvailable,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: locationService.cities.length,
                  itemBuilder: (context, index) {
                    final city = locationService.cities[index];
                    final isSelected =
                        locationService.selectedCity?.id == city.id;

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
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        AppColors.primary.withValues(
                                          alpha: 0.05,
                                        ),
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
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(2, 0),
                                      ),
                                    ],
                                  ),
                                  child: _buildProfessionalCityImage(
                                    city as LocationCity.City,
                                    isSelected,
                                  ),
                                ),

                                // Content
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // City Name
                                        Flexible(
                                          child: Consumer<LanguageService>(
                                            builder:
                                                (
                                                  context,
                                                  languageService,
                                                  child,
                                                ) {
                                                  return Text(
                                                    city.getLocalizedTitle(
                                                      languageService.isArabic,
                                                    ),
                                                    style: getBoldStyle(
                                                      fontFamily:
                                                          FontConstant.cairo,
                                                      fontSize: FontSize.size16,
                                                      color: isSelected
                                                          ? AppColors.primary
                                                          : AppColors
                                                                .textPrimary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                          ),
                                        ),

                                        const SizedBox(height: 2),

                                        // Subtitle
                                        Flexible(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.selectCity,
                                            style: getRegularStyle(
                                              fontFamily: FontConstant.cairo,
                                              fontSize: FontSize.size12,
                                              color: isSelected
                                                  ? AppColors.primary
                                                        .withValues(alpha: 0.8)
                                                  : AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Selection Indicator
                                if (isSelected)
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildProfessionalCityImage(
    LocationCity.City city,
    bool isSelected,
  ) {
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

  static Widget _buildDefaultCityImage(bool isSelected) {
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
          Text(
            'City',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionSelector extends StatelessWidget {
  final LocationService locationService;

  const _RegionSelector({required this.locationService});

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
            child: Text(
              AppLocalizations.of(context)!.selectRegion,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
          ),

          // Regions List
          Expanded(
            child: Consumer<LocationService>(
              builder: (context, locationService, child) {
                if (locationService.isLoadingRegions) {
                  return const Center(child: CustomProgressIndicator());
                }

                if (locationService.regions.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noRegionsAvailable,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: locationService.regions.length,
                  itemBuilder: (context, index) {
                    final region = locationService.regions[index];
                    final isSelected =
                        locationService.selectedRegion?.id == region.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            locationService.selectRegion(region);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        AppColors.primary.withValues(
                                          alpha: 0.05,
                                        ),
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
                                      : Colors.black.withValues(alpha: 0.08),
                                  blurRadius: isSelected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  // Region Icon
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primary,
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Region Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Region Name
                                        Consumer<LanguageService>(
                                          builder:
                                              (
                                                context,
                                                languageService,
                                                child,
                                              ) {
                                                return Text(
                                                  region.getLocalizedTitle(
                                                    languageService.isArabic,
                                                  ),
                                                  style: getBoldStyle(
                                                    fontFamily:
                                                        FontConstant.cairo,
                                                    fontSize: FontSize.size16,
                                                    color: isSelected
                                                        ? AppColors.primary
                                                        : AppColors.textPrimary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                );
                                              },
                                        ),

                                        const SizedBox(height: 4),

                                        // Subtitle
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.selectRegion,
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.cairo,
                                            fontSize: FontSize.size12,
                                            color: isSelected
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.8,
                                                  )
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection Indicator
                                  if (isSelected)
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/features/location/domain/entities/city.dart';
import 'package:test/features/location/domain/entities/region.dart';
import 'package:test/features/location/data/models/city_model.dart';
import 'package:test/features/location/data/models/region_model.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'data_refresh_service.dart';

class LocationService extends ChangeNotifier {
  static const String _selectedCityKey = 'selected_city_id';
  static const String _selectedCityNameKey = 'selected_city_name';
  static const String _selectedCityImageKey = 'selected_city_image';
  static const String _selectedRegionKey = 'selected_region_id';
  static const String _selectedRegionNameKey = 'selected_region_name';

  City? _selectedCity;
  Region? _selectedRegion;
  List<CityModel> _cities = [];
  List<RegionModel> _regions = [];
  bool _isLoadingCities = false;
  bool _isLoadingRegions = false;
  String? _error;
  final LanguageService _languageService;
  final DioService _dioService;

  City? get selectedCity => _selectedCity;
  Region? get selectedRegion => _selectedRegion;
  List<CityModel> get cities => _cities;
  List<RegionModel> get regions => _regions;
  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingRegions => _isLoadingRegions;
  String? get error => _error;
  bool get hasSelectedCity => _selectedCity != null;
  bool get hasSelectedRegion => _selectedRegion != null;
  bool get hasCompleteLocation =>
      _selectedCity != null && _selectedRegion != null;

  static LocationService? _instance;
  static LocationService get instance {
    if (_instance == null) {
      throw Exception(
        'LocationService not initialized. Call LocationService.init() first.',
      );
    }
    return _instance!;
  }

  static void init(LanguageService languageService, DioService dioService) {
    _instance = LocationService._internal(languageService, dioService);
  }

  LocationService._internal(this._languageService, this._dioService) {
    //print('🏗️ LocationService - Initializing with LanguageService');
    //print('🌍 LocationService - Initial LanguageService isArabic: ${_languageService.isArabic}');
    //print('🌍 LocationService - Initial LanguageService currentLocale: ${_languageService.currentLocale}');
    _languageService.addListener(_onLanguageChanged);
    _loadSavedLocation();
  }

  void _onLanguageChanged() {
    //print('🔄 LocationService - Language changed notification received');
    //print('🌍 LocationService - New LanguageService isArabic: ${_languageService.isArabic}');
    //print('🌍 LocationService - New LanguageService currentLocale: ${_languageService.currentLocale}');

    // Force refresh all cached titles
    //print('🔄 LocationService - Forcing UI refresh due to language change');
    notifyListeners();

    // Additional notification after a small delay to ensure UI updates
    Future.delayed(const Duration(milliseconds: 100), () {
      //print('🔄 LocationService - Secondary notification for UI refresh');
      notifyListeners();
    });
  }

  String getLocalizedCityTitle(City city) {
    return city.getLocalizedTitle(_languageService.isArabic);
  }

  String getLocalizedRegionTitle(Region region) {
    return region.getLocalizedTitle(_languageService.isArabic);
  }

  /// Get city title with context-based fallback
  String getCityTitleWithFallback(City city, bool contextIsArabic) {
    //print('🏙️ LocationService - getCityTitleWithFallback: contextIsArabic=$contextIsArabic, serviceIsArabic=${_languageService.isArabic}');
    return city.getLocalizedTitle(contextIsArabic);
  }

  /// Get region title with context-based fallback
  String getRegionTitleWithFallback(Region region, bool contextIsArabic) {
    //print('🏛️ LocationService - getRegionTitleWithFallback: contextIsArabic=$contextIsArabic, serviceIsArabic=${_languageService.isArabic}');
    return region.getLocalizedTitle(contextIsArabic);
  }

  /// Force refresh location titles (useful after language change)
  void forceRefresh() {
    //print('🔄 LocationService - Force refresh requested');
    notifyListeners();
  }

  /// Clear cached location data and reload from API
  Future<void> clearCacheAndReload() async {
    //print('🗑️ LocationService - Clearing cache and reloading...');
    await _clearSavedLocation();
    _selectedCity = null;
    _selectedRegion = null;
    _cities.clear();
    _regions.clear();

    // Reload data from API
    await loadCities();
    notifyListeners();
  }

  String? get selectedCityLocalizedTitle {
    //print('🏙️ LocationService - LanguageService isArabic: ${_languageService.isArabic}');
    //print('🏙️ LocationService - LanguageService currentLocale: ${_languageService.currentLocale}');

    if (_selectedCity != null) {
      final title = _selectedCity!.getLocalizedTitle(_languageService.isArabic);
      //print('🏙️ LocationService - Selected city title: $title (isArabic: ${_languageService.isArabic})');
      return title;
    }
    // Use first city from API if available
    if (_cities.isNotEmpty) {
      final title = _cities.first.getLocalizedTitle(_languageService.isArabic);
      //print('🏙️ LocationService - First city title: $title (isArabic: ${_languageService.isArabic})');
      return title;
    }
    return null;
  }

  String? get selectedRegionLocalizedTitle {
    if (_selectedRegion != null) {
      final title = _selectedRegion!.getLocalizedTitle(
        _languageService.isArabic,
      );
      //print('🏛️ LocationService - Selected region title: $title (isArabic: ${_languageService.isArabic})');
      return title;
    }
    // Use first region from API if available
    if (_regions.isNotEmpty) {
      final title = _regions.first.getLocalizedTitle(_languageService.isArabic);
      //print('🏛️ LocationService - First region title: $title (isArabic: ${_languageService.isArabic})');
      return title;
    }
    return null;
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Future<void> initialize() async {
    await _loadSavedLocation();

    // Always load cities if empty
    if (_cities.isEmpty) {
      await loadCities();
    }

    // Load regions if we have a selected city but no regions
    if (_selectedCity != null && _regions.isEmpty) {
      await loadRegions(_selectedCity!.id);
    }

    // If no saved location, auto-select first city and region
    if (_selectedCity == null && _cities.isNotEmpty) {
      _selectedCity = _cities.first;
      await loadRegions(_cities.first.id);
    }
  }

  Future<void> loadCities() async {
    try {
      _isLoadingCities = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      // Use country ID 1 as default (Egypt)
      final response = await _dioService.getWithResponse<List<CityModel>>(
        ApiEndpoints.citiesByCountry(1),
        dataParser: (data) {
          if (data is List) {
            return data.map((city) => CityModel.fromJson(city)).toList();
          }
          return <CityModel>[];
        },
      );

      if (response.success && response.data != null) {
        _cities = response.data!;
        _isLoadingCities = false;

        // Update selected city with fresh data from API if it exists
        if (_selectedCity != null) {
          final updatedCity = _cities.firstWhere(
            (city) => city.id == _selectedCity!.id,
            orElse: () => _cities.first,
          );
          if (updatedCity.titleEn != _selectedCity!.titleEn ||
              updatedCity.titleAr != _selectedCity!.titleAr) {
            //print('🔄 Updating selected city with fresh API data');
            //print('   Old: ${_selectedCity!.titleEn} / ${_selectedCity!.titleAr}');
            //print('   New: ${updatedCity.titleEn} / ${updatedCity.titleAr}');
            _selectedCity = updatedCity;
            await _saveSelectedLocation();
          }
        }

        // Auto-select first city if no city is selected
        if (_selectedCity == null && _cities.isNotEmpty) {
          _selectedCity = _cities.first;
          await _saveSelectedLocation();
          // Load regions for the first city
          loadRegions(_cities.first.id);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        _error = response.message;
        _isLoadingCities = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل المدن: $e';
      _isLoadingCities = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> loadRegions(int cityId) async {
    try {
      _isLoadingRegions = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final response = await _dioService.getWithResponse<List<RegionModel>>(
        ApiEndpoints.regions(cityId),
        dataParser: (data) {
          if (data is List) {
            return data.map((region) => RegionModel.fromJson(region)).toList();
          }
          return <RegionModel>[];
        },
      );

      if (response.success && response.data != null) {
        _regions = response.data!;
        _isLoadingRegions = false;

        // Update selected region with fresh data from API if it exists
        if (_selectedRegion != null) {
          final updatedRegion = _regions.firstWhere(
            (region) => region.id == _selectedRegion!.id,
            orElse: () => _regions.first,
          );
          if (updatedRegion.titleEn != _selectedRegion!.titleEn ||
              updatedRegion.titleAr != _selectedRegion!.titleAr) {
            //print('🔄 Updating selected region with fresh API data');
            //print('   Old: ${_selectedRegion!.titleEn} / ${_selectedRegion!.titleAr}');
            //print('   New: ${updatedRegion.titleEn} / ${updatedRegion.titleAr}');
            _selectedRegion = updatedRegion;
            await _saveSelectedLocation();
          }
        }

        // Auto-select first region if no region is selected
        if (_selectedRegion == null && _regions.isNotEmpty) {
          _selectedRegion = _regions.first;
          await _saveSelectedLocation();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        _error = response.message;
        _isLoadingRegions = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل المناطق: $e';
      _isLoadingRegions = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> selectCity(City city) async {
    if (_selectedCity?.id == city.id) return;

    _selectedCity = city;
    _selectedRegion = null; // Clear region when city changes
    _regions = []; // Clear regions list

    await _saveSelectedLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Load regions for the selected city
    await loadRegions(city.id);
  }

  Future<void> selectRegion(Region region) async {
    if (_selectedRegion?.id == region.id) return;

    _selectedRegion = region;
    await _saveSelectedLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Trigger app-wide refresh
    final dataRefreshService = GetIt.instance<DataRefreshService>();
    dataRefreshService.refreshAll();
  }

  Future<void> clearSelectedLocation() async {
    _selectedCity = null;
    _selectedRegion = null;
    _regions = [];
    await _clearSavedLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final dataRefreshService = GetIt.instance<DataRefreshService>();
    dataRefreshService.refreshAll();
  }

  int? getSelectedRegionId() {
    return _selectedRegion?.id;
  }

  String getRegionQueryParam() {
    final regionId = getSelectedRegionId();
    return regionId != null ? '?region_id=$regionId' : '';
  }

  Future<void> _loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load saved city with both languages
      final cityId = prefs.getInt(_selectedCityKey);
      final cityTitleEn = prefs.getString('${_selectedCityNameKey}_en');
      final cityTitleAr = prefs.getString('${_selectedCityNameKey}_ar');
      final cityImage = prefs.getString(_selectedCityImageKey);

      if (cityId != null && cityTitleEn != null && cityTitleAr != null) {
        _selectedCity = CityModel(
          id: cityId,
          titleEn: cityTitleEn,
          titleAr: cityTitleAr,
          countryId: 1, // Default Egypt
          image: cityImage,
        );
        //print('📂 Loaded saved city: ${_selectedCity!.titleEn} / ${_selectedCity!.titleAr}');
      } else if (cityId != null) {
        // Fallback for old format (single language)
        final cityName = prefs.getString(_selectedCityNameKey);
        if (cityName != null) {
          _selectedCity = CityModel(
            id: cityId,
            titleEn: cityName, // Will be corrected when API loads
            titleAr: cityName,
            countryId: 1,
            image: cityImage,
          );
          //print('📂 Loaded saved city (old format): $cityName');
        }
      }

      // Load saved region with both languages
      final regionId = prefs.getInt(_selectedRegionKey);
      final regionTitleEn = prefs.getString('${_selectedRegionNameKey}_en');
      final regionTitleAr = prefs.getString('${_selectedRegionNameKey}_ar');

      if (regionId != null &&
          regionTitleEn != null &&
          regionTitleAr != null &&
          _selectedCity != null) {
        _selectedRegion = RegionModel(
          id: regionId,
          titleEn: regionTitleEn,
          titleAr: regionTitleAr,
          cityId: _selectedCity!.id,
        );
        //print('📂 Loaded saved region: ${_selectedRegion!.titleEn} / ${_selectedRegion!.titleAr}');
      } else if (regionId != null && _selectedCity != null) {
        // Fallback for old format (single language)
        final regionName = prefs.getString(_selectedRegionNameKey);
        if (regionName != null) {
          _selectedRegion = RegionModel(
            id: regionId,
            titleEn: regionName, // Will be corrected when API loads
            titleAr: regionName,
            cityId: _selectedCity!.id,
          );
          //print('📂 Loaded saved region (old format): $regionName');
        }
      }
    } catch (e) {
      //print('❌ Error loading saved location: $e');
    }
  }

  Future<void> _saveSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_selectedCity != null) {
        await prefs.setInt(_selectedCityKey, _selectedCity!.id);
        // Save both English and Arabic titles
        await prefs.setString(
          '${_selectedCityNameKey}_en',
          _selectedCity!.titleEn,
        );
        await prefs.setString(
          '${_selectedCityNameKey}_ar',
          _selectedCity!.titleAr,
        );
        if (_selectedCity!.image != null) {
          await prefs.setString(_selectedCityImageKey, _selectedCity!.image!);
        }
      }

      if (_selectedRegion != null) {
        await prefs.setInt(_selectedRegionKey, _selectedRegion!.id);
        // Save both English and Arabic titles
        await prefs.setString(
          '${_selectedRegionNameKey}_en',
          _selectedRegion!.titleEn,
        );
        await prefs.setString(
          '${_selectedRegionNameKey}_ar',
          _selectedRegion!.titleAr,
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _clearSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedCityKey);
      await prefs.remove(_selectedCityNameKey);
      await prefs.remove('${_selectedCityNameKey}_en');
      await prefs.remove('${_selectedCityNameKey}_ar');
      await prefs.remove(_selectedCityImageKey);
      await prefs.remove(_selectedRegionKey);
      await prefs.remove(_selectedRegionNameKey);
      await prefs.remove('${_selectedRegionNameKey}_en');
      await prefs.remove('${_selectedRegionNameKey}_ar');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> retry() async {
    if (_cities.isEmpty) {
      await loadCities();
    }
    if (_selectedCity != null && _regions.isEmpty) {
      await loadRegions(_selectedCity!.id);
    }
  }
}

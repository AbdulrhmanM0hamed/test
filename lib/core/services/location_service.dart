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
  List<City> _cities = [];
  List<Region> _regions = [];
  bool _isLoadingCities = false;
  bool _isLoadingRegions = false;
  String? _error;
  final LanguageService _languageService;
  final DioService _dioService;

  City? get selectedCity => _selectedCity;
  Region? get selectedRegion => _selectedRegion;
  List<City> get cities => _cities;
  List<Region> get regions => _regions;
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
    _languageService.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    notifyListeners();
  }

  String getLocalizedCityTitle(City city) {
    return city.getLocalizedTitle(_languageService.isArabic);
  }

  String getLocalizedRegionTitle(Region region) {
    return region.getLocalizedTitle(_languageService.isArabic);
  }

  String? get selectedCityLocalizedTitle {
    return _selectedCity?.getLocalizedTitle(_languageService.isArabic);
  }

  String? get selectedRegionLocalizedTitle {
    return _selectedRegion?.getLocalizedTitle(_languageService.isArabic);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Future<void> initialize() async {
    await _loadSavedLocation();
    if (_cities.isEmpty) {
      await loadCities();
    }
    if (_selectedCity != null && _regions.isEmpty) {
      await loadRegions(_selectedCity!.id);
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
      final cityId = prefs.getInt(_selectedCityKey);
      final cityName = prefs.getString(_selectedCityNameKey);
      final cityImage = prefs.getString(_selectedCityImageKey);
      final regionId = prefs.getInt(_selectedRegionKey);
      final regionName = prefs.getString(_selectedRegionNameKey);

      if (cityId != null && cityName != null) {
        _selectedCity = City(
          id: cityId,
          titleAr: cityName,
          titleEn: cityName,
          countryId: 1, // Default country ID
          image: cityImage,
        );
      }

      if (regionId != null && regionName != null) {
        _selectedRegion = Region(
          id: regionId,
          titleAr: regionName,
          titleEn: regionName,
          cityId: cityId ?? 1,
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_selectedCity != null) {
        await prefs.setInt(_selectedCityKey, _selectedCity!.id);
        await prefs.setString(_selectedCityNameKey, _selectedCity!.titleAr);
        if (_selectedCity!.image != null) {
          await prefs.setString(_selectedCityImageKey, _selectedCity!.image!);
        }
      }

      if (_selectedRegion != null) {
        await prefs.setInt(_selectedRegionKey, _selectedRegion!.id);
        await prefs.setString(_selectedRegionNameKey, _selectedRegion!.titleAr);
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
      await prefs.remove(_selectedCityImageKey);
      await prefs.remove(_selectedRegionKey);
      await prefs.remove(_selectedRegionNameKey);
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

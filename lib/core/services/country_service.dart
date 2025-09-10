import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import '../../features/profile/domain/entities/country.dart';
import '../../features/auth/presentation/cubit/location_cubit.dart';
import '../../features/auth/presentation/cubit/location_state.dart';
import 'data_refresh_service.dart';

class CountryService extends ChangeNotifier {
  static const String _selectedCountryKey = 'selected_country_id';
  static const String _selectedCountryNameKey = 'selected_country_name';
  static const String _selectedCountryImageKey = 'selected_country_image';

  Country? _selectedCountry;
  List<Country> _countries = [];
  bool _isLoading = false;
  String? _error;

  Country? get selectedCountry => _selectedCountry;
  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSelectedCountry => _selectedCountry != null;

  static CountryService? _instance;
  static CountryService get instance {
    _instance ??= CountryService._internal();
    return _instance!;
  }

  CountryService._internal();

  /// Initialize the service and load saved country
  Future<void> initialize() async {
    print('🌍 CountryService: Initializing service...');
    await _loadSavedCountry();
    print(
      '🌍 CountryService: Saved country loaded: ${_selectedCountry?.titleAr ?? "None"}',
    );
    if (_countries.isEmpty) {
      print('🌍 CountryService: Countries list is empty, loading from API...');
      await loadCountries();
    } else {
      print(
        '🌍 CountryService: Countries already loaded: ${_countries.length} countries',
      );
    }
  }

  /// Load countries from API
  Future<void> loadCountries() async {
    try {
      print('🌍 CountryService: Starting to load countries...');
      _isLoading = true;
      _error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      print('🌍 CountryService: Getting LocationCubit instance...');
      final locationCubit = GetIt.instance<LocationCubit>();
      print(
        '🌍 CountryService: LocationCubit state before call: ${locationCubit.state.runtimeType}',
      );

      print('🌍 CountryService: Calling getCountries()...');
      await locationCubit.getCountries();
      print(
        '🌍 CountryService: getCountries() completed. New state: ${locationCubit.state.runtimeType}',
      );

      // Listen to location cubit state
      if (locationCubit.state is LocationCountriesLoaded) {
        final state = locationCubit.state as LocationCountriesLoaded;
        _countries = state.countries;
        print(
          '🌍 CountryService: Successfully loaded ${_countries.length} countries',
        );
        for (int i = 0; i < _countries.length && i < 3; i++) {
          print(
            '🌍 CountryService: Country ${i + 1}: ${_countries[i].titleAr} (ID: ${_countries[i].id})',
          );
        }
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else if (locationCubit.state is LocationError) {
        final state = locationCubit.state as LocationError;
        _error = state.message;
        print('❌ CountryService: LocationError occurred: ${state.message}');
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        print(
          '⚠️ CountryService: Unexpected state type: ${locationCubit.state.runtimeType}',
        );
        _error = 'حالة غير متوقعة في تحميل الدول';
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e, stackTrace) {
      print('❌ CountryService: Exception occurred while loading countries: $e');
      print('❌ CountryService: Stack trace: $stackTrace');
      _error = 'حدث خطأ في تحميل الدول: $e';
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Select a country and trigger app refresh
  Future<void> selectCountry(Country country) async {
    if (_selectedCountry?.id == country.id) return;

    _selectedCountry = country;
    await _saveSelectedCountry(country);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Trigger app-wide refresh like language switching
    final dataRefreshService = GetIt.instance<DataRefreshService>();
    dataRefreshService.refreshAll();
  }

  /// Clear selected country
  Future<void> clearSelectedCountry() async {
    _selectedCountry = null;
    await _clearSavedCountry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Trigger app-wide refresh
    final dataRefreshService = GetIt.instance<DataRefreshService>();
    dataRefreshService.refreshAll();
  }

  /// Get selected country ID for API calls
  int? getSelectedCountryId() {
    return _selectedCountry?.id;
  }

  /// Get country query parameter for API calls
  String getCountryQueryParam() {
    final countryId = getSelectedCountryId();
    return countryId != null ? '?country_id=$countryId' : '';
  }

  /// Load saved country from SharedPreferences
  Future<void> _loadSavedCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countryId = prefs.getInt(_selectedCountryKey);
      final countryName = prefs.getString(_selectedCountryNameKey);
      final countryImage = prefs.getString(_selectedCountryImageKey);

      if (countryId != null && countryName != null) {
        _selectedCountry = Country(
          id: countryId,
          titleAr: countryName,
          titleEn: countryName,
          image: countryImage,
          code: '',
          shortcut: '',
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Save selected country to SharedPreferences
  Future<void> _saveSelectedCountry(Country country) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_selectedCountryKey, country.id);
      await prefs.setString(_selectedCountryNameKey, country.titleAr);
      if (country.image != null) {
        await prefs.setString(_selectedCountryImageKey, country.image!);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Clear saved country from SharedPreferences
  Future<void> _clearSavedCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedCountryKey);
      await prefs.remove(_selectedCountryNameKey);
      await prefs.remove(_selectedCountryImageKey);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Retry loading countries after error
  Future<void> retry() async {
    await loadCountries();
  }
}

import 'package:test/core/models/api_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/usecases/get_cities_usecase.dart';
import 'package:test/features/auth/domain/usecases/get_countries_usecase.dart';
import 'package:test/features/auth/domain/usecases/get_regions_usecase.dart';
import 'package:test/features/auth/domain/usecases/signup_usecase.dart';
import 'package:test/features/auth/presentation/cubit/registration_state.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/region.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetRegionsUseCase getRegionsUseCase;
  final SignupUseCase signupUseCase;

  // Selected location data
  Country? selectedCountry;
  City? selectedCity;
  Region? selectedRegion;

  // Location lists
  List<Country> countries = [];
  List<City> cities = [];
  List<Region> regions = [];

  RegistrationCubit({
    required this.getCountriesUseCase,
    required this.getCitiesUseCase,
    required this.getRegionsUseCase,
    required this.signupUseCase,
  }) : super(RegistrationInitial());

  Future<void> loadCountries() async {
    try {
      emit(LocationLoading());
      countries = await getCountriesUseCase();
      emit(CountriesLoaded(countries: countries));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> selectCountry(Country country) async {
    selectedCountry = country;
    selectedCity = null;
    selectedRegion = null;
    cities.clear();
    regions.clear();
    
    try {
      emit(LocationLoading());
      cities = await getCitiesUseCase(country.id);
      emit(CitiesLoaded(cities: cities));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> selectCity(City city) async {
    selectedCity = city;
    selectedRegion = null;
    regions.clear();
    
    try {
      emit(LocationLoading());
      regions = await getRegionsUseCase(city.id);
      emit(RegionsLoaded(regions: regions));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  void selectRegion(Region region) {
    selectedRegion = region;
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required DateTime birthDate,
    required String gender,
    required String password,
    required Country country,
    City? city,
    Region? region,
  }) async {
    try {
      emit(RegistrationLoading());
      
      final signupRequest = SignupRequest(
        name: name,
        email: email,
        phone: phone,
        birthDate:
            '${birthDate.year}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.day.toString().padLeft(2, '0')}',
        gender: gender,
        signFrom: 'mobile',
        password: password,
        confirmPassword: password, // Use same password for confirmation
        countryId: country.id,
        cityId: city?.id ?? country.id, // Use country id as fallback
        regionId: region?.id ?? city?.id ?? country.id, // Use city or country id as fallback
      );

      final response = await signupUseCase(signupRequest);
      
      if (response.success && response.data != null) {
        emit(RegistrationSuccess(
          user: response.data!,
          message: response.message,
        ));
      } else {
        // Handle API response errors
        String errorMessage = response.getFirstErrorMessage() ?? response.message;
        emit(RegistrationError(message: errorMessage));
      }
    } catch (e) {
      // Handle ApiException and other errors
      if (e is ApiException) {
        String errorMessage = e.getFirstErrorMessage();
        emit(RegistrationError(message: errorMessage));
      } else {
        emit(RegistrationError(message: 'حدث خطأ غير متوقع'));
      }
    }
  }

  void resetState() {
    selectedCountry = null;
    selectedCity = null;
    selectedRegion = null;
    countries.clear();
    cities.clear();
    regions.clear();
    emit(RegistrationInitial());
  }
}

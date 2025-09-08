import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';
import 'package:test/features/auth/domain/usecases/login_usecase.dart';
import 'package:test/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:test/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:test/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
// Registration feature imports
import 'package:test/features/auth/data/datasources/location_remote_data_source.dart';
import 'package:test/features/auth/data/datasources/registration_remote_data_source.dart';
import 'package:test/features/auth/data/repositories/location_repository_impl.dart';
import 'package:test/features/auth/data/repositories/registration_repository_impl.dart';
import 'package:test/features/auth/domain/repositories/location_repository.dart';
import 'package:test/features/auth/domain/repositories/registration_repository.dart';
import 'package:test/features/auth/domain/usecases/get_countries_usecase.dart';
import 'package:test/features/auth/domain/usecases/get_cities_usecase.dart';
import 'package:test/features/auth/domain/usecases/get_regions_usecase.dart';
import 'package:test/features/auth/domain/usecases/signup_usecase.dart';
import 'package:test/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:test/features/auth/presentation/cubit/location_cubit.dart';

class DependencyInjection {
  static final GetIt getIt = GetIt.instance;

  static TokenStorageService? _tokenStorageService;
  static AppStateService? _appStateService;
  static DioService? _dioService;
  static AuthRemoteDataSource? _authRemoteDataSource;
  static AuthRepository? _authRepository;
  static LoginUseCase? _loginUseCase;
  static LogoutUseCase? _logoutUseCase;
  static ProfileRemoteDataSource? _profileRemoteDataSource;
  static ProfileRepository? _profileRepository;
  static GetProfileUseCase? _getProfileUseCase;

  // Registration feature
  static LocationRemoteDataSource? _locationRemoteDataSource;
  static RegistrationRemoteDataSource? _registrationRemoteDataSource;
  static LocationRepository? _locationRepository;
  static RegistrationRepository? _registrationRepository;
  static GetCountriesUseCase? _getCountriesUseCase;
  static GetCitiesUseCase? _getCitiesUseCase;
  static GetRegionsUseCase? _getRegionsUseCase;
  static SignupUseCase? _signupUseCase;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize services
    _tokenStorageService = TokenStorageService(sharedPreferences);
    _appStateService = AppStateService(sharedPreferences);

    // Initialize dio service
    _dioService = DioService.instance;
    _dioService!.setTokenStorageService(_tokenStorageService!);

    // Initialize data source
    _authRemoteDataSource = AuthRemoteDataSourceImpl(dioService: _dioService!);

    // Initialize repository
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource!,
    );

    // Initialize use cases
    _loginUseCase = LoginUseCase(_authRepository!);
    _logoutUseCase = LogoutUseCase(_authRepository!);

    // Initialize Profile dependencies
    _profileRemoteDataSource = ProfileRemoteDataSourceImpl(_dioService!);
    _profileRepository = ProfileRepositoryImpl(_profileRemoteDataSource!);
    _getProfileUseCase = GetProfileUseCase(_profileRepository!);

    // Initialize Registration dependencies
    _locationRemoteDataSource = LocationRemoteDataSourceImpl(dioService: _dioService!);
    _registrationRemoteDataSource = RegistrationRemoteDataSourceImpl(dioService: _dioService!);
    _locationRepository = LocationRepositoryImpl(remoteDataSource: _locationRemoteDataSource!);
    _registrationRepository = RegistrationRepositoryImpl(remoteDataSource: _registrationRemoteDataSource!);
    _getCountriesUseCase = GetCountriesUseCase(repository: _locationRepository!);
    _getCitiesUseCase = GetCitiesUseCase(repository: _locationRepository!);
    _getRegionsUseCase = GetRegionsUseCase(repository: _locationRepository!);
    _signupUseCase = SignupUseCase(repository: _registrationRepository!);

    // Register with GetIt
    getIt.registerSingleton<TokenStorageService>(_tokenStorageService!);
    getIt.registerSingleton<AppStateService>(_appStateService!);
    getIt.registerSingleton<DioService>(_dioService!);
    getIt.registerSingleton<AuthRepository>(_authRepository!);
    getIt.registerSingleton<LoginUseCase>(_loginUseCase!);
    getIt.registerSingleton<LogoutUseCase>(_logoutUseCase!);
    getIt.registerSingleton<ProfileRepository>(_profileRepository!);
    getIt.registerSingleton<GetProfileUseCase>(_getProfileUseCase!);
    // Registration singletons
    getIt.registerSingleton<LocationRepository>(_locationRepository!);
    getIt.registerSingleton<RegistrationRepository>(_registrationRepository!);
    getIt.registerSingleton<GetCountriesUseCase>(_getCountriesUseCase!);
    getIt.registerSingleton<GetCitiesUseCase>(_getCitiesUseCase!);
    getIt.registerSingleton<GetRegionsUseCase>(_getRegionsUseCase!);
    getIt.registerSingleton<SignupUseCase>(_signupUseCase!);

    // Register Cubits as factories
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        tokenStorageService: getIt<TokenStorageService>(),
        appStateService: getIt<AppStateService>(),
      ),
    );

    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        profileRepository: getIt<ProfileRepository>(),
      ),
    );

    // Registration Cubit
    getIt.registerFactory<RegistrationCubit>(
      () => RegistrationCubit(
        getCountriesUseCase: getIt<GetCountriesUseCase>(),
        getCitiesUseCase: getIt<GetCitiesUseCase>(),
        getRegionsUseCase: getIt<GetRegionsUseCase>(),
        signupUseCase: getIt<SignupUseCase>(),
      ),
    );
  }

  static AuthCubit createAuthCubit() {
    if (_loginUseCase == null || _tokenStorageService == null || _appStateService == null) {
      throw Exception(
        'DependencyInjection not initialized. Call DependencyInjection.init() first.',
      );
    }
    return AuthCubit(
      loginUseCase: _loginUseCase!,
      logoutUseCase: _logoutUseCase!,
      tokenStorageService: _tokenStorageService!,
      appStateService: _appStateService!,
    );
  }

  static RegistrationCubit createRegistrationCubit() {
    if (_signupUseCase == null || _getCountriesUseCase == null) {
      throw Exception(
        'DependencyInjection not initialized. Call DependencyInjection.init() first.',
      );
    }
    return RegistrationCubit(
      getCountriesUseCase: _getCountriesUseCase!,
      getCitiesUseCase: _getCitiesUseCase!,
      getRegionsUseCase: _getRegionsUseCase!,
      signupUseCase: _signupUseCase!,
    );
  }

  static LocationCubit createLocationCubit() {
    if (_locationRemoteDataSource == null) {
      throw Exception(
        'DependencyInjection not initialized. Call DependencyInjection.init() first.',
      );
    }
    return LocationCubit(
      locationRemoteDataSource: _locationRemoteDataSource!,
    );
  }

  static TokenStorageService get tokenStorageService => _tokenStorageService!;
  static DioService get dioService => _dioService!;
  static AuthRepository get authRepository => _authRepository!;
  static LoginUseCase get loginUseCase => _loginUseCase!;
}

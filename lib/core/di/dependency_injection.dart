import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/language_service.dart';
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
// Categories feature imports
import 'package:test/features/categories/data/datasources/department_remote_data_source.dart';
import 'package:test/features/categories/data/repositories/department_repository_impl.dart';
import 'package:test/features/categories/domain/repositories/department_repository.dart';
import 'package:test/features/categories/domain/usecases/get_departments_usecase.dart';
import 'package:test/features/categories/presentation/cubit/department_cubit.dart';
// Products feature imports
import 'package:test/features/categories/data/datasources/products_remote_data_source.dart';
import 'package:test/features/categories/data/repositories/products_repository_impl.dart';
import 'package:test/features/categories/domain/repositories/products_repository.dart';
import 'package:test/features/categories/domain/usecases/get_products_by_department_usecase.dart';
import 'package:test/features/categories/presentation/cubit/products_cubit.dart';
// Home products feature imports
import 'package:test/features/home/data/datasources/home_products_remote_data_source.dart';
import 'package:test/features/home/data/repositories/home_products_repository_impl.dart';
import 'package:test/features/home/domain/repositories/home_products_repository.dart';
import 'package:test/features/home/domain/usecases/get_featured_products_use_case.dart';
import 'package:test/features/home/domain/usecases/get_best_seller_products_use_case.dart';
import 'package:test/features/home/domain/usecases/get_latest_products_use_case.dart';
import 'package:test/features/home/domain/usecases/get_special_offer_products_use_case.dart';
import 'package:test/features/home/presentation/cubits/featured_products/featured_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/best_seller_products/best_seller_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/latest_products/latest_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/special_offer_products/special_offer_products_cubit.dart';

class DependencyInjection {
  static final GetIt getIt = GetIt.instance;

  static TokenStorageService? _tokenStorageService;
  static AppStateService? _appStateService;
  static LanguageService? _languageService;
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

  // Categories feature
  static DepartmentRemoteDataSource? _departmentRemoteDataSource;
  static DepartmentRepository? _departmentRepository;
  static GetDepartmentsUseCase? _getDepartmentsUseCase;

  // Products feature
  static ProductsRemoteDataSource? _productsRemoteDataSource;
  static ProductsRepository? _productsRepository;
  static GetProductsByDepartmentUseCase? _getProductsByDepartmentUseCase;

  // Home products feature
  static HomeProductsRemoteDataSource? _homeProductsRemoteDataSource;
  static HomeProductsRepository? _homeProductsRepository;
  static GetFeaturedProductsUseCase? _getFeaturedProductsUseCase;
  static GetBestSellerProductsUseCase? _getBestSellerProductsUseCase;
  static GetLatestProductsUseCase? _getLatestProductsUseCase;
  static GetSpecialOfferProductsUseCase? _getSpecialOfferProductsUseCase;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize services
    _tokenStorageService = TokenStorageService(sharedPreferences);
    _appStateService = AppStateService(sharedPreferences);
    _languageService = LanguageService();

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

    // Initialize Categories dependencies
    _departmentRemoteDataSource = DepartmentRemoteDataSourceImpl(dioService: _dioService!);
    _departmentRepository = DepartmentRepositoryImpl(remoteDataSource: _departmentRemoteDataSource!);
    _getDepartmentsUseCase = GetDepartmentsUseCase(_departmentRepository!);

    // Initialize Products dependencies
    _productsRemoteDataSource = ProductsRemoteDataSourceImpl(dioService: _dioService!);
    _productsRepository = ProductsRepositoryImpl(remoteDataSource: _productsRemoteDataSource!);
    _getProductsByDepartmentUseCase = GetProductsByDepartmentUseCase(_productsRepository!);

    // Initialize Home Products dependencies
    _homeProductsRemoteDataSource = HomeProductsRemoteDataSourceImpl(dioService: _dioService!);
    _homeProductsRepository = HomeProductsRepositoryImpl(remoteDataSource: _homeProductsRemoteDataSource!);
    _getFeaturedProductsUseCase = GetFeaturedProductsUseCase(repository: _homeProductsRepository!);
    _getBestSellerProductsUseCase = GetBestSellerProductsUseCase(repository: _homeProductsRepository!);
    _getLatestProductsUseCase = GetLatestProductsUseCase(repository: _homeProductsRepository!);
    _getSpecialOfferProductsUseCase = GetSpecialOfferProductsUseCase(repository: _homeProductsRepository!);

    // Register with GetIt
    getIt.registerSingleton<TokenStorageService>(_tokenStorageService!);
    getIt.registerSingleton<AppStateService>(_appStateService!);
    getIt.registerSingleton<LanguageService>(_languageService!);
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
    // Categories singletons
    getIt.registerSingleton<DepartmentRepository>(_departmentRepository!);
    getIt.registerSingleton<GetDepartmentsUseCase>(_getDepartmentsUseCase!);
    // Products singletons
    getIt.registerSingleton<ProductsRepository>(_productsRepository!);
    getIt.registerSingleton<GetProductsByDepartmentUseCase>(_getProductsByDepartmentUseCase!);
    // Home Products singletons
    getIt.registerSingleton<HomeProductsRepository>(_homeProductsRepository!);
    getIt.registerSingleton<GetFeaturedProductsUseCase>(_getFeaturedProductsUseCase!);
    getIt.registerSingleton<GetBestSellerProductsUseCase>(_getBestSellerProductsUseCase!);
    getIt.registerSingleton<GetLatestProductsUseCase>(_getLatestProductsUseCase!);
    getIt.registerSingleton<GetSpecialOfferProductsUseCase>(_getSpecialOfferProductsUseCase!);

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

    // Department Cubit
    getIt.registerFactory<DepartmentCubit>(
      () => DepartmentCubit(
        getDepartmentsUseCase: getIt<GetDepartmentsUseCase>(),
      ),
    );

    // Products Cubit
    getIt.registerFactory<ProductsCubit>(
      () => ProductsCubit(
        getProductsByDepartmentUseCase: getIt<GetProductsByDepartmentUseCase>(),
      ),
    );

    // Home Products Cubits
    getIt.registerFactory<FeaturedProductsCubit>(
      () => FeaturedProductsCubit(
        getFeaturedProductsUseCase: getIt<GetFeaturedProductsUseCase>(),
      ),
    );

    getIt.registerFactory<BestSellerProductsCubit>(
      () => BestSellerProductsCubit(
        getBestSellerProductsUseCase: getIt<GetBestSellerProductsUseCase>(),
      ),
    );

    getIt.registerFactory<LatestProductsCubit>(
      () => LatestProductsCubit(
        getLatestProductsUseCase: getIt<GetLatestProductsUseCase>(),
      ),
    );

    getIt.registerFactory<SpecialOfferProductsCubit>(
      () => SpecialOfferProductsCubit(
        getSpecialOfferProductsUseCase: getIt<GetSpecialOfferProductsUseCase>(),
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

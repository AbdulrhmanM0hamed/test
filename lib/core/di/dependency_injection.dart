import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/services/network/network_info.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/services/country_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';
import 'package:test/features/auth/domain/usecases/login_usecase.dart';
import 'package:test/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:test/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import 'package:test/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:test/features/auth/domain/usecases/check_otp_usecase.dart';
import 'package:test/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:test/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:test/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:test/features/profile/domain/usecases/update_profile_usecase.dart';
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
import 'package:test/features/categories/domain/usecases/get_all_products_usecase.dart';
import 'package:test/features/categories/presentation/cubit/products_cubit.dart';
import 'package:test/features/categories/presentation/cubits/products_filter_cubit.dart';
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
// Product details feature imports
import 'package:test/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:test/features/product_details/data/repositories/product_details_repository_impl.dart';
import 'package:test/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:test/features/product_details/domain/usecases/get_product_details_usecase.dart';
import 'package:test/features/product_details/presentation/cubit/product_details_cubit.dart';
// Wishlist feature imports
import 'package:test/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:test/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:test/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:test/features/wishlist/domain/usecases/get_my_wishlist_use_case.dart';
import 'package:test/features/wishlist/domain/usecases/add_to_wishlist_use_case.dart';
import 'package:test/features/wishlist/domain/usecases/remove_from_wishlist_use_case.dart';
import 'package:test/features/wishlist/domain/usecases/remove_all_from_wishlist_use_case.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
// Cart feature imports
import 'package:test/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:test/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:test/features/cart/domain/repositories/cart_repository.dart';
import 'package:test/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:test/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:test/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:test/features/cart/domain/usecases/remove_all_from_cart_usecase.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';

class DependencyInjection {
  static final GetIt getIt = GetIt.instance;

  static TokenStorageService? _tokenStorageService;
  static AppStateService? _appStateService;
  static LanguageService? _languageService;
  static DataRefreshService? _dataRefreshService;
  static CountryService? _countryService;
  static DioService? _dioService;
  static AuthRemoteDataSource? _authRemoteDataSource;
  static AuthRepository? _authRepository;
  static LoginUseCase? _loginUseCase;
  static LogoutUseCase? _logoutUseCase;
  static RefreshTokenUseCase? _refreshTokenUseCase;
  static ForgetPasswordUseCase? _forgetPasswordUseCase;
  static CheckOtpUseCase? _checkOtpUseCase;
  static ChangePasswordUseCase? _changePasswordUseCase;
  static ProfileRemoteDataSource? _profileRemoteDataSource;
  static ProfileRepository? _profileRepository;
  static GetProfileUseCase? _getProfileUseCase;
  static UpdateProfileUseCase? _updateProfileUseCase;

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
  static GetAllProductsUseCase? _getAllProductsUseCase;

  // Home products feature
  static HomeProductsRemoteDataSource? _homeProductsRemoteDataSource;
  static HomeProductsRepository? _homeProductsRepository;
  static GetFeaturedProductsUseCase? _getFeaturedProductsUseCase;
  static GetBestSellerProductsUseCase? _getBestSellerProductsUseCase;
  static GetLatestProductsUseCase? _getLatestProductsUseCase;
  static GetSpecialOfferProductsUseCase? _getSpecialOfferProductsUseCase;

  // Product details feature
  static ProductDetailsRemoteDataSource? _productDetailsRemoteDataSource;
  static ProductDetailsRepository? _productDetailsRepository;
  static GetProductDetailsUseCase? _getProductDetailsUseCase;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize services in correct order
    _tokenStorageService = TokenStorageService(sharedPreferences);
    _appStateService = AppStateService(sharedPreferences);
    _languageService = LanguageService();

    // Register LanguageService first before CountryService needs it
    getIt.registerSingleton<LanguageService>(_languageService!);

    _dataRefreshService = DataRefreshService(_languageService!);
    _countryService = CountryService.instance;

    // Initialize network info
    final connectivity = Connectivity();
    final networkInfo = NetworkInfoImpl(connectivity);
    getIt.registerSingleton<NetworkInfo>(networkInfo);

    // Initialize dio service
    _dioService = DioService.instance;
    _dioService!.setTokenStorageService(_tokenStorageService!);

    // Initialize data source
    _authRemoteDataSource = AuthRemoteDataSourceImpl(dioService: _dioService!);

    // Initialize repository
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource!,
    );

    // Set auth repository in dio service after it's created
    _dioService!.setAuthRepository(_authRepository!);

    // Initialize use cases
    _loginUseCase = LoginUseCase(_authRepository!);
    _logoutUseCase = LogoutUseCase(_authRepository!);
    _refreshTokenUseCase = RefreshTokenUseCase(_authRepository!);
    _forgetPasswordUseCase = ForgetPasswordUseCase(
      repository: _authRepository!,
    );
    _checkOtpUseCase = CheckOtpUseCase(repository: _authRepository!);
    _changePasswordUseCase = ChangePasswordUseCase(
      repository: _authRepository!,
    );

    // Initialize Profile dependencies
    _profileRemoteDataSource = ProfileRemoteDataSourceImpl(_dioService!);
    _profileRepository = ProfileRepositoryImpl(_profileRemoteDataSource!);
    _getProfileUseCase = GetProfileUseCase(_profileRepository!);
    _updateProfileUseCase = UpdateProfileUseCase(
      repository: _profileRepository!,
    );

    // Initialize Registration dependencies
    _locationRemoteDataSource = LocationRemoteDataSourceImpl(
      dioService: _dioService!,
    );
    _registrationRemoteDataSource = RegistrationRemoteDataSourceImpl(
      dioService: _dioService!,
    );
    _locationRepository = LocationRepositoryImpl(
      remoteDataSource: _locationRemoteDataSource!,
    );
    _registrationRepository = RegistrationRepositoryImpl(
      remoteDataSource: _registrationRemoteDataSource!,
    );
    _getCountriesUseCase = GetCountriesUseCase(
      repository: _locationRepository!,
    );
    _getCitiesUseCase = GetCitiesUseCase(repository: _locationRepository!);
    _getRegionsUseCase = GetRegionsUseCase(repository: _locationRepository!);
    _signupUseCase = SignupUseCase(repository: _registrationRepository!);

    // Initialize Categories dependencies
    _departmentRemoteDataSource = DepartmentRemoteDataSourceImpl(
      dioService: _dioService!,
    );
    _departmentRepository = DepartmentRepositoryImpl(
      remoteDataSource: _departmentRemoteDataSource!,
    );
    _getDepartmentsUseCase = GetDepartmentsUseCase(_departmentRepository!);

    // Initialize Products dependencies
    _productsRemoteDataSource = ProductsRemoteDataSourceImpl(
      dioService: _dioService!,
    );
    _productsRepository = ProductsRepositoryImpl(
      remoteDataSource: _productsRemoteDataSource!,
    );
    _getProductsByDepartmentUseCase = GetProductsByDepartmentUseCase(
      _productsRepository!,
    );
    _getAllProductsUseCase = GetAllProductsUseCase(
      repository: _productsRepository!,
    );

    // Initialize Home Products dependencies
    _homeProductsRemoteDataSource = HomeProductsRemoteDataSourceImpl(
      dioService: _dioService!,
    );
    _homeProductsRepository = HomeProductsRepositoryImpl(
      remoteDataSource: _homeProductsRemoteDataSource!,
    );
    _getFeaturedProductsUseCase = GetFeaturedProductsUseCase(
      repository: _homeProductsRepository!,
    );
    _getBestSellerProductsUseCase = GetBestSellerProductsUseCase(
      repository: _homeProductsRepository!,
    );
    _getLatestProductsUseCase = GetLatestProductsUseCase(
      repository: _homeProductsRepository!,
    );
    _getSpecialOfferProductsUseCase = GetSpecialOfferProductsUseCase(
      repository: _homeProductsRepository!,
    );

    // Initialize Product Details dependencies
    _productDetailsRemoteDataSource = ProductDetailsRemoteDataSourceImpl(
      _dioService!,
    );
    _productDetailsRepository = ProductDetailsRepositoryImpl(
      _productDetailsRemoteDataSource!,
    );
    _getProductDetailsUseCase = GetProductDetailsUseCase(
      _productDetailsRepository!,
    );

    // Register with GetIt (LanguageService already registered above)
    getIt.registerSingleton<TokenStorageService>(_tokenStorageService!);
    getIt.registerSingleton<AppStateService>(_appStateService!);
    getIt.registerSingleton<DataRefreshService>(_dataRefreshService!);
    getIt.registerSingleton<CountryService>(_countryService!);
    getIt.registerSingleton<DioService>(_dioService!);
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dioService: getIt()),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt()),
    );
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
    getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
    getIt.registerLazySingleton<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(getIt()),
    );
    getIt.registerLazySingleton<ResendVerificationEmailUseCase>(
      () => ResendVerificationEmailUseCase(getIt()),
    );
    getIt.registerLazySingleton<ForgetPasswordUseCase>(
      () => ForgetPasswordUseCase(repository: getIt()),
    );
    getIt.registerLazySingleton<CheckOtpUseCase>(
      () => CheckOtpUseCase(repository: getIt()),
    );
    getIt.registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(repository: getIt()),
    );

    // Register Wishlist dependencies
    getIt.registerLazySingleton<WishlistRemoteDataSource>(
      () => WishlistRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<WishlistRepository>(
      () => WishlistRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<GetMyWishlistUseCase>(
      () => GetMyWishlistUseCase(getIt()),
    );
    getIt.registerLazySingleton<AddToWishlistUseCase>(
      () => AddToWishlistUseCase(getIt()),
    );
    getIt.registerLazySingleton<RemoveFromWishlistUseCase>(
      () => RemoveFromWishlistUseCase(getIt()),
    );
    getIt.registerLazySingleton<RemoveAllFromWishlistUseCase>(
      () => RemoveAllFromWishlistUseCase(getIt()),
    );

    // Register Cart dependencies
    getIt.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(dioService: getIt()),
    );
    getIt.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
    );
    getIt.registerLazySingleton<GetCartUseCase>(() => GetCartUseCase(getIt()));
    getIt.registerLazySingleton<AddToCartUseCase>(
      () => AddToCartUseCase(getIt()),
    );
    getIt.registerLazySingleton<RemoveFromCartUseCase>(
      () => RemoveFromCartUseCase(getIt()),
    );
    getIt.registerLazySingleton<RemoveAllFromCartUseCase>(
      () => RemoveAllFromCartUseCase(getIt()),
    );

    getIt.registerSingleton<ProfileRepository>(_profileRepository!);
    getIt.registerSingleton<GetProfileUseCase>(_getProfileUseCase!);
    getIt.registerSingleton<UpdateProfileUseCase>(_updateProfileUseCase!);
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
    getIt.registerSingleton<GetProductsByDepartmentUseCase>(
      _getProductsByDepartmentUseCase!,
    );
    getIt.registerSingleton<GetAllProductsUseCase>(_getAllProductsUseCase!);
    // Home Products singletons
    getIt.registerSingleton<HomeProductsRepository>(_homeProductsRepository!);
    getIt.registerSingleton<GetFeaturedProductsUseCase>(
      _getFeaturedProductsUseCase!,
    );
    getIt.registerSingleton<GetBestSellerProductsUseCase>(
      _getBestSellerProductsUseCase!,
    );
    getIt.registerSingleton<GetLatestProductsUseCase>(
      _getLatestProductsUseCase!,
    );
    getIt.registerSingleton<GetSpecialOfferProductsUseCase>(
      _getSpecialOfferProductsUseCase!,
    );
    // Product Details singletons
    getIt.registerSingleton<ProductDetailsRepository>(
      _productDetailsRepository!,
    );
    getIt.registerSingleton<GetProductDetailsUseCase>(
      _getProductDetailsUseCase!,
    );

    // Register FCM Service
    // getIt.registerSingleton<FCMService>(FCMService());
    // Register Cubits as factories
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        // fcmService: getIt<FCMService>(),
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        refreshTokenUseCase: getIt<RefreshTokenUseCase>(),
        resendVerificationEmailUseCase: getIt<ResendVerificationEmailUseCase>(),
        tokenStorageService: getIt<TokenStorageService>(),
        appStateService: getIt<AppStateService>(),
      ),
    );

    // Location Cubit
    getIt.registerFactory<LocationCubit>(
      () => LocationCubit(locationRemoteDataSource: _locationRemoteDataSource!),
    );

    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        updateProfileUseCase: getIt<UpdateProfileUseCase>(),
        profileRepository: getIt<ProfileRepository>(),
        dataRefreshService: getIt<DataRefreshService>(),
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
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    // Products Cubit
    getIt.registerFactory<ProductsCubit>(
      () => ProductsCubit(
        getProductsByDepartmentUseCase: getIt<GetProductsByDepartmentUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    // Home Products Cubits
    getIt.registerFactory<FeaturedProductsCubit>(
      () => FeaturedProductsCubit(
        getFeaturedProductsUseCase: getIt<GetFeaturedProductsUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    getIt.registerFactory<BestSellerProductsCubit>(
      () => BestSellerProductsCubit(
        getBestSellerProductsUseCase: getIt<GetBestSellerProductsUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    getIt.registerFactory<LatestProductsCubit>(
      () => LatestProductsCubit(
        getLatestProductsUseCase: getIt<GetLatestProductsUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    getIt.registerFactory<SpecialOfferProductsCubit>(
      () => SpecialOfferProductsCubit(
        getSpecialOfferProductsUseCase: getIt<GetSpecialOfferProductsUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    // Product Details Cubit
    getIt.registerFactory<ProductDetailsCubit>(
      () => ProductDetailsCubit(getIt<GetProductDetailsUseCase>()),
    );

    // Products Filter Cubit
    getIt.registerFactory<ProductsFilterCubit>(
      () => ProductsFilterCubit(
        getAllProductsUseCase: getIt<GetAllProductsUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    // Forget Password Cubit
    getIt.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(
        forgetPasswordUseCase: getIt<ForgetPasswordUseCase>(),
        checkOtpUseCase: getIt<CheckOtpUseCase>(),
        changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      ),
    );

    // Wishlist Cubit
    getIt.registerFactory<WishlistCubit>(
      () => WishlistCubit(
        getIt<GetMyWishlistUseCase>(),
        getIt<AddToWishlistUseCase>(),
        getIt<RemoveFromWishlistUseCase>(),
        getIt<RemoveAllFromWishlistUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );

    // Cart Cubit
    getIt.registerFactory<CartCubit>(
      () => CartCubit(
        getCartUseCase: getIt<GetCartUseCase>(),
        addToCartUseCase: getIt<AddToCartUseCase>(),
        removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
        removeAllFromCartUseCase: getIt<RemoveAllFromCartUseCase>(),
        dataRefreshService: getIt<DataRefreshService>(),
      ),
    );
  }

  static AuthCubit createAuthCubit() {
    if (_loginUseCase == null ||
        _tokenStorageService == null ||
        _appStateService == null) {
      throw Exception(
        'DependencyInjection not initialized. Call DependencyInjection.init() first.',
      );
    }
    return AuthCubit(
      // fcmService: getIt<FCMService>(),
      loginUseCase: _loginUseCase!,
      logoutUseCase: _logoutUseCase!,
      refreshTokenUseCase: _refreshTokenUseCase!,
      resendVerificationEmailUseCase: getIt<ResendVerificationEmailUseCase>(),
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
    return LocationCubit(locationRemoteDataSource: _locationRemoteDataSource!);
  }

  static TokenStorageService get tokenStorageService => _tokenStorageService!;
  static DioService get dioService => _dioService!;
  static AuthRepository get authRepository => _authRepository!;
  static LoginUseCase get loginUseCase => _loginUseCase!;
}

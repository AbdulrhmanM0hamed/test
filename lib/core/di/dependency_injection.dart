import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/services/token_storage_service.dart';
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

class DependencyInjection {
  static final GetIt getIt = GetIt.instance;

  static TokenStorageService? _tokenStorageService;
  static DioService? _dioService;
  static AuthRemoteDataSource? _authRemoteDataSource;
  static AuthRepository? _authRepository;
  static LoginUseCase? _loginUseCase;
  static LogoutUseCase? _logoutUseCase;
  static ProfileRemoteDataSource? _profileRemoteDataSource;
  static ProfileRepository? _profileRepository;
  static GetProfileUseCase? _getProfileUseCase;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize token storage service
    _tokenStorageService = TokenStorageService(sharedPreferences);

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

    // Register with GetIt
    getIt.registerSingleton<TokenStorageService>(_tokenStorageService!);
    getIt.registerSingleton<DioService>(_dioService!);
    getIt.registerSingleton<AuthRepository>(_authRepository!);
    getIt.registerSingleton<LoginUseCase>(_loginUseCase!);
    getIt.registerSingleton<LogoutUseCase>(_logoutUseCase!);
    getIt.registerSingleton<ProfileRepository>(_profileRepository!);
    getIt.registerSingleton<GetProfileUseCase>(_getProfileUseCase!);

    // Register Cubits as factories
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        tokenStorageService: getIt<TokenStorageService>(),
      ),
    );

    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        profileRepository: getIt<ProfileRepository>(),
      ),
    );
  }

  static AuthCubit createAuthCubit() {
    if (_loginUseCase == null || _tokenStorageService == null) {
      throw Exception(
        'DependencyInjection not initialized. Call DependencyInjection.init() first.',
      );
    }
    return AuthCubit(
      loginUseCase: _loginUseCase!,
      logoutUseCase: _logoutUseCase!,
      tokenStorageService: _tokenStorageService!,
    );
  }

  static TokenStorageService get tokenStorageService => _tokenStorageService!;
  static DioService get dioService => _dioService!;
  static AuthRepository get authRepository => _authRepository!;
  static LoginUseCase get loginUseCase => _loginUseCase!;
}

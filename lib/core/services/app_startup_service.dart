import 'package:flutter/foundation.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/network_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/core/services/cart_global_service.dart';

enum StartupPhase {
  initializing,
  checkingNetwork,
  loadingEssentials,
  loadingUserData,
  completed,
  error,
}

class StartupProgress {
  final StartupPhase phase;
  final String message;
  final double progress; // 0.0 to 1.0
  final String? error;

  const StartupProgress({
    required this.phase,
    required this.message,
    required this.progress,
    this.error,
  });

  StartupProgress copyWith({
    StartupPhase? phase,
    String? message,
    double? progress,
    String? error,
  }) {
    return StartupProgress(
      phase: phase ?? this.phase,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }
}

class AppStartupService extends ChangeNotifier {
  static AppStartupService? _instance;
  static AppStartupService get instance => _instance ??= AppStartupService._();

  AppStartupService._();

  StartupProgress _progress = const StartupProgress(
    phase: StartupPhase.initializing,
    message: 'جاري تحضير التطبيق...',
    progress: 0.0,
  );

  StartupProgress get progress => _progress;
  bool get isCompleted => _progress.phase == StartupPhase.completed;
  bool get hasError => _progress.phase == StartupPhase.error;

  void _updateProgress(StartupProgress newProgress) {
    _progress = newProgress;
    notifyListeners();
    //print('🚀 AppStartup: ${newProgress.phase.name} - ${newProgress.message} (${(newProgress.progress * 100).toInt()}%)');
  }

  /// Start the app initialization process
  Future<String> initializeApp() async {
    try {
      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.initializing,
          message: 'بدء تشغيل التطبيق...',
          progress: 0.1,
        ),
      );

      // Phase 1: Check network connectivity
      await _checkNetworkConnectivity();

      // Phase 2: Load essential services
      await _loadEssentialServices();

      // Phase 3: Load user-specific data (only if logged in)
      await _loadUserData();

      // Phase 4: Complete startup
      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.completed,
          message: 'تم تحضير التطبيق بنجاح',
          progress: 1.0,
        ),
      );

      // Determine next route
      final appStateService = DependencyInjection.getIt.get<AppStateService>();
      return appStateService.getInitialRoute();
    } catch (e) {
      //print('❌ AppStartup: Initialization failed: $e');
      _updateProgress(
        StartupProgress(
          phase: StartupPhase.error,
          message: 'حدث خطأ أثناء تحضير التطبيق',
          progress: 0.0,
          error: e.toString(),
        ),
      );

      // Even if startup fails, still navigate to home
      final appStateService = DependencyInjection.getIt.get<AppStateService>();
      return appStateService.getInitialRoute();
    }
  }

  /// Phase 1: Check network connectivity
  Future<void> _checkNetworkConnectivity() async {
    _updateProgress(
      const StartupProgress(
        phase: StartupPhase.checkingNetwork,
        message: 'فحص الاتصال بالإنترنت...',
        progress: 0.2,
      ),
    );

    try {
      final networkService = NetworkService.instance;
      await networkService.initialize();

      final networkResult = await networkService.checkNetworkStatus();

      if (networkResult.isConnected) {
        _updateProgress(
          StartupProgress(
            phase: StartupPhase.checkingNetwork,
            message: networkResult.message,
            progress: 0.3,
          ),
        );

        // Small delay to show network status
        await Future.delayed(const Duration(milliseconds: 800));
      } else {
        _updateProgress(
          const StartupProgress(
            phase: StartupPhase.checkingNetwork,
            message: 'لا يوجد اتصال - سيتم تشغيل التطبيق في وضع عدم الاتصال',
            progress: 0.3,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1200));
      }
    } catch (e) {
      //print('⚠️ AppStartup: Network check failed: $e');
      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.checkingNetwork,
          message: 'تعذر فحص الاتصال - المتابعة بدون اتصال',
          progress: 0.3,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  /// Phase 2: Load essential services
  Future<void> _loadEssentialServices() async {
    _updateProgress(
      const StartupProgress(
        phase: StartupPhase.loadingEssentials,
        message: 'تحميل الخدمات الأساسية...',
        progress: 0.4,
      ),
    );

    try {
      // Initialize essential services that don't require network
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading time

      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.loadingEssentials,
          message: 'تم تحميل الخدمات الأساسية',
          progress: 0.6,
        ),
      );
    } catch (e) {
      //print('⚠️ AppStartup: Essential services loading failed: $e');
      // Continue anyway
    }
  }

  /// Phase 3: Load user-specific data (only if logged in and connected)
  Future<void> _loadUserData() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    if (!isLoggedIn) {
      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.loadingUserData,
          message: 'جاهز للاستخدام',
          progress: 0.9,
        ),
      );
      return;
    }

    _updateProgress(
      const StartupProgress(
        phase: StartupPhase.loadingUserData,
        message: 'تحميل بيانات المستخدم...',
        progress: 0.7,
      ),
    );

    try {
      final networkService = NetworkService.instance;
      final isConnected = await networkService.isConnected();

      if (isConnected) {
        // Initialize global services for logged-in users
        await _initializeUserServices();

        _updateProgress(
          const StartupProgress(
            phase: StartupPhase.loadingUserData,
            message: 'تم تحميل بيانات المستخدم',
            progress: 0.9,
          ),
        );
      } else {
        _updateProgress(
          const StartupProgress(
            phase: StartupPhase.loadingUserData,
            message: 'سيتم تحميل البيانات عند توفر الاتصال',
            progress: 0.9,
          ),
        );
      }
    } catch (e) {
      //print('⚠️ AppStartup: User data loading failed: $e');
      _updateProgress(
        const StartupProgress(
          phase: StartupPhase.loadingUserData,
          message: 'سيتم تحميل البيانات لاحقاً',
          progress: 0.9,
        ),
      );
    }
  }

  /// Initialize user-specific services
  Future<void> _initializeUserServices() async {
    try {
      // Initialize global cubit service (but don't load data yet)
      GlobalCubitService.instance.initialize();

      // Initialize cart global service (but don't load data yet)
      await CartGlobalService.instance.initialize();

      //print('✅ AppStartup: User services initialized (lazy loading enabled)');
    } catch (e) {
      //print('⚠️ AppStartup: User services initialization failed: $e');
      // Continue anyway
    }
  }

  /// Reset startup state
  void reset() {
    _progress = const StartupProgress(
      phase: StartupPhase.initializing,
      message: 'جاري تحضير التطبيق...',
      progress: 0.0,
    );
    notifyListeners();
  }
}

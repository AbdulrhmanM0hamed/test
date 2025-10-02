import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

enum NetworkQuality { excellent, good, poor, offline }

enum NetworkType { wifi, mobile, ethernet, none }

class NetworkResult {
  final bool isConnected;
  final NetworkType type;
  final NetworkQuality quality;
  final int? pingMs;
  final String message;

  const NetworkResult({
    required this.isConnected,
    required this.type,
    required this.quality,
    this.pingMs,
    required this.message,
  });
}

class NetworkService {
  static NetworkService? _instance;
  static NetworkService get instance => _instance ??= NetworkService._();

  NetworkService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Stream controller for network status changes
  final StreamController<NetworkResult> _networkStatusController =
      StreamController<NetworkResult>.broadcast();

  Stream<NetworkResult> get networkStatusStream =>
      _networkStatusController.stream;

  NetworkResult? _lastResult;
  NetworkResult? get lastResult => _lastResult;

  /// Initialize network monitoring
  Future<void> initialize() async {
    ////print('🌐 NetworkService: Initializing...');

    // Check initial connectivity
    final initialResult = await checkNetworkStatus();
    _lastResult = initialResult;
    _networkStatusController.add(initialResult);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      ////print('🔄 NetworkService: Connectivity changed: $result');
      final networkResult = await checkNetworkStatus();
      _lastResult = networkResult;
      _networkStatusController.add(networkResult);
    });

    ////print('✅ NetworkService: Initialized successfully');
  }

  /// Check current network status with quality assessment
  Future<NetworkResult> checkNetworkStatus() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return const NetworkResult(
          isConnected: false,
          type: NetworkType.none,
          quality: NetworkQuality.offline,
          message: 'لا يوجد اتصال بالإنترنت',
        );
      }

      // Determine network type
      NetworkType networkType = NetworkType.none;
      if (connectivityResult == ConnectivityResult.wifi) {
        networkType = NetworkType.wifi;
      } else if (connectivityResult == ConnectivityResult.mobile) {
        networkType = NetworkType.mobile;
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        networkType = NetworkType.ethernet;
      }

      // Test actual internet connectivity and quality
      final qualityResult = await _testNetworkQuality();

      String message = _getNetworkMessage(networkType, qualityResult.quality);

      return NetworkResult(
        isConnected: true,
        type: networkType,
        quality: qualityResult.quality,
        pingMs: qualityResult.pingMs,
        message: message,
      );
    } catch (e) {
      ////print('❌ NetworkService: Error checking network: $e');
      return const NetworkResult(
        isConnected: false,
        type: NetworkType.none,
        quality: NetworkQuality.offline,
        message: 'خطأ في فحص الاتصال',
      );
    }
  }

  /// Test network quality by pinging a reliable server
  Future<({NetworkQuality quality, int? pingMs})> _testNetworkQuality() async {
    try {
      final stopwatch = Stopwatch()..start();

      // Test with Google's DNS (reliable and fast)
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        stopwatch.stop();
        final pingMs = stopwatch.elapsedMilliseconds;

        // Determine quality based on response time
        NetworkQuality quality;
        if (pingMs < 100) {
          quality = NetworkQuality.excellent;
        } else if (pingMs < 300) {
          quality = NetworkQuality.good;
        } else {
          quality = NetworkQuality.poor;
        }

        ////print('🏓 NetworkService: Ping test completed in ${pingMs}ms - Quality: $quality');
        return (quality: quality, pingMs: pingMs);
      }
    } catch (e) {
      ////print('🚨 NetworkService: Ping test failed: $e');
    }

    // Fallback: try HTTP request test
    return await _testHttpConnection();
  }

  /// Fallback HTTP connection test
  Future<({NetworkQuality quality, int? pingMs})> _testHttpConnection() async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await http
          .get(
            Uri.parse('https://www.google.com'),
            headers: {'User-Agent': 'NetworkTest/1.0'},
          )
          .timeout(const Duration(seconds: 8));

      stopwatch.stop();
      final responseTime = stopwatch.elapsedMilliseconds;

      if (response.statusCode == 200) {
        NetworkQuality quality;
        if (responseTime < 500) {
          quality = NetworkQuality.excellent;
        } else if (responseTime < 1500) {
          quality = NetworkQuality.good;
        } else {
          quality = NetworkQuality.poor;
        }

        ////print('🌐 NetworkService: HTTP test completed in ${responseTime}ms - Quality: $quality');
        return (quality: quality, pingMs: responseTime);
      }
    } catch (e) {
      ////print('🚨 NetworkService: HTTP test failed: $e');
    }

    return (quality: NetworkQuality.offline, pingMs: null);
  }

  /// Get localized network message
  String _getNetworkMessage(NetworkType type, NetworkQuality quality) {
    String typeStr = '';
    switch (type) {
      case NetworkType.wifi:
        typeStr = 'WiFi';
        break;
      case NetworkType.mobile:
        typeStr = 'بيانات الجوال';
        break;
      case NetworkType.ethernet:
        typeStr = 'إيثرنت';
        break;
      case NetworkType.none:
        return 'لا يوجد اتصال';
    }

    switch (quality) {
      case NetworkQuality.excellent:
        return 'متصل بـ $typeStr - جودة ممتازة';
      case NetworkQuality.good:
        return 'متصل بـ $typeStr - جودة جيدة';
      case NetworkQuality.poor:
        return 'متصل بـ $typeStr - جودة ضعيفة';
      case NetworkQuality.offline:
        return 'لا يوجد اتصال بالإنترنت';
    }
  }

  /// Quick connectivity check (without quality test)
  Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      ////print('❌ NetworkService: Quick connectivity check failed: $e');
      return false;
    }
  }

  /// Test if we can reach our API server
  Future<bool> canReachApiServer(String baseUrl) async {
    try {
      final response = await http
          .head(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 5));

      return response.statusCode <
          500; // Accept any response except server errors
    } catch (e) {
      ////print('🚨 NetworkService: Cannot reach API server: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
    ////print('🗑️ NetworkService: Disposed');
  }
}

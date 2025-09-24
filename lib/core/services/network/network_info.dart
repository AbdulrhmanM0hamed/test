import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e, stackTrace) {
      // In case of connectivity check error, we assume there's a connection
      // to avoid app disruption when the plugin isn't available
      //print('Connectivity check error: $e');
      //print('Stack trace: $stackTrace');
      return true;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    // Return the stream and handle any potential errors
    return connectivity.onConnectivityChanged.handleError((error, stackTrace) {
      //print('Connectivity stream error: $error');
      //print('Stack trace: $stackTrace');
      // Return a fallback connectivity result - assuming connected
      return ConnectivityResult.wifi;
    });
  }
}

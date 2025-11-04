import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to handle network connectivity status
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  late StreamController<bool> _connectivityController;
  late Stream<bool> _connectivityStream;
  bool _isConnected = true;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    _connectivityController = StreamController<bool>.broadcast();
    _connectivityStream = _connectivityController.stream;

    // Check initial connectivity
    final results = await _connectivity.checkConnectivity();
    _isConnected = _isNetworkConnected(results);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = _isNetworkConnected(results);
      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        _connectivityController.add(_isConnected);
      }
    });
  }

  /// Check if the current connectivity results indicate network access
  bool _isNetworkConnected(List<ConnectivityResult> results) {
    // Check if any result indicates connectivity
    for (final result in results) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
        case ConnectivityResult.ethernet:
          return true;
        case ConnectivityResult.none:
        default:
          continue;
      }
    }
    return false;
  }

  /// Get current connectivity status
  bool get isConnected => _isConnected;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _connectivityStream;

  /// Check connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _isConnected = _isNetworkConnected(results);
      return _isConnected;
    } catch (e) {
      // If we can't check connectivity, assume we're offline
      _isConnected = false;
      return false;
    }
  }

  /// Dispose of resources
  void dispose() {
    _connectivityController.close();
  }
}

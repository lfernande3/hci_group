import 'package:flutter/foundation.dart';
import '../../utils/connectivity_service.dart';
import '../../utils/offline_cache_service.dart';
import '../../errors/failures.dart';

/// Provider that handles data loading with offline support and retry logic
class OfflineDataProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  final OfflineCacheService _cacheService = OfflineCacheService();
  
  bool _isLoading = false;
  bool _isConnected = true;
  String? _errorMessage;
  DateTime? _lastDataUpdate;
  bool _showingCachedData = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get errorMessage => _errorMessage;
  DateTime? get lastDataUpdate => _lastDataUpdate;
  bool get showingCachedData => _showingCachedData;

  /// Initialize the provider
  Future<void> initialize() async {
    try {
      await _connectivityService.initialize();
      await _cacheService.initialize();
      
      _isConnected = _connectivityService.isConnected;
      
      // Listen to connectivity changes
      _connectivityService.connectivityStream.listen((isConnected) {
        if (_isConnected != isConnected) {
          _isConnected = isConnected;
          notifyListeners();
          
          // Auto-retry when connection is restored
          if (isConnected && _errorMessage != null) {
            // Delay to ensure stable connection
            Future.delayed(const Duration(seconds: 1), () {
              if (_errorMessage != null) {
                retryLastOperation();
              }
            });
          }
        }
      });
    } catch (e) {
      _setError('Failed to initialize offline support: $e');
    }
  }

  /// Load data with offline fallback support
  Future<T?> loadDataWithOfflineSupport<T>({
    required String cacheKey,
    required Future<T> Function() dataLoader,
    required Future<void> Function(T data) cacheUpdater,
    int? ttlHours,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (_isConnected) {
        // Try to load fresh data
        try {
          final data = await dataLoader();
          await cacheUpdater(data);
          _lastDataUpdate = DateTime.now();
          _showingCachedData = false;
          _setLoading(false);
          return data;
        } catch (e) {
          // Network/server error, fallback to cache
          return await _loadFromCacheWithFallback<T>(cacheKey);
        }
      } else {
        // Offline mode, load from cache
        return await _loadFromCacheWithFallback<T>(cacheKey);
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return null;
    }
  }

  /// Load data from cache with fallback handling
  Future<T?> _loadFromCacheWithFallback<T>(String cacheKey) async {
    try {
      // Try to get valid cached data first
      final cachedData = await _cacheService.getCachedData<T>(cacheKey);
      if (cachedData != null) {
        _showingCachedData = true;
        _setLoading(false);
        return cachedData;
      }

      // If no valid cache, try expired cache as fallback
      final fallbackData = await _cacheService.getCachedDataFallback<T>(cacheKey);
      if (fallbackData != null) {
        _showingCachedData = true;
        _setLoading(false);
        return fallbackData;
      }

      // No cached data available
      _setError(_isConnected 
        ? 'Failed to load data from server'
        : 'No offline data available. Please connect to the internet.');
      _setLoading(false);
      return null;
    } catch (e) {
      _setError('Failed to load cached data: $e');
      _setLoading(false);
      return null;
    }
  }

  /// Retry the last failed operation
  Future<void> retryLastOperation() async {
    if (_isLoading) return;
    
    _clearError();
    
    // Check connectivity first
    final isConnected = await _connectivityService.checkConnectivity();
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
    
    // Notify listeners that we're ready to retry
    // The actual retry logic should be implemented by the specific providers
    notifyListeners();
  }

  /// Force refresh data (bypass cache)
  Future<T?> forceRefreshData<T>({
    required String cacheKey,
    required Future<T> Function() dataLoader,
    required Future<void> Function(T data) cacheUpdater,
  }) async {
    if (!_isConnected) {
      _setError('Cannot refresh data while offline');
      return null;
    }

    _setLoading(true);
    _clearError();

    try {
      final data = await dataLoader();
      await cacheUpdater(data);
      _lastDataUpdate = DateTime.now();
      _showingCachedData = false;
      _setLoading(false);
      return data;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return null;
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _cacheService.getCacheStats();
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      await _cacheService.clearAllCache();
      _showingCachedData = false;
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear cache: $e');
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      await _cacheService.clearExpiredCache();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear expired cache: $e');
    }
  }

  /// Check if cached data exists for a key
  Future<bool> hasCachedData(String cacheKey) async {
    return await _cacheService.isCacheValid(cacheKey);
  }

  /// Get cache age for a key
  Future<double?> getCacheAge(String cacheKey) async {
    return await _cacheService.getCacheAge(cacheKey);
  }

  // Private helper methods

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkFailure) {
      return error.message;
    } else if (error is ServerFailure) {
      return error.message;
    } else if (error is CacheFailure) {
      return error.message;
    } else if (error is AuthFailure) {
      return 'Authentication required';
    } else {
      return 'An unexpected error occurred';
    }
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
}

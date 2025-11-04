import 'dart:convert';
import 'package:hive/hive.dart';
import '../errors/exceptions.dart';
import 'connectivity_service.dart';

/// Service for managing offline data caching
/// Provides intelligent caching with TTL (Time To Live) support
class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;
  OfflineCacheService._internal();

  static const String _cacheBoxName = 'offline_cache_box';
  static const String _metadataBoxName = 'cache_metadata_box';
  
  // Default cache durations in hours
  static const int _defaultTtlHours = 24;
  static const int _eventsTtlHours = 1;
  static const int _feedsTtlHours = 2;
  static const int _userDataTtlHours = 12;

  late Box _cacheBox;
  late Box _metadataBox;
  late ConnectivityService _connectivityService;

  /// Initialize the cache service
  Future<void> initialize() async {
    try {
      _cacheBox = await Hive.openBox(_cacheBoxName);
      _metadataBox = await Hive.openBox(_metadataBoxName);
      _connectivityService = ConnectivityService();
    } catch (e) {
      throw CacheException('Failed to initialize offline cache: $e');
    }
  }

  /// Cache data with TTL (Time To Live)
  Future<void> cacheData({
    required String key,
    required dynamic data,
    int? ttlHours,
  }) async {
    try {
      final ttl = ttlHours ?? _defaultTtlHours;
      final expiryTime = DateTime.now().add(Duration(hours: ttl));
      
      // Store the data
      await _cacheBox.put(key, jsonEncode(data));
      
      // Store metadata
      await _metadataBox.put(key, {
        'cachedAt': DateTime.now().toIso8601String(),
        'expiresAt': expiryTime.toIso8601String(),
        'ttlHours': ttl,
      });
    } catch (e) {
      throw CacheException('Failed to cache data for key "$key": $e');
    }
  }

  /// Get cached data if valid (not expired)
  Future<T?> getCachedData<T>(String key) async {
    try {
      // Check if we have the data
      if (!_cacheBox.containsKey(key)) {
        return null;
      }

      // Check metadata
      final metadata = _metadataBox.get(key);
      if (metadata == null) {
        // No metadata, remove invalid cache entry
        await _cacheBox.delete(key);
        return null;
      }

      // Check if expired
      final expiryTime = DateTime.parse(metadata['expiresAt']);
      if (DateTime.now().isAfter(expiryTime)) {
        // Expired, remove from cache
        await _cacheBox.delete(key);
        await _metadataBox.delete(key);
        return null;
      }

      // Get the data
      final cachedData = _cacheBox.get(key);
      if (cachedData == null) {
        return null;
      }

      return jsonDecode(cachedData) as T;
    } catch (e) {
      // If there's any error reading cache, return null
      return null;
    }
  }

  /// Get cached data even if expired (for offline fallback)
  Future<T?> getCachedDataFallback<T>(String key) async {
    try {
      if (!_cacheBox.containsKey(key)) {
        return null;
      }

      final cachedData = _cacheBox.get(key);
      if (cachedData == null) {
        return null;
      }

      return jsonDecode(cachedData) as T;
    } catch (e) {
      return null;
    }
  }

  /// Check if cached data exists and is valid
  Future<bool> isCacheValid(String key) async {
    try {
      if (!_cacheBox.containsKey(key) || !_metadataBox.containsKey(key)) {
        return false;
      }

      final metadata = _metadataBox.get(key);
      if (metadata == null) {
        return false;
      }

      final expiryTime = DateTime.parse(metadata['expiresAt']);
      return DateTime.now().isBefore(expiryTime);
    } catch (e) {
      return false;
    }
  }

  /// Get cache age in hours
  Future<double?> getCacheAge(String key) async {
    try {
      final metadata = _metadataBox.get(key);
      if (metadata == null) {
        return null;
      }

      final cachedAt = DateTime.parse(metadata['cachedAt']);
      final duration = DateTime.now().difference(cachedAt);
      return duration.inHours.toDouble() + (duration.inMinutes % 60) / 60.0;
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      await _cacheBox.clear();
      await _metadataBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final List<String> expiredKeys = [];
      
      for (final key in _metadataBox.keys) {
        final metadata = _metadataBox.get(key);
        if (metadata != null) {
          final expiryTime = DateTime.parse(metadata['expiresAt']);
          if (DateTime.now().isAfter(expiryTime)) {
            expiredKeys.add(key.toString());
          }
        }
      }

      // Remove expired entries
      for (final key in expiredKeys) {
        await _cacheBox.delete(key);
        await _metadataBox.delete(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear expired cache: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final totalEntries = _cacheBox.length;
      int validEntries = 0;
      int expiredEntries = 0;
      double totalSizeKB = 0;

      for (final key in _metadataBox.keys) {
        final metadata = _metadataBox.get(key);
        if (metadata != null) {
          final expiryTime = DateTime.parse(metadata['expiresAt']);
          if (DateTime.now().isAfter(expiryTime)) {
            expiredEntries++;
          } else {
            validEntries++;
          }
        }

        // Estimate size (rough approximation)
        final data = _cacheBox.get(key);
        if (data != null) {
          totalSizeKB += data.toString().length / 1024;
        }
      }

      return {
        'totalEntries': totalEntries,
        'validEntries': validEntries,
        'expiredEntries': expiredEntries,
        'estimatedSizeKB': totalSizeKB.round(),
        'isConnected': _connectivityService.isConnected,
      };
    } catch (e) {
      return {
        'error': 'Failed to get cache stats: $e',
        'isConnected': _connectivityService.isConnected,
      };
    }
  }

  // Specialized cache methods for different data types

  /// Cache user data
  Future<void> cacheUserData(String userId, Map<String, dynamic> userData) async {
    await cacheData(
      key: 'user_$userId',
      data: userData,
      ttlHours: _userDataTtlHours,
    );
  }

  /// Get cached user data
  Future<Map<String, dynamic>?> getCachedUserData(String userId) async {
    return await getCachedData<Map<String, dynamic>>('user_$userId');
  }

  /// Cache events data
  Future<void> cacheEvents(String userId, List<Map<String, dynamic>> events) async {
    await cacheData(
      key: 'events_$userId',
      data: events,
      ttlHours: _eventsTtlHours,
    );
  }

  /// Get cached events
  Future<List<Map<String, dynamic>>?> getCachedEvents(String userId) async {
    final data = await getCachedData<List<dynamic>>('events_$userId');
    return data?.cast<Map<String, dynamic>>();
  }

  /// Cache feed data
  Future<void> cacheFeedData(String feedType, List<Map<String, dynamic>> feedData) async {
    await cacheData(
      key: 'feed_$feedType',
      data: feedData,
      ttlHours: _feedsTtlHours,
    );
  }

  /// Get cached feed data
  Future<List<Map<String, dynamic>>?> getCachedFeedData(String feedType) async {
    final data = await getCachedData<List<dynamic>>('feed_$feedType');
    return data?.cast<Map<String, dynamic>>();
  }

  /// Cache timetable data
  Future<void> cacheTimetable(String userId, Map<String, dynamic> timetable) async {
    await cacheData(
      key: 'timetable_$userId',
      data: timetable,
      ttlHours: _eventsTtlHours,
    );
  }

  /// Get cached timetable
  Future<Map<String, dynamic>?> getCachedTimetable(String userId) async {
    return await getCachedData<Map<String, dynamic>>('timetable_$userId');
  }
}

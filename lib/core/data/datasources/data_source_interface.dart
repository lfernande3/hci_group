import '../../../features/events/data/models/event_model.dart';
import '../../../features/timetable/data/models/timetable_model.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/navigation/data/models/navbar_config_model.dart';

/// Abstract data source interface for future API integration
/// This interface defines the contract that both mock and real API data sources must implement
abstract class DataSourceInterface {
  // ===== User Data Methods =====
  
  /// Get user data by ID
  Future<UserModel> getUserById(String userId);
  
  /// Get logged-in user data
  Future<UserModel> getLoggedInUser();
  
  /// Get logged-out/guest user data
  Future<UserModel> getLoggedOutUser();
  
  /// Update user preferences
  Future<bool> updateUserPreferences(String userId, Map<String, dynamic> preferences);
  
  // ===== Timetable Data Methods =====
  
  /// Get user's timetable
  Future<TimetableModel> getTimetable(String userId);
  
  /// Get timetable for specific semester
  Future<TimetableModel> getTimetableForSemester(String userId, String semester, int year);
  
  /// Get events for user
  Future<List<EventModel>> getEvents(String userId);
  
  /// Get next upcoming event
  Future<EventModel?> getNextEvent(String userId);
  
  /// Get events for a specific date
  Future<List<EventModel>> getEventsForDate(String userId, DateTime date);
  
  /// Get events for date range
  Future<List<EventModel>> getEventsForRange(String userId, DateTime startDate, DateTime endDate);
  
  // ===== Academic Events Methods =====
  
  /// Get academic calendar events
  Future<List<EventModel>> getAcademicEvents();
  
  /// Get campus events
  Future<List<EventModel>> getCampusEvents();
  
  /// Get upcoming deadlines
  Future<List<EventModel>> getUpcomingDeadlines();
  
  // ===== Feeds Data Methods =====
  
  /// Get news feed
  Future<List<Map<String, dynamic>>> getNewsFeed({int? limit, int? offset});
  
  /// Get CAP activities
  Future<List<Map<String, dynamic>>> getCapActivities({int? limit, int? offset});
  
  /// Get CityUTube videos
  Future<List<Map<String, dynamic>>> getCityUTubeVideos({int? limit, int? offset});
  
  // ===== Navbar Configuration Methods =====
  
  /// Get navbar configuration for user
  Future<NavbarConfigModel> getNavbarConfig(String userId);
  
  /// Save navbar configuration
  Future<bool> saveNavbarConfig(NavbarConfigModel config);
  
  /// Get available navbar items
  Future<List<NavbarItemModel>> getAvailableNavbarItems();
  
  /// Reset navbar to default configuration
  Future<NavbarConfigModel> resetNavbarToDefault(String userId);
  
  // ===== Utility Methods =====
  
  /// Check connection status (for API implementations)
  Future<bool> checkConnection();
  
  /// Clear cached data
  Future<void> clearCache();
  
  /// Refresh all data from source
  Future<bool> refreshData();
}

/// Data source configuration class
class DataSourceConfig {
  final String baseUrl;
  final Map<String, String> headers;
  final int timeoutSeconds;
  final bool enableCaching;
  final bool enableOfflineMode;
  
  const DataSourceConfig({
    required this.baseUrl,
    this.headers = const {},
    this.timeoutSeconds = 30,
    this.enableCaching = true,
    this.enableOfflineMode = true,
  });
  
  /// Default configuration for mock data source
  factory DataSourceConfig.mock() {
    return const DataSourceConfig(
      baseUrl: 'mock://localhost',
      headers: {'Content-Type': 'application/json'},
      timeoutSeconds: 1,
      enableCaching: false,
      enableOfflineMode: true,
    );
  }
  
  /// Default configuration for API data source
  factory DataSourceConfig.api({required String apiBaseUrl}) {
    return DataSourceConfig(
      baseUrl: apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      timeoutSeconds: 30,
      enableCaching: true,
      enableOfflineMode: true,
    );
  }
}

/// Data source factory for creating appropriate data source implementations
class DataSourceFactory {
  /// Create a data source based on configuration
  static DataSourceInterface create({
    required DataSourceType type,
    DataSourceConfig? config,
  }) {
    switch (type) {
      case DataSourceType.mock:
        return MockDataSourceImpl(config: config ?? DataSourceConfig.mock());
      case DataSourceType.api:
        return ApiDataSourceImpl(config: config ?? DataSourceConfig.api(apiBaseUrl: 'https://api.cityu.edu.hk'));
      case DataSourceType.hybrid:
        return HybridDataSourceImpl(
          mockDataSource: MockDataSourceImpl(config: DataSourceConfig.mock()),
          apiDataSource: ApiDataSourceImpl(config: config ?? DataSourceConfig.api(apiBaseUrl: 'https://api.cityu.edu.hk')),
        );
    }
  }
}

/// Data source types
enum DataSourceType {
  mock,    // Use only mock data
  api,     // Use only API data  
  hybrid,  // Use API with mock fallback
}

/// Mock data source implementation (placeholder for actual implementation)
class MockDataSourceImpl implements DataSourceInterface {
  final DataSourceConfig config;
  
  MockDataSourceImpl({required this.config});
  
  @override
  Future<UserModel> getUserById(String userId) => throw UnimplementedError('Use MockDataSource class');
  
  @override
  Future<UserModel> getLoggedInUser() => throw UnimplementedError('Use MockDataSource class');
  
  @override
  Future<UserModel> getLoggedOutUser() => throw UnimplementedError('Use MockDataSource class');
  
  @override
  Future<bool> updateUserPreferences(String userId, Map<String, dynamic> preferences) => throw UnimplementedError();
  
  @override
  Future<TimetableModel> getTimetable(String userId) => throw UnimplementedError('Use MockDataSource class');
  
  @override
  Future<TimetableModel> getTimetableForSemester(String userId, String semester, int year) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEvents(String userId) => throw UnimplementedError();
  
  @override
  Future<EventModel?> getNextEvent(String userId) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEventsForDate(String userId, DateTime date) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEventsForRange(String userId, DateTime startDate, DateTime endDate) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getAcademicEvents() => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getCampusEvents() => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getUpcomingDeadlines() => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getNewsFeed({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getCapActivities({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getCityUTubeVideos({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<NavbarConfigModel> getNavbarConfig(String userId) => throw UnimplementedError();
  
  @override
  Future<bool> saveNavbarConfig(NavbarConfigModel config) => throw UnimplementedError();
  
  @override
  Future<List<NavbarItemModel>> getAvailableNavbarItems() => throw UnimplementedError();
  
  @override
  Future<NavbarConfigModel> resetNavbarToDefault(String userId) => throw UnimplementedError();
  
  @override
  Future<bool> checkConnection() async => true;
  
  @override
  Future<void> clearCache() async {}
  
  @override
  Future<bool> refreshData() async => true;
}

/// API data source implementation (placeholder for future implementation)
class ApiDataSourceImpl implements DataSourceInterface {
  final DataSourceConfig config;
  
  ApiDataSourceImpl({required this.config});
  
  @override
  Future<UserModel> getUserById(String userId) => throw UnimplementedError('API implementation not yet available');
  
  @override
  Future<UserModel> getLoggedInUser() => throw UnimplementedError('API implementation not yet available');
  
  @override
  Future<UserModel> getLoggedOutUser() => throw UnimplementedError('API implementation not yet available');
  
  @override
  Future<bool> updateUserPreferences(String userId, Map<String, dynamic> preferences) => throw UnimplementedError();
  
  @override
  Future<TimetableModel> getTimetable(String userId) => throw UnimplementedError();
  
  @override
  Future<TimetableModel> getTimetableForSemester(String userId, String semester, int year) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEvents(String userId) => throw UnimplementedError();
  
  @override
  Future<EventModel?> getNextEvent(String userId) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEventsForDate(String userId, DateTime date) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getEventsForRange(String userId, DateTime startDate, DateTime endDate) => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getAcademicEvents() => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getCampusEvents() => throw UnimplementedError();
  
  @override
  Future<List<EventModel>> getUpcomingDeadlines() => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getNewsFeed({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getCapActivities({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<List<Map<String, dynamic>>> getCityUTubeVideos({int? limit, int? offset}) => throw UnimplementedError();
  
  @override
  Future<NavbarConfigModel> getNavbarConfig(String userId) => throw UnimplementedError();
  
  @override
  Future<bool> saveNavbarConfig(NavbarConfigModel config) => throw UnimplementedError();
  
  @override
  Future<List<NavbarItemModel>> getAvailableNavbarItems() => throw UnimplementedError();
  
  @override
  Future<NavbarConfigModel> resetNavbarToDefault(String userId) => throw UnimplementedError();
  
  @override
  Future<bool> checkConnection() => throw UnimplementedError();
  
  @override
  Future<void> clearCache() => throw UnimplementedError();
  
  @override
  Future<bool> refreshData() => throw UnimplementedError();
}

/// Hybrid data source implementation (API with mock fallback)
class HybridDataSourceImpl implements DataSourceInterface {
  final DataSourceInterface mockDataSource;
  final DataSourceInterface apiDataSource;
  
  HybridDataSourceImpl({
    required this.mockDataSource,
    required this.apiDataSource,
  });
  
  Future<T> _executeWithFallback<T>(
    Future<T> Function() apiCall,
    Future<T> Function() mockCall,
  ) async {
    try {
      final isConnected = await apiDataSource.checkConnection();
      if (isConnected) {
        return await apiCall();
      } else {
        return await mockCall();
      }
    } catch (e) {
      // Fallback to mock data if API call fails
      return await mockCall();
    }
  }
  
  @override
  Future<UserModel> getUserById(String userId) => _executeWithFallback(
    () => apiDataSource.getUserById(userId),
    () => mockDataSource.getUserById(userId),
  );
  
  @override
  Future<UserModel> getLoggedInUser() => _executeWithFallback(
    () => apiDataSource.getLoggedInUser(),
    () => mockDataSource.getLoggedInUser(),
  );
  
  @override
  Future<UserModel> getLoggedOutUser() => _executeWithFallback(
    () => apiDataSource.getLoggedOutUser(),
    () => mockDataSource.getLoggedOutUser(),
  );
  
  @override
  Future<bool> updateUserPreferences(String userId, Map<String, dynamic> preferences) => _executeWithFallback(
    () => apiDataSource.updateUserPreferences(userId, preferences),
    () => mockDataSource.updateUserPreferences(userId, preferences),
  );
  
  @override
  Future<TimetableModel> getTimetable(String userId) => _executeWithFallback(
    () => apiDataSource.getTimetable(userId),
    () => mockDataSource.getTimetable(userId),
  );
  
  @override
  Future<TimetableModel> getTimetableForSemester(String userId, String semester, int year) => _executeWithFallback(
    () => apiDataSource.getTimetableForSemester(userId, semester, year),
    () => mockDataSource.getTimetableForSemester(userId, semester, year),
  );
  
  @override
  Future<List<EventModel>> getEvents(String userId) => _executeWithFallback(
    () => apiDataSource.getEvents(userId),
    () => mockDataSource.getEvents(userId),
  );
  
  @override
  Future<EventModel?> getNextEvent(String userId) => _executeWithFallback(
    () => apiDataSource.getNextEvent(userId),
    () => mockDataSource.getNextEvent(userId),
  );
  
  @override
  Future<List<EventModel>> getEventsForDate(String userId, DateTime date) => _executeWithFallback(
    () => apiDataSource.getEventsForDate(userId, date),
    () => mockDataSource.getEventsForDate(userId, date),
  );
  
  @override
  Future<List<EventModel>> getEventsForRange(String userId, DateTime startDate, DateTime endDate) => _executeWithFallback(
    () => apiDataSource.getEventsForRange(userId, startDate, endDate),
    () => mockDataSource.getEventsForRange(userId, startDate, endDate),
  );
  
  @override
  Future<List<EventModel>> getAcademicEvents() => _executeWithFallback(
    () => apiDataSource.getAcademicEvents(),
    () => mockDataSource.getAcademicEvents(),
  );
  
  @override
  Future<List<EventModel>> getCampusEvents() => _executeWithFallback(
    () => apiDataSource.getCampusEvents(),
    () => mockDataSource.getCampusEvents(),
  );
  
  @override
  Future<List<EventModel>> getUpcomingDeadlines() => _executeWithFallback(
    () => apiDataSource.getUpcomingDeadlines(),
    () => mockDataSource.getUpcomingDeadlines(),
  );
  
  @override
  Future<List<Map<String, dynamic>>> getNewsFeed({int? limit, int? offset}) => _executeWithFallback(
    () => apiDataSource.getNewsFeed(limit: limit, offset: offset),
    () => mockDataSource.getNewsFeed(limit: limit, offset: offset),
  );
  
  @override
  Future<List<Map<String, dynamic>>> getCapActivities({int? limit, int? offset}) => _executeWithFallback(
    () => apiDataSource.getCapActivities(limit: limit, offset: offset),
    () => mockDataSource.getCapActivities(limit: limit, offset: offset),
  );
  
  @override
  Future<List<Map<String, dynamic>>> getCityUTubeVideos({int? limit, int? offset}) => _executeWithFallback(
    () => apiDataSource.getCityUTubeVideos(limit: limit, offset: offset),
    () => mockDataSource.getCityUTubeVideos(limit: limit, offset: offset),
  );
  
  @override
  Future<NavbarConfigModel> getNavbarConfig(String userId) => _executeWithFallback(
    () => apiDataSource.getNavbarConfig(userId),
    () => mockDataSource.getNavbarConfig(userId),
  );
  
  @override
  Future<bool> saveNavbarConfig(NavbarConfigModel config) => _executeWithFallback(
    () => apiDataSource.saveNavbarConfig(config),
    () => mockDataSource.saveNavbarConfig(config),
  );
  
  @override
  Future<List<NavbarItemModel>> getAvailableNavbarItems() => _executeWithFallback(
    () => apiDataSource.getAvailableNavbarItems(),
    () => mockDataSource.getAvailableNavbarItems(),
  );
  
  @override
  Future<NavbarConfigModel> resetNavbarToDefault(String userId) => _executeWithFallback(
    () => apiDataSource.resetNavbarToDefault(userId),
    () => mockDataSource.resetNavbarToDefault(userId),
  );
  
  @override
  Future<bool> checkConnection() => apiDataSource.checkConnection();
  
  @override
  Future<void> clearCache() async {
    await apiDataSource.clearCache();
    await mockDataSource.clearCache();
  }
  
  @override
  Future<bool> refreshData() => _executeWithFallback(
    () => apiDataSource.refreshData(),
    () => mockDataSource.refreshData(),
  );
}

import '../models/event_model.dart';
import '../models/timetable_model.dart';
import '../models/user_model.dart';
import 'mock_json_data.dart';
import 'enhanced_mock_data_source.dart';

/// Mock data source for demo purposes
/// This class serves as a bridge between the old hardcoded data and new JSON-based data
class MockDataSource {
  /// Enhanced data source for JSON-based data loading
  final EnhancedMockDataSource _enhancedDataSource = EnhancedMockDataSource();
  /// Get mock events for user
  Future<List<EventModel>> getEvents(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return MockJsonData.events;
  }

  /// Get next upcoming event
  Future<EventModel?> getNextEvent(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    final now = DateTime.now();
    final upcomingEvents = MockJsonData.events
        .where((event) => event.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
  }

  /// Get events for a specific date
  Future<List<EventModel>> getEventsForDate(String userId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return MockJsonData.events.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Get events for date range
  Future<List<EventModel>> getEventsForRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return MockJsonData.events.where((event) {
      return event.startTime.isAfter(startDate) &&
          event.startTime.isBefore(endDate.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Get user's timetable
  Future<TimetableModel> getTimetable(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    return MockJsonData.getTimetable(userId);
  }

  /// Get timetable for specific semester
  Future<TimetableModel> getTimetableForSemester(
    String userId,
    String semester,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockJsonData.getTimetableForSemester(userId, semester, year);
  }

  /// Get academic calendar events
  Future<List<EventModel>> getAcademicEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockJsonData.academicEvents;
  }

  /// Get mock user data
  Future<UserModel> getMockUser() async {
    // Try to load from JSON first, fallback to hardcoded data
    try {
      return await _enhancedDataSource.getMockUserFromJson(loggedIn: true);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 200));
      return MockJsonData.mockUser;
    }
  }

  /// Get logged out user
  Future<UserModel> getLoggedOutUser() async {
    try {
      return await _enhancedDataSource.getMockUserFromJson(loggedIn: false);
    } catch (e) {
      return UserModel.loggedOut();
    }
  }

  /// Get news feed from JSON
  Future<List<Map<String, dynamic>>> getNewsFeed() async {
    try {
      return await _enhancedDataSource.getNewsFeedFromJson();
    } catch (e) {
      // Fallback to hardcoded data
      await Future.delayed(const Duration(milliseconds: 500));
      return MockJsonData.newsFeed;
    }
  }

  /// Get CAP activities from JSON
  Future<List<Map<String, dynamic>>> getCapActivities() async {
    try {
      return await _enhancedDataSource.getCapActivitiesFromJson();
    } catch (e) {
      // Fallback to hardcoded data
      await Future.delayed(const Duration(milliseconds: 500));
      return MockJsonData.capActivities;
    }
  }

  /// Get CityUTube videos from JSON
  Future<List<Map<String, dynamic>>> getCityUTubeVideos() async {
    try {
      return await _enhancedDataSource.getCityUTubeVideosFromJson();
    } catch (e) {
      // Fallback to hardcoded data
      await Future.delayed(const Duration(milliseconds: 500));
      return MockJsonData.cityuTubeVideos;
    }
  }
}

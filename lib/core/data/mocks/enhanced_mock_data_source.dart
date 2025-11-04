import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../features/events/data/models/event_model.dart';
import '../../../features/timetable/data/models/timetable_model.dart';
import '../../../features/auth/data/models/user_model.dart';

/// Enhanced mock data source with JSON file loading capability
/// This class provides both hardcoded data and JSON file loading for future API integration
class EnhancedMockDataSource {
  /// Cache for loaded JSON data
  static Map<String, dynamic>? _timetableData;
  static Map<String, dynamic>? _userData;
  static Map<String, dynamic>? _eventsData;
  static Map<String, dynamic>? _feedsData;

  /// Load timetable data from JSON file
  static Future<Map<String, dynamic>> _loadTimetableData() async {
    if (_timetableData != null) return _timetableData!;
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/mocks/timetable_mock.json');
      _timetableData = json.decode(jsonString) as Map<String, dynamic>;
      return _timetableData!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return {
        'timetable': {
          'id': 'timetable_fallback',
          'userId': 'user_123',
          'semester': 'Semester 1',
          'year': DateTime.now().year,
          'lastUpdated': DateTime.now().toIso8601String(),
          'events': []
        }
      };
    }
  }

  /// Load user data from JSON file
  static Future<Map<String, dynamic>> _loadUserData() async {
    if (_userData != null) return _userData!;
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/mocks/user_mock.json');
      _userData = json.decode(jsonString) as Map<String, dynamic>;
      return _userData!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      return {
        'loggedInUser': {
          'id': 'user_123',
          'email': 'fallback@student.cityu.edu.hk',
          'fullName': 'Fallback User',
          'studentId': '123456789',
          'isLoggedIn': true,
          'userType': 'student'
        }
      };
    }
  }

  /// Load events data from JSON file
  static Future<Map<String, dynamic>> _loadEventsData() async {
    if (_eventsData != null) return _eventsData!;
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/mocks/events_mock.json');
      _eventsData = json.decode(jsonString) as Map<String, dynamic>;
      return _eventsData!;
    } catch (e) {
      // Fallback to empty data if JSON loading fails
      return {
        'academicEvents': [],
        'campusEvents': [],
        'upcomingDeadlines': []
      };
    }
  }

  /// Load feeds data from JSON file
  static Future<Map<String, dynamic>> _loadFeedsData() async {
    if (_feedsData != null) return _feedsData!;
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/mocks/feeds_mock.json');
      _feedsData = json.decode(jsonString) as Map<String, dynamic>;
      return _feedsData!;
    } catch (e) {
      // Fallback to empty data if JSON loading fails
      return {
        'news': [],
        'cap': [],
        'cityutube': []
      };
    }
  }

  /// Get user's timetable from JSON
  Future<TimetableModel> getTimetableFromJson(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    final data = await _loadTimetableData();
    final timetableJson = data['timetable'] as Map<String, dynamic>;
    
    return TimetableModel.fromJson(timetableJson);
  }

  /// Get mock user from JSON
  Future<UserModel> getMockUserFromJson({bool loggedIn = true}) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
    
    final data = await _loadUserData();
    final userKey = loggedIn ? 'loggedInUser' : 'guestUser';
    final userJson = data[userKey] as Map<String, dynamic>;
    
    return UserModel.fromJson(userJson);
  }

  /// Get academic events from JSON
  Future<List<EventModel>> getAcademicEventsFromJson() async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    
    final data = await _loadEventsData();
    final eventsJson = data['academicEvents'] as List<dynamic>;
    
    return eventsJson
        .map((eventJson) => EventModel.fromJson(eventJson as Map<String, dynamic>))
        .toList();
  }

  /// Get campus events from JSON
  Future<List<EventModel>> getCampusEventsFromJson() async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    
    final data = await _loadEventsData();
    final eventsJson = data['campusEvents'] as List<dynamic>;
    
    return eventsJson
        .map((eventJson) => EventModel.fromJson(eventJson as Map<String, dynamic>))
        .toList();
  }

  /// Get upcoming deadlines from JSON
  Future<List<EventModel>> getUpcomingDeadlinesFromJson() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    final data = await _loadEventsData();
    final eventsJson = data['upcomingDeadlines'] as List<dynamic>;
    
    return eventsJson
        .map((eventJson) => EventModel.fromJson(eventJson as Map<String, dynamic>))
        .toList();
  }

  /// Get news feed from JSON
  Future<List<Map<String, dynamic>>> getNewsFeedFromJson() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    final data = await _loadFeedsData();
    final newsJson = data['news'] as List<dynamic>;
    
    return newsJson.cast<Map<String, dynamic>>();
  }

  /// Get CAP activities from JSON
  Future<List<Map<String, dynamic>>> getCapActivitiesFromJson() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    final data = await _loadFeedsData();
    final capJson = data['cap'] as List<dynamic>;
    
    return capJson.cast<Map<String, dynamic>>();
  }

  /// Get CityUTube videos from JSON
  Future<List<Map<String, dynamic>>> getCityUTubeVideosFromJson() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    final data = await _loadFeedsData();
    final videosJson = data['cityutube'] as List<dynamic>;
    
    return videosJson.cast<Map<String, dynamic>>();
  }

  /// Get next upcoming event from all sources
  Future<EventModel?> getNextEventFromJson(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    final now = DateTime.now();
    final allEvents = <EventModel>[];
    
    // Get timetable events
    final timetable = await getTimetableFromJson(userId);
    allEvents.addAll(timetable.events.cast<EventModel>());
    
    // Get academic events
    final academicEvents = await getAcademicEventsFromJson();
    allEvents.addAll(academicEvents);
    
    // Get upcoming deadlines
    final deadlines = await getUpcomingDeadlinesFromJson();
    allEvents.addAll(deadlines);
    
    // Filter future events and sort by start time
    final upcomingEvents = allEvents
        .where((event) => event.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
  }

  /// Clear all cached data (useful for testing or data refresh)
  static void clearCache() {
    _timetableData = null;
    _userData = null;
    _eventsData = null;
    _feedsData = null;
  }

  /// Check if data is loaded from cache
  static bool get isCacheLoaded {
    return _timetableData != null && 
           _userData != null && 
           _eventsData != null && 
           _feedsData != null;
  }
}

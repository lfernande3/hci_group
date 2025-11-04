import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/timetable_model.dart';

/// Remote data source for API calls
abstract class RemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  
  Future<List<EventModel>> getEvents(String userId);
  Future<EventModel?> getNextEvent(String userId);
  Future<TimetableModel> getTimetable(String userId);
  
  Future<List<EventModel>> getAcademicEvents();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        throw ServerException(
          'Login failed: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error during login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Logout failed: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error during logout: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/auth/me'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw ServerException(
          'Failed to get current user: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error getting current user: $e');
    }
  }

  @override
  Future<List<EventModel>> getEvents(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}?userId=$userId'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((eventJson) => EventModel.fromJson(eventJson)).toList();
      } else {
        throw ServerException(
          'Failed to get events: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error getting events: $e');
    }
  }

  @override
  Future<EventModel?> getNextEvent(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/next?userId=$userId'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data != null ? EventModel.fromJson(data) : null;
      } else if (response.statusCode == 404) {
        return null; // No upcoming events
      } else {
        throw ServerException(
          'Failed to get next event: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error getting next event: $e');
    }
  }

  @override
  Future<TimetableModel> getTimetable(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.timetableEndpoint}?userId=$userId'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TimetableModel.fromJson(data);
      } else {
        throw ServerException(
          'Failed to get timetable: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error getting timetable: $e');
    }
  }

  @override
  Future<List<EventModel>> getAcademicEvents() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/academic/calendar'),
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((eventJson) => EventModel.fromJson(eventJson)).toList();
      } else {
        throw ServerException(
          'Failed to get academic events: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error getting academic events: $e');
    }
  }
}

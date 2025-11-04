class ApiConstants {
  // Base URLs (for future API integration)
  static const String baseUrl = 'https://api.cityu.edu.hk';
  static const String authUrl = 'https://sso.cityu.edu.hk';
  
  // API endpoints (placeholder for future use)
  static const String loginEndpoint = '/auth/login';
  static const String timetableEndpoint = '/student/timetable';
  static const String eventsEndpoint = '/academic/events';
  static const String newsEndpoint = '/news';
  static const String capEndpoint = '/cap';
  
  // Request timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

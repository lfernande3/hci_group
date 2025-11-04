/// Input validation utilities
class AppValidators {
  /// Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
  
  /// CityU email validation
  static bool isValidCityUEmail(String email) {
    return email.toLowerCase().endsWith('@cityu.edu.hk') ||
           email.toLowerCase().endsWith('@student.cityu.edu.hk');
  }
  
  /// Student ID validation (assuming 9-digit format)
  static bool isValidStudentId(String studentId) {
    return RegExp(r'^\d{9}$').hasMatch(studentId);
  }
  
  /// Phone number validation (basic)
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{8,15}$').hasMatch(phone);
  }
  
  /// Required field validation
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  /// Email field validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  /// CityU email field validation
  static String? validateCityUEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CityU email is required';
    }
    if (!isValidCityUEmail(value)) {
      return 'Please enter a valid CityU email address';
    }
    return null;
  }
  
  /// Student ID field validation
  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Student ID is required';
    }
    if (!isValidStudentId(value)) {
      return 'Please enter a valid 9-digit Student ID';
    }
    return null;
  }
}

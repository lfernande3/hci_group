/// Base class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => 'AppException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.statusCode]);
}

/// Cache/Storage-related exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, [super.statusCode]);
}

/// Data parsing exceptions
class DataException extends AppException {
  const DataException(super.message);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);
}

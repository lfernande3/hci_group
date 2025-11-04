import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.statusCode]);
}

/// Cache/Storage-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.statusCode]);
}

/// Data parsing failures
class DataFailure extends Failure {
  const DataFailure(super.message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

/// General application failures
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// User repository contract
abstract class UserRepository {
  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Login user with credentials
  Future<Either<Failure, User>> login(String email, String password);
  
  /// Logout current user
  Future<Either<Failure, void>> logout();
  
  /// Check if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();
  
  /// Update user profile
  Future<Either<Failure, User>> updateProfile(User user);
  
  /// Get user by ID
  Future<Either<Failure, User>> getUserById(String userId);
}

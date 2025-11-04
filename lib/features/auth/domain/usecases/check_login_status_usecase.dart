import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for checking user login status and managing authentication state
class CheckLoginStatusUseCase {
  final UserRepository repository;

  CheckLoginStatusUseCase(this.repository);

  /// Check if user is currently logged in
  Future<Either<Failure, bool>> call() async {
    return await repository.isLoggedIn();
  }

  /// Get current user if logged in
  Future<Either<Failure, User?>> getCurrentUser() async {
    final loginStatusResult = await repository.isLoggedIn();
    
    return loginStatusResult.fold(
      (failure) => Left(failure),
      (isLoggedIn) async {
        if (!isLoggedIn) {
          return const Right(null);
        }
        
        final userResult = await repository.getCurrentUser();
        return userResult.fold(
          (failure) => Left(failure),
          (user) => Right(user),
        );
      },
    );
  }

  /// Get user display info (name or "Log In")
  Future<Either<Failure, String>> getUserDisplayInfo() async {
    final userResult = await getCurrentUser();
    
    return userResult.fold(
      (failure) => Left(failure),
      (user) {
        if (user == null || !user.isLoggedIn) {
          return const Right('Log In');
        }
        return Right(user.fullName);
      },
    );
  }

  /// Check if user needs to log in
  Future<Either<Failure, bool>> needsLogin() async {
    final statusResult = await call();
    return statusResult.fold(
      (failure) => Left(failure),
      (isLoggedIn) => Right(!isLoggedIn),
    );
  }

  /// Get user authentication status with detailed information
  Future<Either<Failure, AuthenticationStatus>> getAuthenticationStatus() async {
    try {
      final loginResult = await repository.isLoggedIn();
      return loginResult.fold(
        (failure) => Left(failure),
        (isLoggedIn) async {
          if (!isLoggedIn) {
            return Right(AuthenticationStatus(
              isLoggedIn: false,
              user: null,
              displayName: 'Log In',
              authenticationLevel: AuthLevel.none,
              needsReauth: false,
            ));
          }

          final userResult = await repository.getCurrentUser();
          return userResult.fold(
            (failure) => Left(failure),
            (user) {
              final authLevel = _determineAuthLevel(user);
              final needsReauth = _checkIfReauthNeeded(user);
              
              return Right(AuthenticationStatus(
                isLoggedIn: true,
                user: user,
                displayName: user.fullName,
                authenticationLevel: authLevel,
                needsReauth: needsReauth,
              ));
            },
          );
        },
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to get authentication status: ${e.toString()}'));
    }
  }

  /// Validate current session
  Future<Either<Failure, bool>> validateSession() async {
    try {
      final authStatusResult = await getAuthenticationStatus();
      return authStatusResult.fold(
        (failure) => Left(failure),
        (status) {
          if (!status.isLoggedIn) {
            return const Right(false);
          }
          
          // Check if session is still valid
          if (status.needsReauth) {
            return const Right(false);
          }
          
          // Additional session validation logic
          final isValid = _validateSessionInternal(status);
          return Right(isValid);
        },
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to validate session: ${e.toString()}'));
    }
  }

  /// Get user permissions based on authentication status
  Future<Either<Failure, Set<UserPermission>>> getUserPermissions() async {
    final authStatusResult = await getAuthenticationStatus();
    return authStatusResult.fold(
      (failure) => Left(failure),
      (status) {
        if (!status.isLoggedIn || status.user == null) {
          return Right(_getGuestPermissions());
        }
        
        final permissions = _getPermissionsForUser(status.user!);
        return Right(permissions);
      },
    );
  }

  /// Check if user has specific permission
  Future<Either<Failure, bool>> hasPermission(UserPermission permission) async {
    final permissionsResult = await getUserPermissions();
    return permissionsResult.fold(
      (failure) => Left(failure),
      (permissions) => Right(permissions.contains(permission)),
    );
  }

  /// Get authentication level display text
  Future<Either<Failure, String>> getAuthLevelDisplay() async {
    final authStatusResult = await getAuthenticationStatus();
    return authStatusResult.fold(
      (failure) => Left(failure),
      (status) {
        final display = _getAuthLevelDisplayText(status.authenticationLevel);
        return Right(display);
      },
    );
  }

  /// Check if user can access specific feature
  Future<Either<Failure, bool>> canAccessFeature(String featureId) async {
    final authStatusResult = await getAuthenticationStatus();
    return authStatusResult.fold(
      (failure) => Left(failure),
      (status) {
        final canAccess = _checkFeatureAccess(featureId, status);
        return Right(canAccess);
      },
    );
  }

  /// Get user session info for debugging/logging
  Future<Either<Failure, Map<String, dynamic>>> getSessionInfo() async {
    final authStatusResult = await getAuthenticationStatus();
    return authStatusResult.fold(
      (failure) => Left(failure),
      (status) {
        final sessionInfo = {
          'isLoggedIn': status.isLoggedIn,
          'displayName': status.displayName,
          'userType': status.user?.userType.toString(),
          'authLevel': status.authenticationLevel.toString(),
          'needsReauth': status.needsReauth,
          'timestamp': DateTime.now().toIso8601String(),
        };
        return Right(sessionInfo);
      },
    );
  }

  /// Private helper: Determine authentication level
  AuthLevel _determineAuthLevel(User user) {
    switch (user.userType) {
      case UserType.student:
        return user.studentId != null && user.studentId!.isNotEmpty 
            ? AuthLevel.verified : AuthLevel.basic;
      case UserType.staff:
        return AuthLevel.elevated;
      case UserType.visitor:
        return AuthLevel.basic;
      case UserType.guest:
        return AuthLevel.none;
    }
  }

  /// Private helper: Check if reauthentication is needed
  bool _checkIfReauthNeeded(User user) {
    // Simulate session expiry logic
    // In a real app, this would check token expiry, last activity, etc.
    return false; // For demo purposes, always valid
  }

  /// Private helper: Validate session internally
  bool _validateSessionInternal(AuthenticationStatus status) {
    if (status.user == null) return false;
    
    // Additional validation logic
    final isEmailValid = status.user!.email.contains('@cityu.edu.hk');
    final hasValidId = status.user!.id.isNotEmpty;
    
    return isEmailValid && hasValidId;
  }

  /// Private helper: Get guest permissions
  Set<UserPermission> _getGuestPermissions() {
    return {
      UserPermission.viewPublicInfo,
      UserPermission.accessNews,
      UserPermission.viewCampusMap,
    };
  }

  /// Private helper: Get permissions for authenticated user
  Set<UserPermission> _getPermissionsForUser(User user) {
    final basePermissions = _getGuestPermissions();
    
    switch (user.userType) {
      case UserType.student:
        return {
          ...basePermissions,
          UserPermission.accessTimetable,
          UserPermission.viewGrades,
          UserPermission.accessStudentServices,
          UserPermission.customizeNavbar,
        };
      case UserType.staff:
        return {
          ...basePermissions,
          UserPermission.accessStaffServices,
          UserPermission.viewRoomAvailability,
          UserPermission.customizeNavbar,
          UserPermission.accessContacts,
        };
      case UserType.visitor:
        return {
          ...basePermissions,
          UserPermission.accessEmergencyInfo,
        };
      default:
        return basePermissions;
    }
  }

  /// Private helper: Get auth level display text
  String _getAuthLevelDisplayText(AuthLevel level) {
    switch (level) {
      case AuthLevel.none:
        return 'Not Authenticated';
      case AuthLevel.basic:
        return 'Basic Access';
      case AuthLevel.verified:
        return 'Verified User';
      case AuthLevel.elevated:
        return 'Staff Access';
    }
  }

  /// Private helper: Check feature access
  bool _checkFeatureAccess(String featureId, AuthenticationStatus status) {
    if (!status.isLoggedIn) {
      // Public features accessible to all
      const publicFeatures = ['news', 'campus_map', 'emergency', 'contacts'];
      return publicFeatures.contains(featureId);
    }
    
    // Authenticated user features
    const studentFeatures = ['timetable', 'grades', 'qr', 'chatbot'];
    const staffFeatures = ['room_availability', 'staff_services'];
    
    switch (status.user?.userType) {
      case UserType.student:
        return studentFeatures.contains(featureId);
      case UserType.staff:
        return [...studentFeatures, ...staffFeatures].contains(featureId);
      default:
        return false;
    }
  }
}

/// Authentication status information
class AuthenticationStatus {
  final bool isLoggedIn;
  final User? user;
  final String displayName;
  final AuthLevel authenticationLevel;
  final bool needsReauth;

  const AuthenticationStatus({
    required this.isLoggedIn,
    required this.user,
    required this.displayName,
    required this.authenticationLevel,
    required this.needsReauth,
  });
}

/// Authentication levels
enum AuthLevel {
  none,     // Not authenticated
  basic,    // Basic authentication
  verified, // Verified user (e.g., with student ID)
  elevated, // Staff/admin level
}

/// User permissions
enum UserPermission {
  viewPublicInfo,
  accessNews,
  viewCampusMap,
  accessTimetable,
  viewGrades,
  accessStudentServices,
  accessStaffServices,
  viewRoomAvailability,
  customizeNavbar,
  accessContacts,
  accessEmergencyInfo,
}

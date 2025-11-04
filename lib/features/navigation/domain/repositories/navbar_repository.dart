import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/navbar_config.dart';

/// Navbar configuration repository contract
abstract class NavbarRepository {
  /// Get current navbar configuration
  Future<Either<Failure, NavbarConfig>> getNavbarConfig();
  
  /// Update navbar configuration
  Future<Either<Failure, NavbarConfig>> updateNavbarConfig(NavbarConfig config);
  
  /// Reset to default navbar configuration
  Future<Either<Failure, NavbarConfig>> resetToDefault();
  
  /// Clear navbar configuration cache
  Future<Either<Failure, void>> clearNavbarConfig();
  
  /// Get available navbar items
  Future<Either<Failure, List<NavbarItem>>> getAvailableItems();
  
  /// Check if item can be added
  Future<Either<Failure, bool>> canAddItem(NavbarItem item);
}

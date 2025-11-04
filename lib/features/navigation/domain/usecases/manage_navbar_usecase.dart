import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/navbar_config.dart';
import '../repositories/navbar_repository.dart';

/// Use case for managing navbar configuration
class ManageNavbarUseCase {
  final NavbarRepository repository;

  ManageNavbarUseCase(this.repository);

  /// Get current navbar configuration
  Future<Either<Failure, NavbarConfig>> getCurrentConfig() async {
    return await repository.getNavbarConfig();
  }

  /// Update navbar configuration with validation
  Future<Either<Failure, NavbarConfig>> updateConfig(NavbarConfig config) async {
    // Validate configuration before updating
    final validationResult = _validateConfig(config);
    if (validationResult != null) {
      return Left(GeneralFailure(validationResult));
    }
    
    return await repository.updateNavbarConfig(config);
  }

  /// Add item to navbar with business logic validation
  Future<Either<Failure, NavbarConfig>> addItem(NavbarItem item) async {
    final configResult = await repository.getNavbarConfig();
    return configResult.fold(
      (failure) => Left(failure),
      (config) async {
        // Business rule: Maximum 5 items
        if (!config.canAddMore) {
          return Left(const GeneralFailure('Cannot add more items to navbar (maximum 5 items)'));
        }
        
        // Business rule: No duplicate items
        if (config.items.any((existingItem) => existingItem.id == item.id)) {
          return Left(const GeneralFailure('Item already exists in navbar'));
        }
        
        // Business rule: Check if item type is valid
        if (!_isValidNavbarItem(item)) {
          return Left(const GeneralFailure('Invalid navbar item type'));
        }
        
        final canAddResult = await repository.canAddItem(item);
        return canAddResult.fold(
          (failure) => Left(failure),
          (canAdd) async {
            if (!canAdd) {
              return Left(const GeneralFailure('Item cannot be added to navbar'));
            }
            
            final newConfig = config.addItem(item);
            return await repository.updateNavbarConfig(newConfig);
          },
        );
      },
    );
  }

  /// Remove item from navbar with validation
  Future<Either<Failure, NavbarConfig>> removeItem(String itemId) async {
    final configResult = await repository.getNavbarConfig();
    return configResult.fold(
      (failure) => Left(failure),
      (config) async {
        // Business rule: Minimum 1 item required
        if (config.items.length <= 1) {
          return Left(const GeneralFailure('Cannot remove item - at least one navbar item is required'));
        }
        
        // Check if item exists
        if (!config.items.any((item) => item.id == itemId)) {
          return Left(const GeneralFailure('Item not found in navbar'));
        }
        
        final newConfig = config.removeItem(itemId);
        return await repository.updateNavbarConfig(newConfig);
      },
    );
  }

  /// Reorder navbar items with validation
  Future<Either<Failure, NavbarConfig>> reorderItems(List<NavbarItem> newOrder) async {
    final configResult = await repository.getNavbarConfig();
    return configResult.fold(
      (failure) => Left(failure),
      (config) async {
        // Business rule: Must contain same items, just reordered
        if (newOrder.length != config.items.length) {
          return Left(const GeneralFailure('Reorder must contain same number of items'));
        }
        
        // Verify all original items are present
        for (final originalItem in config.items) {
          if (!newOrder.any((item) => item.id == originalItem.id)) {
            return Left(const GeneralFailure('All original items must be present in reorder'));
          }
        }
        
        // Business rule: Maximum 5 items
        if (newOrder.length > 5) {
          return Left(const GeneralFailure('Cannot have more than 5 navbar items'));
        }
        
        final newConfig = config.reorderItems(newOrder);
        return await repository.updateNavbarConfig(newConfig);
      },
    );
  }

  /// Reset to default configuration
  Future<Either<Failure, NavbarConfig>> resetToDefault() async {
    return await repository.resetToDefault();
  }

  /// Clear navbar configuration cache
  Future<Either<Failure, void>> clearNavbarConfig() async {
    return await repository.clearNavbarConfig();
  }

  /// Get available navbar items with filtering
  Future<Either<Failure, List<NavbarItem>>> getAvailableItems() async {
    final availableResult = await repository.getAvailableItems();
    return availableResult.fold(
      (failure) => Left(failure),
      (items) async {
        final configResult = await repository.getNavbarConfig();
        return configResult.fold(
          (failure) => Right(items), // Return all items if config fails
          (config) {
            // Filter out items that are already in the navbar
            final availableItems = items.where((item) =>
                !config.items.any((configItem) => configItem.id == item.id)
            ).toList();
            
            // Sort by priority/importance
            availableItems.sort((a, b) => _getItemPriority(a).compareTo(_getItemPriority(b)));
            
            return Right(availableItems);
          },
        );
      },
    );
  }

  /// Get navbar items sorted by usage frequency (simulated)
  Future<Either<Failure, List<NavbarItem>>> getItemsByUsage() async {
    final configResult = await repository.getNavbarConfig();
    return configResult.fold(
      (failure) => Left(failure),
      (config) {
        final sortedItems = [...config.items];
        
        // Sort by simulated usage priority
        sortedItems.sort((a, b) => _getUsagePriority(a).compareTo(_getUsagePriority(b)));
        
        return Right(sortedItems);
      },
    );
  }

  /// Validate if the navbar configuration is valid
  Future<Either<Failure, bool>> validateConfig(NavbarConfig config) async {
    final validationError = _validateConfig(config);
    if (validationError != null) {
      return Left(GeneralFailure(validationError));
    }
    return const Right(true);
  }

  /// Suggest optimal navbar configuration based on user type
  Future<Either<Failure, NavbarConfig>> suggestOptimalConfig(String userType) async {
    try {
      final availableResult = await repository.getAvailableItems();
      return availableResult.fold(
        (failure) => Left(failure),
        (availableItems) {
          final suggestedItems = _getSuggestedItemsForUserType(userType, availableItems);
          final suggestedConfig = NavbarConfig(
            items: suggestedItems.take(5).toList(), // Max 5 items
          );
          
          return Right(suggestedConfig);
        },
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to suggest optimal config: $e'));
    }
  }

  /// Private helper: Validate navbar configuration
  String? _validateConfig(NavbarConfig config) {
    if (config.items.isEmpty) {
      return 'Navbar must have at least one item';
    }
    
    if (config.items.length > 5) {
      return 'Navbar cannot have more than 5 items';
    }
    
    // Check for duplicates
    final ids = config.items.map((item) => item.id).toList();
    if (ids.toSet().length != ids.length) {
      return 'Navbar cannot have duplicate items';
    }
    
    // Validate each item
    for (final item in config.items) {
      if (!_isValidNavbarItem(item)) {
        return 'Invalid navbar item: ${item.label}';
      }
    }
    
    return null; // Valid
  }

  /// Private helper: Check if navbar item is valid
  bool _isValidNavbarItem(NavbarItem item) {
    // Valid navbar item types
    const validTypes = [
      'homepage', 'timetable', 'qr', 'chatbot', 'settings', 'account',
      'campus_map', 'room_availability', 'academic_calendar',
      'authenticator', 'sports_facilities', 'contacts', 'emergency',
      'news', 'cap'
    ];
    
    return validTypes.contains(item.id) && 
           item.label.isNotEmpty;
  }

  /// Private helper: Get item priority for sorting
  int _getItemPriority(NavbarItem item) {
    const priorityMap = {
      'timetable': 1,
      'qr': 2,
      'account': 3,
      'chatbot': 4,
      'settings': 5,
      'campus_map': 6,
      'room_availability': 7,
      'academic_calendar': 8,
      'authenticator': 9,
      'contacts': 10,
      'emergency': 11,
      'sports_facilities': 12,
      'news': 13,
      'cap': 14,
    };
    
    return priorityMap[item.id] ?? 99;
  }

  /// Private helper: Get usage priority (simulated)
  int _getUsagePriority(NavbarItem item) {
    // Simulate usage-based priority
    const usageMap = {
      'timetable': 1,
      'qr': 2,
      'chatbot': 3,
      'account': 4,
      'campus_map': 5,
      'settings': 6,
      'room_availability': 7,
      'contacts': 8,
      'academic_calendar': 9,
      'emergency': 10,
      'authenticator': 11,
      'sports_facilities': 12,
      'news': 13,
      'cap': 14,
    };
    
    return usageMap[item.id] ?? 99;
  }

  /// Private helper: Get suggested items for user type
  List<NavbarItem> _getSuggestedItemsForUserType(String userType, List<NavbarItem> availableItems) {
    switch (userType.toLowerCase()) {
      case 'student':
        return availableItems.where((item) => 
          ['timetable', 'qr', 'chatbot', 'campus-map', 'account'].contains(item.id)
        ).toList();
      case 'staff':
        return availableItems.where((item) => 
          ['account', 'contacts', 'room-availability', 'campus-map', 'settings'].contains(item.id)
        ).toList();
      case 'visitor':
        return availableItems.where((item) => 
          ['campus-map', 'contacts', 'emergency', 'news', 'qr'].contains(item.id)
        ).toList();
      default:
        return availableItems.take(5).toList();
    }
  }
}

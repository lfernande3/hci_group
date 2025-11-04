import 'package:flutter/foundation.dart';
import '../../domain/entities/navbar_config.dart';
import '../../domain/usecases/manage_navbar_usecase.dart';

/// Navigation state provider for bottom navbar
class NavigationProvider extends ChangeNotifier {
  final ManageNavbarUseCase manageNavbarUseCase;

  NavigationProvider({required this.manageNavbarUseCase});

  NavbarConfig _config = NavbarConfig.defaultConfig();
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  NavbarConfig get config => _config;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NavbarItem> get items => _config.items;

  /// Initialize navigation configuration
  Future<void> initialize() async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.getCurrentConfig();
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Update current index
  void setCurrentIndex(int index) {
    if (index >= 0 && index < _config.items.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Get current route
  String get currentRoute {
    if (_currentIndex < _config.items.length) {
      return _config.items[_currentIndex].route;
    }
    return '/';
  }

  /// Update navbar configuration
  Future<void> updateConfig(NavbarConfig newConfig) async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.updateConfig(newConfig);
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Add item to navbar
  Future<void> addItem(NavbarItem item) async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.addItem(item);
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Remove item from navbar
  Future<void> removeItem(String itemId) async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.removeItem(itemId);
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Reorder navbar items
  Future<void> reorderItems(List<NavbarItem> newOrder) async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.reorderItems(newOrder);
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.resetToDefault();
    result.fold(
      (failure) => _setError(failure.message),
      (config) => _setConfig(config),
    );
    
    _setLoading(false);
  }

  /// Clear navbar configuration cache
  Future<void> clearNavbarConfig() async {
    _setLoading(true);
    
    final result = await manageNavbarUseCase.clearNavbarConfig();
    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        // After clearing cache, reinitialize with default config
        initialize();
      },
    );
    
    _setLoading(false);
  }

  /// Get available navbar items
  Future<List<NavbarItem>> getAvailableItems() async {
    final result = await manageNavbarUseCase.getAvailableItems();
    return result.fold(
      (failure) => <NavbarItem>[],
      (items) => items,
    );
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setConfig(NavbarConfig config) {
    _config = config;
    _error = null;
    
    // Ensure current index is valid
    if (_currentIndex >= _config.items.length) {
      _currentIndex = 0;
    }
    
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
}

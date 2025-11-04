import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Theme state provider with Hive persistence
class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme';
  static const String _themeModeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;
  late Box _box;

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  
  /// Check if dark mode is active
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  /// Initialize theme from Hive storage
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // Initialize Hive box
      _box = await Hive.openBox(_themeBoxName);
      
      // Load theme mode from Hive
      final storedThemeMode = _box.get(_themeModeKey, defaultValue: 'system');
      _themeMode = _parseThemeMode(storedThemeMode);
    } catch (e) {
      // Handle error silently, fallback to system theme
      _themeMode = ThemeMode.system;
    }
    
    _setLoading(false);
  }

  /// Set theme mode and persist to Hive
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      
      // Save to Hive
      await _saveThemeMode(mode);
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Get theme mode name for display
  String get themeModeDisplayName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Save theme mode to Hive
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final themeModeString = _themeModeToString(mode);
      await _box.put(_themeModeKey, themeModeString);
    } catch (e) {
      // Handle error silently
      if (kDebugMode) {
        print('Error saving theme mode: $e');
      }
    }
  }

  /// Convert ThemeMode to string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parse ThemeMode from string
  ThemeMode _parseThemeMode(String? modeString) {
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

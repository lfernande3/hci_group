import 'package:hive/hive.dart';
import '../../constants/app_constants.dart';
import '../../errors/exceptions.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/timetable/data/models/timetable_model.dart';
import '../../../features/navigation/data/models/navbar_config_model.dart';

/// Local data source using Hive for storage
abstract class LocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  
  Future<TimetableModel?> getCachedTimetable(String userId);
  Future<void> cacheTimetable(TimetableModel timetable);
  
  Future<NavbarConfigModel> getNavbarConfig();
  Future<void> setNavbarConfig(NavbarConfigModel config);
  Future<void> clearNavbarConfig();
  
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
  
  Future<String> getThemeMode();
  Future<void> setThemeMode(String themeMode);
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String _userBoxName = 'user_box';
  static const String _timetableBoxName = 'timetable_box';
  static const String _settingsBoxName = 'settings_box';

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final box = await Hive.openBox(_userBoxName);
      final userData = box.get(AppConstants.userDataKey);
      
      if (userData == null) {
        return UserModel.loggedOut();
      }
      
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final box = await Hive.openBox(_userBoxName);
      await box.put(AppConstants.userDataKey, user.toJson());
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      final box = await Hive.openBox(_userBoxName);
      await box.delete(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException('Failed to clear user: $e');
    }
  }

  @override
  Future<TimetableModel?> getCachedTimetable(String userId) async {
    try {
      final box = await Hive.openBox(_timetableBoxName);
      final timetableData = box.get('timetable_$userId');
      
      if (timetableData == null) {
        return null;
      }
      
      return TimetableModel.fromJson(Map<String, dynamic>.from(timetableData));
    } catch (e) {
      throw CacheException('Failed to get cached timetable: $e');
    }
  }

  @override
  Future<void> cacheTimetable(TimetableModel timetable) async {
    try {
      final box = await Hive.openBox(_timetableBoxName);
      await box.put('timetable_${timetable.userId}', timetable.toJson());
    } catch (e) {
      throw CacheException('Failed to cache timetable: $e');
    }
  }

  @override
  Future<NavbarConfigModel> getNavbarConfig() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      final configData = box.get(AppConstants.navbarConfigKey);
      
      if (configData == null) {
        return NavbarConfigModel.defaultConfig();
      }
      
      return NavbarConfigModel.fromJson(Map<String, dynamic>.from(configData));
    } catch (e) {
      throw CacheException('Failed to get navbar config: $e');
    }
  }

  @override
  Future<void> setNavbarConfig(NavbarConfigModel config) async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      await box.put(AppConstants.navbarConfigKey, config.toJson());
    } catch (e) {
      throw CacheException('Failed to set navbar config: $e');
    }
  }

  @override
  Future<void> clearNavbarConfig() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      await box.delete(AppConstants.navbarConfigKey);
    } catch (e) {
      throw CacheException('Failed to clear navbar config: $e');
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      return box.get(AppConstants.onboardingKey, defaultValue: false);
    } catch (e) {
      throw CacheException('Failed to check onboarding status: $e');
    }
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      await box.put(AppConstants.onboardingKey, completed);
    } catch (e) {
      throw CacheException('Failed to set onboarding status: $e');
    }
  }

  @override
  Future<String> getThemeMode() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      return box.get(AppConstants.themeKey, defaultValue: 'system');
    } catch (e) {
      throw CacheException('Failed to get theme mode: $e');
    }
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      await box.put(AppConstants.themeKey, themeMode);
    } catch (e) {
      throw CacheException('Failed to set theme mode: $e');
    }
  }
}

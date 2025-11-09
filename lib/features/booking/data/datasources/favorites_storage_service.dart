import 'package:hive/hive.dart';

/// Service for managing favorite rooms storage using Hive
class FavoritesStorageService {
  static const String _favoritesBoxName = 'favorite_rooms_box';
  static const String _favoritesListKey = 'favorite_room_ids';
  
  /// Add a room to favorites
  Future<void> addFavorite(String roomId) async {
    try {
      final box = await Hive.openBox(_favoritesBoxName);
      final favorites = await getFavorites();
      
      if (!favorites.contains(roomId)) {
        favorites.add(roomId);
        await box.put(_favoritesListKey, favorites);
      }
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  /// Remove a room from favorites
  Future<void> removeFavorite(String roomId) async {
    try {
      final box = await Hive.openBox(_favoritesBoxName);
      final favorites = await getFavorites();
      
      favorites.remove(roomId);
      await box.put(_favoritesListKey, favorites);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  /// Check if a room is favorited
  Future<bool> isFavorite(String roomId) async {
    try {
      final favorites = await getFavorites();
      return favorites.contains(roomId);
    } catch (e) {
      return false;
    }
  }

  /// Get all favorite room IDs
  Future<List<String>> getFavorites() async {
    try {
      final box = await Hive.openBox(_favoritesBoxName);
      final data = box.get(_favoritesListKey);
      
      if (data == null) return [];
      
      // Handle both List<dynamic> and List<String>
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String roomId) async {
    try {
      final isFav = await isFavorite(roomId);
      if (isFav) {
        await removeFavorite(roomId);
        return false;
      } else {
        await addFavorite(roomId);
        return true;
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      final box = await Hive.openBox(_favoritesBoxName);
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }
}


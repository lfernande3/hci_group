import 'package:hive/hive.dart';
import '../models/saved_booking_model.dart';

/// Service for managing persistent booking storage using Hive
class BookingStorageService {
  static const String _bookingsBoxName = 'bookings_box';
  
  /// Save a booking to local storage
  Future<void> saveBooking(SavedBookingModel booking) async {
    try {
      final box = await Hive.openBox(_bookingsBoxName);
      await box.put(booking.id, booking.toJson());
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  /// Get all saved bookings
  Future<List<SavedBookingModel>> getAllBookings() async {
    try {
      final box = await Hive.openBox(_bookingsBoxName);
      final List<SavedBookingModel> bookings = [];
      
      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          bookings.add(SavedBookingModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }
      
      // Sort by start time (newest first)
      bookings.sort((a, b) => b.startTime.compareTo(a.startTime));
      
      return bookings;
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }

  /// Get upcoming bookings (future bookings)
  Future<List<SavedBookingModel>> getUpcomingBookings() async {
    try {
      final allBookings = await getAllBookings();
      return allBookings.where((booking) => booking.isUpcoming).toList();
    } catch (e) {
      throw Exception('Failed to get upcoming bookings: $e');
    }
  }

  /// Get past bookings
  Future<List<SavedBookingModel>> getPastBookings() async {
    try {
      final allBookings = await getAllBookings();
      return allBookings.where((booking) => booking.isPast).toList();
    } catch (e) {
      throw Exception('Failed to get past bookings: $e');
    }
  }

  /// Get a specific booking by ID
  Future<SavedBookingModel?> getBooking(String id) async {
    try {
      final box = await Hive.openBox(_bookingsBoxName);
      final data = box.get(id);
      
      if (data == null) return null;
      
      return SavedBookingModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  /// Delete a booking
  Future<void> deleteBooking(String id) async {
    try {
      final box = await Hive.openBox(_bookingsBoxName);
      await box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  /// Clear all bookings
  Future<void> clearAllBookings() async {
    try {
      final box = await Hive.openBox(_bookingsBoxName);
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear bookings: $e');
    }
  }

  /// Get count of upcoming bookings
  Future<int> getUpcomingBookingsCount() async {
    try {
      final upcoming = await getUpcomingBookings();
      return upcoming.length;
    } catch (e) {
      return 0;
    }
  }
}


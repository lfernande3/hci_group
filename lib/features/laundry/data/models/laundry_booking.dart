// Laundry Booking model for demo

enum BookingStatus { upcoming, active, completed, cancelled }

class LaundryBooking {
  final String id;
  final String stackId;
  final String stackLabel;
  final String roomId;
  final String roomName;
  final String machineType; // "Washer" or "Dryer"
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final String userId; // Demo user ID
  final DateTime createdAt;

  const LaundryBooking({
    required this.id,
    required this.stackId,
    required this.stackLabel,
    required this.roomId,
    required this.roomName,
    required this.machineType,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  Duration get duration => endTime.difference(startTime);
  
  String get durationText {
    final minutes = duration.inMinutes;
    return '${minutes}min';
  }

  String get statusDescription {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get canCancel {
    return status == BookingStatus.upcoming && 
           startTime.isAfter(DateTime.now().add(const Duration(minutes: 10)));
  }
}

/// Booking time slot for selection
class TimeSlot {
  final DateTime start;
  final DateTime end;
  final bool isAvailable;
  final String? bookedBy; // User ID if booked

  const TimeSlot({
    required this.start,
    required this.end,
    required this.isAvailable,
    this.bookedBy,
  });

  Duration get duration => end.difference(start);
  
  String get timeRangeText {
    final startText = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endText = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startText - $endText';
  }
}

/// Booking manager for demo purposes
class LaundryBookingManager {
  static final LaundryBookingManager _instance = LaundryBookingManager._internal();
  factory LaundryBookingManager() => _instance;
  LaundryBookingManager._internal();

  final List<LaundryBooking> _bookings = [];
  final List<Function()> _listeners = [];

  List<LaundryBooking> get bookings => List.unmodifiable(_bookings);
  
  List<LaundryBooking> getUserBookings(String userId) {
    return _bookings.where((booking) => booking.userId == userId).toList();
  }

  List<LaundryBooking> getActiveBookings() {
    return _bookings.where((booking) => 
      booking.status == BookingStatus.active ||
      booking.status == BookingStatus.upcoming
    ).toList();
  }

  void addBooking(LaundryBooking booking) {
    _bookings.add(booking);
    _notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final booking = _bookings[index];
      if (booking.canCancel) {
        _bookings[index] = LaundryBooking(
          id: booking.id,
          stackId: booking.stackId,
          stackLabel: booking.stackLabel,
          roomId: booking.roomId,
          roomName: booking.roomName,
          machineType: booking.machineType,
          startTime: booking.startTime,
          endTime: booking.endTime,
          status: BookingStatus.cancelled,
          userId: booking.userId,
          createdAt: booking.createdAt,
        );
        _notifyListeners();
      }
    }
  }

  List<TimeSlot> getAvailableTimeSlots(String stackId, String machineType, DateTime date) {
    final slots = <TimeSlot>[];
    final startOfDay = DateTime(date.year, date.month, date.day, 6, 0); // 6 AM
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 0); // 11 PM
    
    // Generate 30-minute slots
    for (var time = startOfDay; time.isBefore(endOfDay); time = time.add(const Duration(minutes: 30))) {
      final slotEnd = time.add(const Duration(minutes: 30));
      
      // Check if this slot is booked
      final isBooked = _bookings.any((booking) =>
        booking.stackId == stackId &&
        booking.machineType == machineType &&
        booking.status != BookingStatus.cancelled &&
        booking.status != BookingStatus.completed &&
        booking.startTime.isBefore(slotEnd) &&
        booking.endTime.isAfter(time)
      );
      
      slots.add(TimeSlot(
        start: time,
        end: slotEnd,
        isAvailable: !isBooked,
        bookedBy: isBooked ? 'demo_user' : null,
      ));
    }
    
    return slots;
  }

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

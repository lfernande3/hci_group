import '../../../../core/utils/date_time_formatter.dart';

/// Model for a saved booking (persisted locally)
class SavedBookingModel {
  final String id;
  final String roomId;
  final String roomName;
  final String roomLocation;
  final int roomCapacity;
  final String roomType; // 'study', 'classroom', 'sports', 'music'
  final DateTime bookingDate;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;

  const SavedBookingModel({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.roomLocation,
    required this.roomCapacity,
    required this.roomType,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  /// Convert to JSON for Hive storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'roomLocation': roomLocation,
      'roomCapacity': roomCapacity,
      'roomType': roomType,
      'bookingDate': bookingDate.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON (Hive retrieval)
  factory SavedBookingModel.fromJson(Map<String, dynamic> json) {
    return SavedBookingModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
      roomLocation: json['roomLocation'] as String,
      roomCapacity: json['roomCapacity'] as int,
      roomType: json['roomType'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Check if booking is in the past
  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  /// Check if booking is upcoming (future)
  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  /// Check if booking is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Get a formatted date string
  String get formattedDate {
    return DateTimeFormatter.formatDateWithMonth(bookingDate);
  }

  /// Get a formatted time range string
  String get formattedTimeRange {
    return DateTimeFormatter.formatTimeRange(startTime, endTime);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedBookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


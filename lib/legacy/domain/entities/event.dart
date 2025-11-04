import 'package:equatable/equatable.dart';

/// Academic event domain entity
class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String? room;
  final EventType type;
  final String? courseCode;
  final String? instructor;
  final bool isAllDay;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.room,
    required this.type,
    this.courseCode,
    this.instructor,
    this.isAllDay = false,
  });

  /// Get duration of the event
  Duration get duration => endTime.difference(startTime);

  /// Check if event is happening now
  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Check if event is upcoming (within next 24 hours)
  bool get isUpcoming {
    final now = DateTime.now();
    final twentyFourHoursFromNow = now.add(const Duration(hours: 24));
    return startTime.isAfter(now) && startTime.isBefore(twentyFourHoursFromNow);
  }

  /// Copy with new values
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? room,
    EventType? type,
    String? courseCode,
    String? instructor,
    bool? isAllDay,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      room: room ?? this.room,
      type: type ?? this.type,
      courseCode: courseCode ?? this.courseCode,
      instructor: instructor ?? this.instructor,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        location,
        room,
        type,
        courseCode,
        instructor,
        isAllDay,
      ];
}

/// Event type enumeration
enum EventType {
  lecture,
  tutorial,
  exam,
  assignment,
  meeting,
  event,
  deadline,
}

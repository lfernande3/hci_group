import 'package:equatable/equatable.dart';
import 'event.dart';

/// Timetable domain entity
class Timetable extends Equatable {
  final String id;
  final String userId;
  final String semester;
  final int year;
  final List<Event> events;
  final DateTime lastUpdated;

  const Timetable({
    required this.id,
    required this.userId,
    required this.semester,
    required this.year,
    required this.events,
    required this.lastUpdated,
  });

  /// Get events for a specific date
  List<Event> getEventsForDate(DateTime date) {
    return events.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Get next upcoming event
  Event? get nextEvent {
    final now = DateTime.now();
    final upcomingEvents = events
        .where((event) => event.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
  }

  /// Get events happening today
  List<Event> get todaysEvents => getEventsForDate(DateTime.now());

  /// Get events for this week
  List<Event> get thisWeeksEvents {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return events.where((event) {
      return event.startTime.isAfter(startOfWeek) &&
          event.startTime.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Copy with new values
  Timetable copyWith({
    String? id,
    String? userId,
    String? semester,
    int? year,
    List<Event>? events,
    DateTime? lastUpdated,
  }) {
    return Timetable(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      semester: semester ?? this.semester,
      year: year ?? this.year,
      events: events ?? this.events,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        semester,
        year,
        events,
        lastUpdated,
      ];
}

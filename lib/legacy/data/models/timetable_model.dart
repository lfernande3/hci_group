import '../../domain/entities/timetable.dart';
import '../../domain/entities/event.dart';
import 'event_model.dart';

/// Timetable data model for serialization/deserialization
class TimetableModel extends Timetable {
  const TimetableModel({
    required super.id,
    required super.userId,
    required super.semester,
    required super.year,
    required super.events,
    required super.lastUpdated,
  });

  /// Create from domain entity
  factory TimetableModel.fromEntity(Timetable timetable) {
    return TimetableModel(
      id: timetable.id,
      userId: timetable.userId,
      semester: timetable.semester,
      year: timetable.year,
      events: timetable.events,
      lastUpdated: timetable.lastUpdated,
    );
  }

  /// Create from JSON
  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'] as List<dynamic>? ?? [];
    final events = eventsJson
        .map((eventJson) => EventModel.fromJson(eventJson as Map<String, dynamic>))
        .toList();

    return TimetableModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      semester: json['semester'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      events: events,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'semester': semester,
      'year': year,
      'events': events.map((event) => EventModel.fromEntity(event).toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Timetable toEntity() {
    return Timetable(
      id: id,
      userId: userId,
      semester: semester,
      year: year,
      events: events,
      lastUpdated: lastUpdated,
    );
  }

  /// Copy with new values
  @override
  TimetableModel copyWith({
    String? id,
    String? userId,
    String? semester,
    int? year,
    List<Event>? events,
    DateTime? lastUpdated,
  }) {
    return TimetableModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      semester: semester ?? this.semester,
      year: year ?? this.year,
      events: events ?? this.events,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

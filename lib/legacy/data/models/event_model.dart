import '../../domain/entities/event.dart';

/// Event data model for serialization/deserialization
class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.location,
    super.room,
    required super.type,
    super.courseCode,
    super.instructor,
    super.isAllDay = false,
  });

  /// Create from domain entity
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      location: event.location,
      room: event.room,
      type: event.type,
      courseCode: event.courseCode,
      instructor: event.instructor,
      isAllDay: event.isAllDay,
    );
  }

  /// Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'] ?? '',
      room: json['room'],
      type: EventType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => EventType.event,
      ),
      courseCode: json['courseCode'],
      instructor: json['instructor'],
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'room': room,
      'type': type.name,
      'courseCode': courseCode,
      'instructor': instructor,
      'isAllDay': isAllDay,
    };
  }

  /// Convert to domain entity
  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      room: room,
      type: type,
      courseCode: courseCode,
      instructor: instructor,
      isAllDay: isAllDay,
    );
  }

  /// Copy with new values
  @override
  EventModel copyWith({
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
    return EventModel(
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
}

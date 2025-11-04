import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';

/// Event repository contract
abstract class EventRepository {
  /// Get all events for a user
  Future<Either<Failure, List<Event>>> getEvents(String userId);
  
  /// Get next upcoming event
  Future<Either<Failure, Event?>> getNextEvent(String userId);
  
  /// Get events for a specific date
  Future<Either<Failure, List<Event>>> getEventsForDate(String userId, DateTime date);
  
  /// Get events for date range
  Future<Either<Failure, List<Event>>> getEventsForRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Add new event
  Future<Either<Failure, Event>> addEvent(Event event);
  
  /// Update existing event
  Future<Either<Failure, Event>> updateEvent(Event event);
  
  /// Delete event
  Future<Either<Failure, void>> deleteEvent(String eventId);
  
  /// Get academic calendar events
  Future<Either<Failure, List<Event>>> getAcademicEvents();
}

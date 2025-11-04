import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';
import '../repositories/timetable_repository.dart';

/// Use case for getting the next upcoming event
class GetNextEventUseCase {
  final EventRepository eventRepository;
  final TimetableRepository timetableRepository;

  GetNextEventUseCase({
    required this.eventRepository,
    required this.timetableRepository,
  });

  /// Execute the use case - find next academic event
  Future<Either<Failure, Event?>> call(String userId) async {
    return await eventRepository.getNextEvent(userId);
  }

  /// Get next event with enhanced business logic
  /// This method filters and prioritizes events based on academic importance
  Future<Either<Failure, Event?>> getNextAcademicEvent(String userId) async {
    try {
      // Get all events from multiple sources
      final eventsResult = await eventRepository.getEvents(userId);
      final academicEventsResult = await eventRepository.getAcademicEvents();
      
      return eventsResult.fold(
        (failure) => Left(failure),
        (events) {
          return academicEventsResult.fold(
            (failure) => Left(failure),
            (academicEvents) {
              final now = DateTime.now();
              final allEvents = [...events, ...academicEvents];
              
              // Filter upcoming events
              final upcomingEvents = allEvents
                  .where((event) => event.startTime.isAfter(now))
                  .toList();
              
              if (upcomingEvents.isEmpty) {
                return const Right(null);
              }
              
              // Sort by priority and time
              upcomingEvents.sort((a, b) {
                // Priority order: exam > lecture > tutorial > event
                final aPriority = _getEventPriority(a);
                final bPriority = _getEventPriority(b);
                
                if (aPriority != bPriority) {
                  return aPriority.compareTo(bPriority);
                }
                
                // If same priority, sort by time
                return a.startTime.compareTo(b.startTime);
              });
              
              return Right(upcomingEvents.first);
            },
          );
        },
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to get next academic event: $e'));
    }
  }

  /// Get events for today with filtering
  Future<Either<Failure, List<Event>>> getTodayEvents(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await eventRepository.getEventsForRange(userId, startOfDay, endOfDay);
  }

  /// Get upcoming events in the next N days
  Future<Either<Failure, List<Event>>> getUpcomingEvents(
    String userId, {
    int days = 7,
  }) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    
    return await eventRepository.getEventsForRange(userId, now, endDate);
  }

  /// Priority helper for event sorting
  /// Lower numbers = higher priority
  int _getEventPriority(Event event) {
    switch (event.type) {
      case EventType.exam:
        return 1;
      case EventType.lecture:
        return 2;
      case EventType.tutorial:
        return 3;
      case EventType.event:
        return 4;
      default:
        return 5;
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/event.dart';

/// Use case for data filtering and sorting operations
class DataFilteringSortingUseCase {
  /// Filter events by type
  Either<Failure, List<Event>> filterEventsByType(
    List<Event> events,
    EventType type,
  ) {
    try {
      final filteredEvents = events
          .where((event) => event.type == type)
          .toList();
      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter events by type: $e'));
    }
  }

  /// Filter events by date range
  Either<Failure, List<Event>> filterEventsByDateRange(
    List<Event> events,
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      final filteredEvents = events.where((event) {
        return event.startTime.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
               event.startTime.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter events by date range: $e'));
    }
  }

  /// Filter events by location
  Either<Failure, List<Event>> filterEventsByLocation(
    List<Event> events,
    String location,
  ) {
    try {
      final filteredEvents = events
          .where((event) => event.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter events by location: $e'));
    }
  }

  /// Filter events by course code
  Either<Failure, List<Event>> filterEventsByCourse(
    List<Event> events,
    String courseCode,
  ) {
    try {
      final filteredEvents = events
          .where((event) => event.courseCode?.toLowerCase().contains(courseCode.toLowerCase()) ?? false)
          .toList();
      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter events by course: $e'));
    }
  }

  /// Filter upcoming events (future events only)
  Either<Failure, List<Event>> filterUpcomingEvents(List<Event> events) {
    try {
      final now = DateTime.now();
      final upcomingEvents = events
          .where((event) => event.startTime.isAfter(now))
          .toList();
      return Right(upcomingEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter upcoming events: $e'));
    }
  }

  /// Filter events by search query (title, description, location)
  Either<Failure, List<Event>> filterEventsBySearch(
    List<Event> events,
    String searchQuery,
  ) {
    try {
      if (searchQuery.trim().isEmpty) {
        return Right(events);
      }

      final query = searchQuery.toLowerCase();
      final filteredEvents = events.where((event) {
        final titleMatch = event.title.toLowerCase().contains(query);
        final descriptionMatch = event.description.toLowerCase().contains(query);
        final locationMatch = event.location.toLowerCase().contains(query);
        final courseMatch = event.courseCode?.toLowerCase().contains(query) ?? false;
        final instructorMatch = event.instructor?.toLowerCase().contains(query) ?? false;
        
        return titleMatch || descriptionMatch || locationMatch || courseMatch || instructorMatch;
      }).toList();
      
      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to filter events by search: $e'));
    }
  }

  /// Sort events by start time
  Either<Failure, List<Event>> sortEventsByTime(
    List<Event> events, {
    bool ascending = true,
  }) {
    try {
      final sortedEvents = [...events];
      sortedEvents.sort((a, b) {
        final comparison = a.startTime.compareTo(b.startTime);
        return ascending ? comparison : -comparison;
      });
      return Right(sortedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to sort events by time: $e'));
    }
  }

  /// Sort events by priority (exam > lecture > tutorial > event)
  Either<Failure, List<Event>> sortEventsByPriority(List<Event> events) {
    try {
      final sortedEvents = [...events];
      sortedEvents.sort((a, b) {
        final aPriority = _getEventTypePriority(a.type);
        final bPriority = _getEventTypePriority(b.type);
        
        if (aPriority != bPriority) {
          return aPriority.compareTo(bPriority);
        }
        
        // If same priority, sort by time
        return a.startTime.compareTo(b.startTime);
      });
      return Right(sortedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to sort events by priority: $e'));
    }
  }

  /// Sort events by location (alphabetical)
  Either<Failure, List<Event>> sortEventsByLocation(
    List<Event> events, {
    bool ascending = true,
  }) {
    try {
      final sortedEvents = [...events];
      sortedEvents.sort((a, b) {
        final aLocation = a.location;
        final bLocation = b.location;
        final comparison = aLocation.compareTo(bLocation);
        return ascending ? comparison : -comparison;
      });
      return Right(sortedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to sort events by location: $e'));
    }
  }

  /// Sort events by course code
  Either<Failure, List<Event>> sortEventsByCourse(
    List<Event> events, {
    bool ascending = true,
  }) {
    try {
      final sortedEvents = [...events];
      sortedEvents.sort((a, b) {
        final aCourse = a.courseCode ?? '';
        final bCourse = b.courseCode ?? '';
        final comparison = aCourse.compareTo(bCourse);
        return ascending ? comparison : -comparison;
      });
      return Right(sortedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to sort events by course: $e'));
    }
  }

  /// Group events by date
  Either<Failure, Map<DateTime, List<Event>>> groupEventsByDate(List<Event> events) {
    try {
      final groupedEvents = <DateTime, List<Event>>{};
      
      for (final event in events) {
        final eventDate = DateTime(
          event.startTime.year,
          event.startTime.month,
          event.startTime.day,
        );
        
        if (!groupedEvents.containsKey(eventDate)) {
          groupedEvents[eventDate] = [];
        }
        groupedEvents[eventDate]!.add(event);
      }
      
      // Sort events within each date group
      for (final dateKey in groupedEvents.keys) {
        groupedEvents[dateKey]!.sort((a, b) => a.startTime.compareTo(b.startTime));
      }
      
      return Right(groupedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to group events by date: $e'));
    }
  }

  /// Group events by type
  Either<Failure, Map<EventType, List<Event>>> groupEventsByType(List<Event> events) {
    try {
      final groupedEvents = <EventType, List<Event>>{};
      
      for (final event in events) {
        if (!groupedEvents.containsKey(event.type)) {
          groupedEvents[event.type] = [];
        }
        groupedEvents[event.type]!.add(event);
      }
      
      // Sort events within each type group by time
      for (final typeKey in groupedEvents.keys) {
        groupedEvents[typeKey]!.sort((a, b) => a.startTime.compareTo(b.startTime));
      }
      
      return Right(groupedEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to group events by type: $e'));
    }
  }

  /// Get events statistics
  Either<Failure, EventStatistics> getEventStatistics(List<Event> events) {
    try {
      final stats = EventStatistics(
        totalEvents: events.length,
        upcomingEvents: events.where((e) => e.startTime.isAfter(DateTime.now())).length,
        pastEvents: events.where((e) => e.startTime.isBefore(DateTime.now())).length,
        eventsByType: _countEventsByType(events),
        eventsThisWeek: _countEventsThisWeek(events),
        eventsToday: _countEventsToday(events),
      );
      return Right(stats);
    } catch (e) {
      return Left(GeneralFailure('Failed to get event statistics: $e'));
    }
  }

  /// Apply multiple filters and sorting
  Either<Failure, List<Event>> applyFiltersAndSorting(
    List<Event> events,
    FilterCriteria criteria,
  ) {
    try {
      var filteredEvents = events;

      // Apply filters
      if (criteria.eventType != null) {
        final result = filterEventsByType(filteredEvents, criteria.eventType!);
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      if (criteria.startDate != null && criteria.endDate != null) {
        final result = filterEventsByDateRange(
          filteredEvents,
          criteria.startDate!,
          criteria.endDate!,
        );
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      if (criteria.location != null && criteria.location!.isNotEmpty) {
        final result = filterEventsByLocation(filteredEvents, criteria.location!);
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      if (criteria.courseCode != null && criteria.courseCode!.isNotEmpty) {
        final result = filterEventsByCourse(filteredEvents, criteria.courseCode!);
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      if (criteria.searchQuery != null && criteria.searchQuery!.isNotEmpty) {
        final result = filterEventsBySearch(filteredEvents, criteria.searchQuery!);
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      if (criteria.upcomingOnly) {
        final result = filterUpcomingEvents(filteredEvents);
        filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
      }

      // Apply sorting
      switch (criteria.sortBy) {
        case SortCriteria.time:
          final result = sortEventsByTime(filteredEvents, ascending: criteria.ascending);
          filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
          break;
        case SortCriteria.priority:
          final result = sortEventsByPriority(filteredEvents);
          filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
          break;
        case SortCriteria.location:
          final result = sortEventsByLocation(filteredEvents, ascending: criteria.ascending);
          filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
          break;
        case SortCriteria.course:
          final result = sortEventsByCourse(filteredEvents, ascending: criteria.ascending);
          filteredEvents = result.fold((l) => throw Exception(l.message), (r) => r);
          break;
        case SortCriteria.none:
          break;
      }

      return Right(filteredEvents);
    } catch (e) {
      return Left(GeneralFailure('Failed to apply filters and sorting: $e'));
    }
  }

  /// Private helper: Get event type priority for sorting
  int _getEventTypePriority(EventType type) {
    switch (type) {
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

  /// Private helper: Count events by type
  Map<EventType, int> _countEventsByType(List<Event> events) {
    final counts = <EventType, int>{};
    for (final event in events) {
      counts[event.type] = (counts[event.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Private helper: Count events this week
  int _countEventsThisWeek(List<Event> events) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return events.where((event) =>
      event.startTime.isAfter(startOfWeek) &&
      event.startTime.isBefore(endOfWeek)
    ).length;
  }

  /// Private helper: Count events today
  int _countEventsToday(List<Event> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return events.where((event) =>
      event.startTime.isAfter(today) &&
      event.startTime.isBefore(tomorrow)
    ).length;
  }
}

/// Filter criteria for events
class FilterCriteria {
  final EventType? eventType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? location;
  final String? courseCode;
  final String? searchQuery;
  final bool upcomingOnly;
  final SortCriteria sortBy;
  final bool ascending;

  const FilterCriteria({
    this.eventType,
    this.startDate,
    this.endDate,
    this.location,
    this.courseCode,
    this.searchQuery,
    this.upcomingOnly = false,
    this.sortBy = SortCriteria.time,
    this.ascending = true,
  });
}

/// Sort criteria options
enum SortCriteria {
  none,
  time,
  priority,
  location,
  course,
}

/// Event statistics
class EventStatistics {
  final int totalEvents;
  final int upcomingEvents;
  final int pastEvents;
  final Map<EventType, int> eventsByType;
  final int eventsThisWeek;
  final int eventsToday;

  const EventStatistics({
    required this.totalEvents,
    required this.upcomingEvents,
    required this.pastEvents,
    required this.eventsByType,
    required this.eventsThisWeek,
    required this.eventsToday,
  });
}

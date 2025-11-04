import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../mocks/mock_data_source.dart';

/// Event repository implementation
class EventRepositoryImpl implements EventRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final MockDataSource mockDataSource;

  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mockDataSource,
  });

  @override
  Future<Either<Failure, List<Event>>> getEvents(String userId) async {
    try {
      // For demo purposes, use mock data
      final events = await mockDataSource.getEvents(userId);
      return Right(events.map((e) => e.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(GeneralFailure('Failed to get events: $e'));
    }
  }

  @override
  Future<Either<Failure, Event?>> getNextEvent(String userId) async {
    try {
      // For demo purposes, use mock data
      final event = await mockDataSource.getNextEvent(userId);
      return Right(event?.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(GeneralFailure('Failed to get next event: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsForDate(String userId, DateTime date) async {
    try {
      final events = await mockDataSource.getEventsForDate(userId, date);
      return Right(events.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(GeneralFailure('Failed to get events for date: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsForRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final events = await mockDataSource.getEventsForRange(userId, startDate, endDate);
      return Right(events.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(GeneralFailure('Failed to get events for range: $e'));
    }
  }

  @override
  Future<Either<Failure, Event>> addEvent(Event event) async {
    try {
      // In a real app, this would call the remote data source
      // For now, just return the event
      return Right(event);
    } catch (e) {
      return Left(GeneralFailure('Failed to add event: $e'));
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    try {
      // In a real app, this would call the remote data source
      // For now, just return the event
      return Right(event);
    } catch (e) {
      return Left(GeneralFailure('Failed to update event: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      // In a real app, this would call the remote data source
      // For now, just return success
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure('Failed to delete event: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAcademicEvents() async {
    try {
      final events = await mockDataSource.getAcademicEvents();
      return Right(events.map((e) => e.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(GeneralFailure('Failed to get academic events: $e'));
    }
  }
}

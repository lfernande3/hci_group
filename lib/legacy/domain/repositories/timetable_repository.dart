import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/timetable.dart';

/// Timetable repository contract
abstract class TimetableRepository {
  /// Get user's timetable
  Future<Either<Failure, Timetable>> getTimetable(String userId);
  
  /// Get timetable for specific semester
  Future<Either<Failure, Timetable>> getTimetableForSemester(
    String userId,
    String semester,
    int year,
  );
  
  /// Update timetable
  Future<Either<Failure, Timetable>> updateTimetable(Timetable timetable);
  
  /// Sync timetable with server
  Future<Either<Failure, Timetable>> syncTimetable(String userId);
  
  /// Get cached timetable
  Future<Either<Failure, Timetable?>> getCachedTimetable(String userId);
  
  /// Cache timetable locally
  Future<Either<Failure, void>> cacheTimetable(Timetable timetable);
}

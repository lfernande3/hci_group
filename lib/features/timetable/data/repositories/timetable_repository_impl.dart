import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/data/datasources/local_data_source.dart';
import '../../../../core/data/datasources/remote_data_source.dart';
import '../../../../core/data/mocks/mock_data_source.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../models/timetable_model.dart';

/// Timetable repository implementation
class TimetableRepositoryImpl implements TimetableRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final MockDataSource mockDataSource;

  TimetableRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mockDataSource,
  });

  @override
  Future<Either<Failure, Timetable>> getTimetable(String userId) async {
    try {
      // Try to get from cache first
      final cachedTimetable = await localDataSource.getCachedTimetable(userId);
      if (cachedTimetable != null) {
        // Check if cache is recent (less than 1 hour old)
        final hourAgo = DateTime.now().subtract(const Duration(hours: 1));
        if (cachedTimetable.lastUpdated.isAfter(hourAgo)) {
          return Right(cachedTimetable.toEntity());
        }
      }

      // For demo purposes, use mock data
      final timetable = await mockDataSource.getTimetable(userId);
      await localDataSource.cacheTimetable(timetable);
      return Right(timetable.toEntity());
    } on NetworkException catch (e) {
      // If network fails, try to return cached data
      try {
        final cachedTimetable = await localDataSource.getCachedTimetable(userId);
        if (cachedTimetable != null) {
          return Right(cachedTimetable.toEntity());
        }
      } catch (_) {}
      return Left(NetworkFailure(e.message, e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to get timetable: $e'));
    }
  }

  @override
  Future<Either<Failure, Timetable>> getTimetableForSemester(
    String userId,
    String semester,
    int year,
  ) async {
    try {
      final timetable = await mockDataSource.getTimetableForSemester(userId, semester, year);
      return Right(timetable.toEntity());
    } catch (e) {
      return Left(GeneralFailure('Failed to get timetable for semester: $e'));
    }
  }

  @override
  Future<Either<Failure, Timetable>> updateTimetable(Timetable timetable) async {
    try {
      // In a real app, this would sync with the server
      // For now, just cache it locally
      final timetableModel = TimetableModel.fromEntity(timetable);
      await localDataSource.cacheTimetable(timetableModel);
      return Right(timetable);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to update timetable: $e'));
    }
  }

  @override
  Future<Either<Failure, Timetable>> syncTimetable(String userId) async {
    try {
      // For demo purposes, use mock data
      final timetable = await mockDataSource.getTimetable(userId);
      await localDataSource.cacheTimetable(timetable);
      return Right(timetable.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to sync timetable: $e'));
    }
  }

  @override
  Future<Either<Failure, Timetable?>> getCachedTimetable(String userId) async {
    try {
      final cachedTimetable = await localDataSource.getCachedTimetable(userId);
      return Right(cachedTimetable?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to get cached timetable: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTimetable(Timetable timetable) async {
    try {
      final timetableModel = TimetableModel.fromEntity(timetable);
      await localDataSource.cacheTimetable(timetableModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to cache timetable: $e'));
    }
  }
}

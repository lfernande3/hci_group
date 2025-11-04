import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/date_utils.dart';

/// Use case for calculating current semester week
class CalculateWeekUseCase {
  /// Calculate current semester week number
  Either<Failure, int> call({DateTime? semesterStart}) {
    try {
      final weekNumber = AppDateUtils.getCurrentSemesterWeek(
        semesterStart: semesterStart,
      );
      return Right(weekNumber);
    } catch (e) {
      return Left(GeneralFailure('Failed to calculate semester week: $e'));
    }
  }

  /// Calculate week number for a specific date
  Either<Failure, int> calculateWeekForDate(
    DateTime date, {
    DateTime? semesterStart,
  }) {
    try {
      final start = semesterStart ?? _getDefaultSemesterStart(date);
      final difference = date.difference(start).inDays;
      final weekNumber = (difference / 7).floor() + 1;
      return Right(weekNumber.clamp(1, 20)); // Academic semesters typically 15-20 weeks
    } catch (e) {
      return Left(GeneralFailure('Failed to calculate week for date: $e'));
    }
  }

  /// Get semester progress as percentage
  Either<Failure, double> getSemesterProgress({
    DateTime? semesterStart,
    DateTime? semesterEnd,
    int? totalWeeks,
  }) {
    try {
      final now = DateTime.now();
      final start = semesterStart ?? _getDefaultSemesterStart(now);
      final weeks = totalWeeks ?? 15; // Default 15-week semester
      final end = semesterEnd ?? start.add(Duration(days: weeks * 7));
      
      if (now.isBefore(start)) {
        return const Right(0.0);
      }
      
      if (now.isAfter(end)) {
        return const Right(1.0);
      }
      
      final totalDays = end.difference(start).inDays;
      final passedDays = now.difference(start).inDays;
      final progress = passedDays / totalDays;
      
      return Right(progress.clamp(0.0, 1.0));
    } catch (e) {
      return Left(GeneralFailure('Failed to calculate semester progress: $e'));
    }
  }

  /// Get formatted week display (e.g., "W5", "W12")
  Either<Failure, String> getWeekDisplay({DateTime? semesterStart}) {
    final weekResult = call(semesterStart: semesterStart);
    return weekResult.fold(
      (failure) => Left(failure),
      (week) => Right('W$week'),
    );
  }

  /// Check if we're in a break period
  Either<Failure, bool> isBreakPeriod({DateTime? date}) {
    try {
      final checkDate = date ?? DateTime.now();
      
      // Common break periods in Hong Kong academic calendar
      final year = checkDate.year;
      
      // Mid-semester break (typically mid-October)
      final midBreakStart = DateTime(year, 10, 15);
      final midBreakEnd = DateTime(year, 10, 22);
      
      // Christmas/New Year break
      final winterBreakStart = DateTime(year, 12, 20);
      final winterBreakEnd = DateTime(year + 1, 1, 15);
      
      // Summer break (May to August)
      final summerBreakStart = DateTime(year, 5, 15);
      final summerBreakEnd = DateTime(year, 8, 31);
      
      final isInBreak = (checkDate.isAfter(midBreakStart) && checkDate.isBefore(midBreakEnd)) ||
                       (checkDate.isAfter(winterBreakStart) && checkDate.isBefore(winterBreakEnd)) ||
                       (checkDate.isAfter(summerBreakStart) && checkDate.isBefore(summerBreakEnd));
      
      return Right(isInBreak);
    } catch (e) {
      return Left(GeneralFailure('Failed to check break period: $e'));
    }
  }

  /// Get semester name based on current date
  Either<Failure, String> getCurrentSemesterName({DateTime? date}) {
    try {
      final checkDate = date ?? DateTime.now();
      final month = checkDate.month;
      
      if (month >= 9 || month <= 1) {
        return const Right('Semester 1');
      } else if (month >= 2 && month <= 6) {
        return const Right('Semester 2');
      } else {
        return const Right('Summer Session');
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get semester name: $e'));
    }
  }

  /// Get default semester start date based on current date
  DateTime _getDefaultSemesterStart(DateTime date) {
    final year = date.year;
    final month = date.month;
    
    if (month >= 9 || month <= 1) {
      // Semester 1: September to January
      return DateTime(month <= 1 ? year - 1 : year, 9, 1);
    } else if (month >= 2 && month <= 6) {
      // Semester 2: February to June
      return DateTime(year, 2, 1);
    } else {
      // Summer session: July to August
      return DateTime(year, 7, 1);
    }
  }
}

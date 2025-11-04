import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/data/datasources/local_data_source.dart';
import '../../domain/entities/navbar_config.dart';
import '../../domain/repositories/navbar_repository.dart';
import '../models/navbar_config_model.dart';

/// Navbar repository implementation
class NavbarRepositoryImpl implements NavbarRepository {
  final LocalDataSource localDataSource;

  NavbarRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, NavbarConfig>> getNavbarConfig() async {
    try {
      final config = await localDataSource.getNavbarConfig();
      return Right(config.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to get navbar config: $e'));
    }
  }

  @override
  Future<Either<Failure, NavbarConfig>> updateNavbarConfig(NavbarConfig config) async {
    try {
      final configModel = NavbarConfigModel.fromEntity(config);
      await localDataSource.setNavbarConfig(configModel);
      return Right(config);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to update navbar config: $e'));
    }
  }

  @override
  Future<Either<Failure, NavbarConfig>> resetToDefault() async {
    try {
      final defaultConfig = NavbarConfig.defaultConfig();
      final configModel = NavbarConfigModel.fromEntity(defaultConfig);
      await localDataSource.setNavbarConfig(configModel);
      return Right(defaultConfig);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to reset navbar config: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearNavbarConfig() async {
    try {
      await localDataSource.clearNavbarConfig();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to clear navbar config: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NavbarItem>>> getAvailableItems() async {
    try {
      // Return all available navbar items
      final availableItems = [
        NavbarItem.homepage(),
        NavbarItem.timetable(),
        NavbarItem.qrCode(),
        NavbarItem.chatbot(),
        NavbarItem.settings(),
        NavbarItem.account(),
        NavbarItem.campusMap(),
        NavbarItem.roomAvailability(),
        NavbarItem.academicCalendar(),
        NavbarItem.authenticator(),
        NavbarItem.sportsFacilities(),
        NavbarItem.contacts(),
        NavbarItem.emergency(),
        NavbarItem.news(),
        NavbarItem.cap(),
      ];
      
      return Right(availableItems);
    } catch (e) {
      return Left(GeneralFailure('Failed to get available items: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> canAddItem(NavbarItem item) async {
    try {
      final config = await localDataSource.getNavbarConfig();
      
      // Check if item already exists
      final itemExists = config.items.any((existingItem) => existingItem.id == item.id);
      if (itemExists) {
        return const Right(false);
      }
      
      // Check if we can add more items
      return Right(config.canAddMore);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Failed to check if item can be added: $e'));
    }
  }
}

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../data/datasources/datasources.dart';
import '../data/mocks/mock_data_source.dart';
import '../data/repositories/repositories.dart';
import '../domain/repositories/repositories.dart';
import '../domain/usecases/usecases.dart';
import 'utils/connectivity_service.dart';
import 'utils/offline_cache_service.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // Initialize external dependencies
  await _initExternalDependencies();
  
  // Register data sources
  _registerDataSources();
  
  // Register repositories
  _registerRepositories();
  
  // Register use cases
  _registerUseCases();
}

/// Initialize external dependencies (Hive, etc.)
Future<void> _initExternalDependencies() async {
  // Register core services first
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  
  sl.registerLazySingleton<OfflineCacheService>(
    () => OfflineCacheService(),
  );
  
  // Initialize the services
  await sl<ConnectivityService>().initialize();
  await sl<OfflineCacheService>().initialize();
}

/// Register data sources
void _registerDataSources() {
  // HTTP client - singleton
  sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );
  
  // Mock data source - singleton (for demo purposes)
  sl.registerLazySingleton<MockDataSource>(
    () => MockDataSource(),
  );
  
  // Local data source - singleton
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  
  // Remote data source - singleton  
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(client: sl<http.Client>()),
  );
}

/// Register repository implementations
void _registerRepositories() {
  // User repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<RemoteDataSource>(),
      localDataSource: sl<LocalDataSource>(),
    ),
  );
  
  // Event repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: sl<RemoteDataSource>(),
      localDataSource: sl<LocalDataSource>(),
      mockDataSource: sl<MockDataSource>(),
    ),
  );
  
  // Timetable repository
  sl.registerLazySingleton<TimetableRepository>(
    () => TimetableRepositoryImpl(
      remoteDataSource: sl<RemoteDataSource>(),
      localDataSource: sl<LocalDataSource>(),
      mockDataSource: sl<MockDataSource>(),
    ),
  );
  
  // Navbar repository
  sl.registerLazySingleton<NavbarRepository>(
    () => NavbarRepositoryImpl(
      localDataSource: sl<LocalDataSource>(),
    ),
  );
}

/// Register use cases
void _registerUseCases() {
  // Get next event use case (enhanced with TimetableRepository)
  sl.registerLazySingleton(
    () => GetNextEventUseCase(
      eventRepository: sl<EventRepository>(),
      timetableRepository: sl<TimetableRepository>(),
    ),
  );
  
  // Calculate week use case (no repository dependency)
  sl.registerLazySingleton(
    () => CalculateWeekUseCase(),
  );
  
  // Manage navbar use case
  sl.registerLazySingleton(
    () => ManageNavbarUseCase(sl<NavbarRepository>()),
  );
  
  // Check login status use case
  sl.registerLazySingleton(
    () => CheckLoginStatusUseCase(sl<UserRepository>()),
  );
  
  // Data filtering and sorting use case
  sl.registerLazySingleton(
    () => DataFilteringSortingUseCase(),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}

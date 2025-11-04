import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/core.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize dependency injection
  await initDependencies();
  
  runApp(const CityUHKApp());
}

class CityUHKApp extends StatelessWidget {
  const CityUHKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(
            manageNavbarUseCase: sl(),
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(
            checkLoginStatusUseCase: sl(),
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => OnboardingProvider()..initialize(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'CityUHK Mobile',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

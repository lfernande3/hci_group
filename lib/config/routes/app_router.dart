import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Core imports
import '../../core/constants/route_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/presentation/widgets/app_shell.dart';

// Feature imports - pages
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/timetable/presentation/pages/timetable_page.dart';
import '../../features/qr/presentation/pages/qr_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/laundry/presentation/pages/laundry_page.dart';

// Feature imports - providers
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/auth/presentation/providers/user_provider.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RouteConstants.home,
    debugLogDiagnostics: true, // Enable for debugging
    redirect: (context, state) {
      final onboardingProvider = context.read<OnboardingProvider>();
      final userProvider = context.read<UserProvider>();
      
      // Check if onboarding is completed
      final onboardingCompleted = onboardingProvider.isCompleted;
      final isOnOnboardingPage = state.uri.path == RouteConstants.onboarding;
      
      // Redirect to onboarding if not completed and not already on onboarding page
      if (!onboardingCompleted && !isOnOnboardingPage) {
        return RouteConstants.onboarding;
      }
      
      // If on onboarding page but already completed, redirect to home
      if (onboardingCompleted && isOnOnboardingPage) {
        return RouteConstants.home;
      }
      
      // Handle login redirects
      final isOnLoginPage = state.uri.path == RouteConstants.login;
      if (userProvider.isLoggedIn && isOnLoginPage) {
        return RouteConstants.home;
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Routes without bottom navigation
      GoRoute(
        path: RouteConstants.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.timetable,
            name: 'timetable',
            builder: (context, state) => const TimetablePage(),
          ),
          GoRoute(
            path: RouteConstants.qrCode,
            name: 'qr',
            builder: (context, state) => const QrPage(),
          ),
          GoRoute(
            path: RouteConstants.settings,
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          
          // Placeholder routes for navbar items
          GoRoute(
            path: RouteConstants.chatbot,
            name: 'chatbot',
            builder: (context, state) => const _PlaceholderPage(title: 'Chatbot'),
          ),
          GoRoute(
            path: RouteConstants.account,
            name: 'account',
            builder: (context, state) => const _PlaceholderPage(title: 'Account'),
          ),
          GoRoute(
            path: RouteConstants.campusMap,
            name: 'campus-map',
            builder: (context, state) => const _PlaceholderPage(title: 'Campus Map'),
          ),
          GoRoute(
            path: RouteConstants.roomAvailability,
            name: 'room-availability',
            builder: (context, state) => const _PlaceholderPage(title: 'Room Availability'),
          ),
          GoRoute(
            path: RouteConstants.academicCalendar,
            name: 'academic-calendar',
            builder: (context, state) => const _PlaceholderPage(title: 'Academic Calendar'),
          ),
          GoRoute(
            path: RouteConstants.authenticator,
            name: 'authenticator',
            builder: (context, state) => const _PlaceholderPage(title: 'Authenticator'),
          ),
          GoRoute(
            path: RouteConstants.sportsFacilities,
            name: 'sports-facilities',
            builder: (context, state) => const _PlaceholderPage(title: 'Sports Facilities'),
          ),
          GoRoute(
            path: RouteConstants.contacts,
            name: 'contacts',
            builder: (context, state) => const _PlaceholderPage(title: 'Contacts'),
          ),
          GoRoute(
            path: RouteConstants.emergency,
            name: 'emergency',
            builder: (context, state) => const _PlaceholderPage(title: 'Emergency'),
          ),
          GoRoute(
            path: RouteConstants.news,
            name: 'news',
            builder: (context, state) => const _PlaceholderPage(title: 'News'),
          ),
          GoRoute(
            path: RouteConstants.cap,
            name: 'cap',
            builder: (context, state) => const _PlaceholderPage(title: 'CAP'),
          ),
          GoRoute(
            path: RouteConstants.cityuTube,
            name: 'cityutube',
            builder: (context, state) => const _PlaceholderPage(title: 'CityUTube'),
          ),
          GoRoute(
            path: RouteConstants.studentLife,
            name: 'student-life',
            builder: (context, state) => const _PlaceholderPage(title: 'Student Life'),
          ),
          GoRoute(
            path: RouteConstants.campus,
            name: 'campus',
            builder: (context, state) => const _PlaceholderPage(title: 'Campus'),
          ),
          GoRoute(
            path: RouteConstants.gradeReport,
            name: 'grade-report',
            builder: (context, state) => const _PlaceholderPage(title: 'Grade Report'),
          ),
          
          // New feature routes (Week 1 - T-106)
          GoRoute(
            path: RouteConstants.booking,
            name: 'booking',
            builder: (context, state) => const BookingPage(),
          ),
          GoRoute(
            path: RouteConstants.laundry,
            name: 'laundry',
            builder: (context, state) => const LaundryPage(),
          ),
          GoRoute(
            path: RouteConstants.print,
            name: 'print',
            builder: (context, state) => const _PlaceholderPage(title: 'Print Submission'),
          ),
          GoRoute(
            path: RouteConstants.events,
            name: 'events',
            builder: (context, state) => const _PlaceholderPage(title: 'Events Dashboard'),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.path}" could not be found.',
              style: const TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    // Deep linking configuration - removed urlPathStrategy as it's deprecated
    // GoRouter now uses path-based URLs by default in newer versions
  );

  static GoRouter get router => _router;

  /// Navigate to a specific route by path
  static void navigateTo(BuildContext context, String path, {Object? extra}) {
    context.go(path, extra: extra);
  }

  /// Navigate and replace current route
  static void navigateAndReplace(BuildContext context, String path, {Object? extra}) {
    context.pushReplacement(path, extra: extra);
  }

  /// Push a new route onto the stack
  static void push(BuildContext context, String path, {Object? extra}) {
    context.push(path, extra: extra);
  }

  /// Pop the current route
  static void pop(BuildContext context, [Object? result]) {
    if (context.canPop()) {
      context.pop(result);
    } else {
      // If can't pop, navigate to home
      context.go(RouteConstants.home);
    }
  }

  /// Check if we can pop the current route
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  /// Get current location
  static String currentLocation(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Navigate to onboarding flow
  static void navigateToOnboarding(BuildContext context) {
    navigateTo(context, RouteConstants.onboarding);
  }

  /// Navigate to login page
  static void navigateToLogin(BuildContext context) {
    navigateTo(context, RouteConstants.login);
  }

  /// Navigate to home and clear stack
  static void navigateToHome(BuildContext context) {
    navigateAndReplace(context, RouteConstants.home);
  }
}

/// Placeholder page for routes that are not yet implemented
/// Uses AppTheme to verify light/dark mode compatibility
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // AppTheme automatically applied via MaterialApp.router
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: colorScheme.primary, // Uses theme color
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            // Add settings button for Account page
            if (title == 'Account') ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.go(RouteConstants.settings);
                },
                icon: const Icon(Icons.settings),
                label: const Text('Go to Settings'),
                // Uses AppTheme.elevatedButtonTheme automatically
              ),
            ],
          ],
        ),
      ),
    );
  }
}

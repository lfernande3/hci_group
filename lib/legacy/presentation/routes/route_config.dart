/// Route configuration utilities
class RouteConfig {
  /// Check if route is a bottom navigation route
  static bool isBottomNavRoute(String route) {
    const bottomNavRoutes = [
      '/',
      '/timetable',
      '/chatbot',
      '/qr',
      '/account',
      '/settings',
      '/campus-map',
      '/room-availability',
      '/academic-calendar',
      '/authenticator',
      '/sports-facilities',
      '/contacts',
      '/emergency',
      '/news',
      '/cap',
    ];
    
    return bottomNavRoutes.contains(route);
  }

  /// Get route index for bottom navigation
  static int getBottomNavIndex(String route, List<String> navRoutes) {
    for (int i = 0; i < navRoutes.length; i++) {
      if (navRoutes[i] == route) {
        return i;
      }
    }
    return 0; // Default to first tab
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    const authRoutes = [
      '/timetable',
      '/account',
      '/qr',
      '/grade-report',
    ];
    
    return authRoutes.contains(route);
  }

  /// Check if route should show bottom navigation
  static bool showBottomNav(String route) {
    const hiddenNavRoutes = [
      '/onboarding',
      '/login',
    ];
    
    return !hiddenNavRoutes.contains(route);
  }

  /// Get page title for route
  static String getPageTitle(String route) {
    switch (route) {
      case '/':
        return 'CityUHK Mobile';
      case '/onboarding':
        return 'Welcome';
      case '/timetable':
        return 'Timetable';
      case '/chatbot':
        return 'Chatbot';
      case '/qr':
        return 'CityU ID';
      case '/account':
        return 'Account';
      case '/settings':
        return 'Settings';
      case '/login':
        return 'Login';
      case '/campus-map':
        return 'Campus Map';
      case '/room-availability':
        return 'Room Availability';
      case '/academic-calendar':
        return 'Academic Calendar';
      case '/authenticator':
        return 'Authenticator';
      case '/sports-facilities':
        return 'Sports Facilities';
      case '/contacts':
        return 'Contacts';
      case '/emergency':
        return 'Emergency';
      case '/news':
        return 'News';
      case '/cap':
        return 'CAP';
      case '/cityutube':
        return 'CityUTube';
      case '/student-life':
        return 'Student Life';
      case '/campus':
        return 'Campus';
      case '/grade-report':
        return 'Grade Report';
      default:
        return 'CityUHK Mobile';
    }
  }
}

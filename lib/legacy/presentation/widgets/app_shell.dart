import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import 'bottom_navbar.dart';

/// App shell that contains the bottom navigation bar
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    
    // Routes where bottom navigation should be hidden
    final hideNavbarRoutes = [
      RouteConstants.onboarding,
      RouteConstants.login,
    ];
    
    final showBottomNav = !hideNavbarRoutes.contains(currentLocation);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: showBottomNav ? const BottomNavbar() : null,
    );
  }
}

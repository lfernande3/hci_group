import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';
import '../../core/theme/colors.dart';

/// Custom bottom navigation bar integrated with GoRouter
class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        final items = navigationProvider.items;
        
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Get current route to determine selected index
        final currentLocation = GoRouterState.of(context).uri.path;
        int currentIndex = 0;
        
        // Find current index based on route
        for (int i = 0; i < items.length; i++) {
          if (items[i].route == currentLocation) {
            currentIndex = i;
            break;
          }
        }
        
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            // Update provider state
            navigationProvider.setCurrentIndex(index);
            
            // Navigate to the selected route
            final selectedRoute = items[index].route;
            context.go(selectedRoute);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8,
          items: items.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.icon, color: AppColors.primary),
            label: item.label,
          )).toList(),
        );
      },
    );
  }
}

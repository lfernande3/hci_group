import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/providers/theme_provider.dart';
import '../../../navigation/presentation/providers/navigation_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../navigation/domain/entities/navbar_config.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../onboarding/presentation/pages/help_faq_page.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';

/// Settings page for app configuration
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _AccountSection(),
          const Divider(),
          const _ThemeSection(),
          const Divider(),
          const _NavigationSection(),
          const Divider(),
          const _HelpSection(),
          const Divider(),
          const _AboutSection(),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final theme = Theme.of(context);
        final isLoggedIn = userProvider.isLoggedIn;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // CityU gradient background - orange to burgundy (matching next event widget)
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.6],
              colors: [
                AppColors.secondaryOrange, // Orange
                AppColors.primary, // Burgundy
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.widgetAccent.withOpacity(0.3),
              width: 1.5,
            ),
            // Subtle shadow for depth
            boxShadow: [
              BoxShadow(
                color: AppColors.widgetShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoggedIn) ...[
                // User Info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        userProvider.user?.fullName[0].toUpperCase() ?? 'U',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.user?.fullName ?? 'Unknown',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userProvider.user?.email ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logged in via CityU SSO',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context, userProvider);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ] else ...[
                // Login Prompt
                Text(
                  'Sign in to access personalized features',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access your bookings, laundry schedules, print jobs, and more.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(RouteConstants.login);
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In with CityU SSO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out from your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.logout();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Successfully logged out'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ExpansionTile(
          leading: const Icon(Icons.palette, color: AppColors.primary),
          title: const Text('Appearance'),
          subtitle: Text('Theme: ${themeProvider.themeModeDisplayName}'),
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _NavigationSection extends StatelessWidget {
  const _NavigationSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return ExpansionTile(
          leading: const Icon(Icons.navigation, color: AppColors.primary),
          title: const Text('Edit Navbar Items'),
          subtitle: Text('${navigationProvider.items.length}/5 items configured'),
          children: [
            ListTile(
              title: const Text('Customize Bottom Navigation'),
              subtitle: const Text('Add, remove, or reorder navigation items'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NavbarCustomizationPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Reset to Default'),
              subtitle: const Text('Restore default navigation layout'),
              trailing: const Icon(Icons.restore),
              onTap: () {
                _showResetDialog(context, navigationProvider);
              },
            ),
            ListTile(
              title: const Text('Clear Navbar Cache'),
              subtitle: const Text('Force reload navbar configuration'),
              trailing: const Icon(Icons.clear_all),
              onTap: () {
                _showClearCacheDialog(context, navigationProvider);
              },
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog(BuildContext context, NavigationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Navigation'),
        content: const Text(
          'Are you sure you want to reset the navigation bar to default settings? This will remove any customizations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetToDefault();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigation bar reset to default'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, NavigationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Navbar Cache'),
        content: const Text(
          'This will clear the cached navbar configuration and reload with the new default settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearNavbarConfig();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navbar cache cleared and reloaded'),
                ),
              );
            },
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.help_outline, color: AppColors.primary),
      title: const Text('Help & FAQ'),
      subtitle: const Text('Get help and replay tutorial'),
      children: [
        ListTile(
          title: const Text('Help & FAQ'),
          subtitle: const Text('Frequently asked questions and answers'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HelpFaqPage(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Replay Tutorial'),
          subtitle: const Text('Watch the app tutorial again'),
          trailing: const Icon(Icons.play_circle_outline),
          onTap: () {
            final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
            onboardingProvider.resetOnboarding();
            context.go(RouteConstants.onboarding);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tutorial will start now'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      leading: Icon(Icons.info, color: AppColors.primary),
      title: Text('About'),
      subtitle: Text('App information and support'),
      children: [
        ListTile(
          title: Text('Version'),
          subtitle: Text('1.0.0'),
        ),
        ListTile(
          title: Text('City University of Hong Kong'),
          subtitle: Text('Official mobile application'),
        ),
        ListTile(
          title: Text('Contact Support'),
          subtitle: Text('help@cityu.edu.hk'),
          trailing: Icon(Icons.email),
        ),
      ],
    );
  }
}

/// Navbar customization page with drag-to-reorder functionality
class NavbarCustomizationPage extends StatefulWidget {
  const NavbarCustomizationPage({super.key});

  @override
  State<NavbarCustomizationPage> createState() => _NavbarCustomizationPageState();
}

class _NavbarCustomizationPageState extends State<NavbarCustomizationPage> {
  List<NavbarItem> _currentItems = [];
  List<NavbarItem> _availableItems = [];
  bool _isLoading = true;
  
  // Undo state tracking
  List<NavbarItem> _originalCurrentItems = [];
  List<NavbarItem> _originalAvailableItems = [];
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final navigationProvider = context.read<NavigationProvider>();
    
    // Load current items
    _currentItems = List.from(navigationProvider.items);
    
    // Load available items
    _availableItems = await navigationProvider.getAvailableItems();
    
    // Remove already selected items from available list
    _availableItems.removeWhere((available) => 
      _currentItems.any((current) => current.id == available.id));
    
    // Save original state for undo
    _originalCurrentItems = List.from(_currentItems);
    _originalAvailableItems = List.from(_availableItems);
    _hasUnsavedChanges = false;
    
    setState(() {
      _isLoading = false;
    });
  }
  
  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }
  
  void _undoChanges() {
    setState(() {
      _currentItems = List.from(_originalCurrentItems);
      _availableItems = List.from(_originalAvailableItems);
      _hasUnsavedChanges = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.undo, color: Colors.white),
            SizedBox(width: 8),
            Text('Changes undone'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Navigation'),
        actions: [
          // Undo button (only show when there are unsaved changes)
          if (_hasUnsavedChanges)
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo changes',
              onPressed: _undoChanges,
            ),
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Navigation Items (${_currentItems.length}/5)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Drag items to reorder, tap to remove',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildCurrentItemsList(),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Available Items',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildAvailableItemsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrentItemsList() {
    if (_currentItems.isEmpty) {
      return const Center(
        child: Text('No navigation items selected'),
      );
    }

    return ReorderableListView.builder(
      itemCount: _currentItems.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = _currentItems.removeAt(oldIndex);
          _currentItems.insert(newIndex, item);
          _markAsChanged();
        });
      },
      itemBuilder: (context, index) {
        final item = _currentItems[index];
        return ListTile(
          key: ValueKey(item.id),
          leading: Icon(item.icon, color: AppColors.primary),
          title: Text(item.label),
          subtitle: Text(item.route),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removeItem(item),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvailableItemsList() {
    if (_availableItems.isEmpty) {
      return const Center(
        child: Text('No more items available to add'),
      );
    }

    return ListView.builder(
      itemCount: _availableItems.length,
      itemBuilder: (context, index) {
        final item = _availableItems[index];
        final canAdd = _currentItems.length < 5;
        
        return ListTile(
          leading: Icon(
            item.icon, 
            color: canAdd ? AppColors.primary : Colors.grey,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              color: canAdd ? null : Colors.grey,
            ),
          ),
          subtitle: Text(
            canAdd ? item.route : 'Maximum 5 items reached',
            style: TextStyle(
              color: canAdd ? null : Colors.grey,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: canAdd ? AppColors.primary : Colors.grey,
            ),
            onPressed: canAdd ? () => _addItem(item) : null,
          ),
        );
      },
    );
  }

  void _addItem(NavbarItem item) {
    if (_currentItems.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 navigation items allowed'),
        ),
      );
      return;
    }

    setState(() {
      _currentItems.add(item);
      _availableItems.remove(item);
      _markAsChanged();
    });
  }

  void _removeItem(NavbarItem item) {
    setState(() {
      _currentItems.remove(item);
      _availableItems.add(item);
      _markAsChanged();
    });
  }

  Future<void> _saveChanges() async {
    final navigationProvider = context.read<NavigationProvider>();
    
    // Create new config with reordered items
    final newConfig = NavbarConfig(items: _currentItems);
    
    await navigationProvider.updateConfig(newConfig);
    
    if (mounted) {
      // Update original state after saving
      _originalCurrentItems = List.from(_currentItems);
      _originalAvailableItems = List.from(_availableItems);
      _hasUnsavedChanges = false;
      
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Navigation customization saved'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

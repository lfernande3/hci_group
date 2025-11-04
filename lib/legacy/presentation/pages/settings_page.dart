import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/navigation_provider.dart';
import '../../core/theme/colors.dart';
import '../../domain/entities/navbar_config.dart';

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
          const _ThemeSection(),
          const Divider(),
          const _NavigationSection(),
          const Divider(),
          const _AboutSection(),
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
          title: const Text('Navigation'),
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
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Navigation'),
        actions: [
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
      onReorder: (oldIndex, newIndex) async {
        final previousOrder = List<NavbarItem>.from(_currentItems);
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = _currentItems.removeAt(oldIndex);
          _currentItems.insert(newIndex, item);
        });

        // Ask for confirmation with Undo option
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Reorder?'),
              content: const Text('Do you want to keep this new order for the navigation bar?'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Undo changes
                    setState(() {
                      _currentItems = previousOrder;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reorder undone')),
                    );
                  },
                  child: const Text('Undo'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        }
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
    });
  }

  void _removeItem(NavbarItem item) {
    setState(() {
      _currentItems.remove(item);
      _availableItems.add(item);
    });
  }

  Future<void> _saveChanges() async {
    final navigationProvider = context.read<NavigationProvider>();
    
    // Create new config with reordered items
    final newConfig = NavbarConfig(items: _currentItems);
    
    await navigationProvider.updateConfig(newConfig);
    
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navigation customization saved'),
        ),
      );
    }
  }
}

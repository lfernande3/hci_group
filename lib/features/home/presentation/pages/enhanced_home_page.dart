import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../../core/presentation/providers/offline_data_provider.dart';
import '../../../../core/presentation/widgets/next_event_widget.dart';
import '../../../../core/presentation/widgets/grid_item_widget.dart';
import '../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/data/mocks/mock_json_data.dart';

/// Enhanced homepage with offline support and error handling
class EnhancedHomePage extends StatefulWidget {
  const EnhancedHomePage({super.key});

  @override
  State<EnhancedHomePage> createState() => _EnhancedHomePageState();
}

class _EnhancedHomePageState extends State<EnhancedHomePage> {
  late OfflineDataProvider _offlineProvider;

  @override
  void initState() {
    super.initState();
    _offlineProvider = OfflineDataProvider();
    _initializeOfflineSupport();
  }

  Future<void> _initializeOfflineSupport() async {
    await _offlineProvider.initialize();
    // Load initial data
    await _loadEventData();
  }

  Future<void> _loadEventData() async {
    await _offlineProvider.loadDataWithOfflineSupport<List<Map<String, dynamic>>>(
      cacheKey: 'home_events',
      dataLoader: () async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));
        // In real implementation, this would be an API call
        return MockJsonData.events.map((e) => e.toJson()).toList();
      },
      cacheUpdater: (data) async {
        // Cache the data
        // In real implementation, this would update local storage
      },
      ttlHours: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _offlineProvider),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              // Static CityUHK logo icon only (left)
              Image.asset(
                'assets/images/cityu_logo.png', // Placeholder
                height: 28,
                width: 28,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.school,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ],
          ),
          actions: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SmallLoadingWidget(),
                  );
                }
                
                return TextButton(
                  onPressed: () {
                    // Navigate to CityU login page
                    if (userProvider.needsLogin) {
                      // TODO: Navigate to official CityU login
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirecting to CityU login...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Show user profile or logout
                      _showUserMenu(context, userProvider);
                    }
                  },
                  child: Text(
                    userProvider.displayName,
                    style: TextStyle(
                      color: userProvider.needsLogin 
                          ? AppColors.grey500 // Subtle logout notice
                          : AppColors.primary,
                      fontWeight: userProvider.needsLogin 
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<OfflineDataProvider>(
          builder: (context, offlineProvider, child) {
            return Column(
              children: [
                // Connectivity Status Indicator
                if (!offlineProvider.isConnected)
                  OfflineIndicatorWidget(
                    onRetry: () => _loadEventData(),
                  ),
                
                // Stale Data Indicator
                if (offlineProvider.showingCachedData && offlineProvider.isConnected)
                  StaleDataIndicatorWidget(
                    onRefresh: () => _loadEventData(),
                    lastUpdated: offlineProvider.lastDataUpdate != null
                        ? _formatLastUpdated(offlineProvider.lastDataUpdate!)
                        : null,
                  ),
                
                Expanded(
                  child: _buildBody(offlineProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(OfflineDataProvider offlineProvider) {
    if (offlineProvider.isLoading) {
      return const LoadingWidget(
        message: 'Loading your schedule...',
        size: 48,
      );
    }

    if (offlineProvider.errorMessage != null && !offlineProvider.showingCachedData) {
      return _buildErrorWidget(offlineProvider);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Next Event Widget
          NextEventWidget(
            nextEvent: _getNextEvent(),
            weekNumber: 5,
            onTap: () => context.go(RouteConstants.timetable),
          ),
          
          // Grid Section
          const Padding(
            padding: EdgeInsets.all(16),
            child: _GridSection(),
          ),
          
          // Feeds Section
          const Padding(
            padding: EdgeInsets.all(16),
            child: _FeedsSection(),
          ),
          
          // Cache info (debug mode only)
          if (offlineProvider.showingCachedData)
            _buildCacheInfo(offlineProvider),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(OfflineDataProvider offlineProvider) {
    if (!offlineProvider.isConnected) {
      return NetworkErrorWidget(
        onRetry: () => _loadEventData(),
      );
    }

    return AppErrorWidget(
      message: offlineProvider.errorMessage ?? 'An error occurred',
      onRetry: () => _loadEventData(),
    );
  }

  Widget _buildCacheInfo(OfflineDataProvider offlineProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.storage,
            size: 16,
            color: AppColors.grey600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Showing cached data${offlineProvider.lastDataUpdate != null ? ' from ${_formatLastUpdated(offlineProvider.lastDataUpdate!)}' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _showCacheStats(offlineProvider),
            child: Text(
              'Info',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCacheStats(OfflineDataProvider offlineProvider) async {
    final stats = await offlineProvider.getCacheStats();
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total entries: ${stats['totalEntries'] ?? 0}'),
            Text('Valid entries: ${stats['validEntries'] ?? 0}'),
            Text('Expired entries: ${stats['expiredEntries'] ?? 0}'),
            Text('Estimated size: ${stats['estimatedSizeKB'] ?? 0} KB'),
            Text('Connected: ${stats['isConnected'] ?? false}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              await offlineProvider.clearExpiredCache();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expired cache cleared')),
              );
            },
            child: const Text('Clear Expired'),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Get the next upcoming event from mock data
  dynamic _getNextEvent() {
    final events = MockJsonData.events;
    final now = DateTime.now();
    
    // Find the next event after current time
    for (final event in events) {
      if (event.startTime.isAfter(now)) {
        return event;
      }
    }
    return null; // No upcoming events
  }

  /// Show user menu with profile options
  void _showUserMenu(BuildContext context, UserProvider userProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(userProvider.displayName),
              subtitle: Text(userProvider.user?.email ?? 'No email'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                userProvider.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _offlineProvider.dispose();
    super.dispose();
  }
}

/// Grid section widget (unchanged from original)
class _GridSection extends StatelessWidget {
  const _GridSection();

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      {'title': 'Student Life', 'icon': Icons.school, 'route': '/student-life'},
      {'title': 'Campus', 'icon': Icons.location_city, 'route': '/campus'},
      {'title': 'Grade Report', 'icon': Icons.assignment, 'route': '/grades'},
      {'title': 'Important Contacts', 'icon': Icons.contact_phone, 'route': '/contacts'},
      {'title': 'News', 'icon': Icons.newspaper, 'route': '/news'},
      {'title': 'CityU CAP', 'icon': Icons.event, 'route': '/cap'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return GridItemWidget(
              title: item['title'] as String,
              icon: item['icon'] as IconData,
              onTap: () {
                // TODO: Navigate to specific route
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening ${item['title']}')),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// Feeds section widget (unchanged from original)
class _FeedsSection extends StatelessWidget {
  const _FeedsSection();

  @override
  Widget build(BuildContext context) {
    final feeds = MockJsonData.feeds;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Updates',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...feeds.take(5).map((feed) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              feed.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              feed.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  feed.publishedDate.toLocal().toString().split(' ')[0],
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(feed.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feed.type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: Open feed detail
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening: ${feed.title}')),
              );
            },
          ),
        )),
      ],
    );
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'news':
        return AppColors.info;
      case 'cap':
        return AppColors.secondaryOrange;
      case 'video':
        return AppColors.secondaryPurple;
      default:
        return AppColors.grey500;
    }
  }
}

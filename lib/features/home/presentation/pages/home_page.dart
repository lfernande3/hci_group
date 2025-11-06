import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/data/mocks/mock_json_data.dart';
import '../../../../core/presentation/widgets/next_event_widget.dart';
import '../../../../core/presentation/widgets/grid_item_widget.dart';
import '../../../../core/presentation/widgets/loading_widget.dart';

// Feature imports
import '../../../auth/presentation/providers/user_provider.dart';

/// Homepage with next event widget and grid
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // CityUHK Logo
            Image.asset(
              'assets/cityu_logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.school,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CityUHK',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
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
              
              return Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextButton(
                  onPressed: () {
                    if (userProvider.needsLogin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirecting to CityU login...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      _showUserMenu(context, userProvider);
                    }
                  },
                  child: Text(
                    userProvider.needsLogin ? 'Login' : userProvider.displayName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: userProvider.needsLogin 
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Next Event Widget
            NextEventWidget(
              nextEvent: _getNextEvent(),
              weekNumber: 5,
              onTap: () => context.go(RouteConstants.timetable),
            ),
            
            // New Features Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _NewFeaturesSection(),
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
          ],
        ),
      ),
    );
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
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(userProvider.user?.fullName ?? 'User Profile'),
              subtitle: Text(userProvider.user?.email ?? ''),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go(RouteConstants.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                userProvider.logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NewFeaturesSection extends StatelessWidget {
  const _NewFeaturesSection();

  @override
  Widget build(BuildContext context) {
    final newFeatures = [
      {
        'title': 'Room Booking',
        'subtitle': 'Reserve study rooms & facilities',
        'icon': Icons.event_available,
        'color': AppColors.primary,
        'route': RouteConstants.booking,
      },
      {
        'title': 'Laundry Status',
        'subtitle': 'Check machine availability',
        'icon': Icons.local_laundry_service,
        'color': AppColors.secondaryOrange,
        'route': RouteConstants.laundry,
      },
      {
        'title': 'Print Documents',
        'subtitle': 'Submit print jobs anywhere',
        'icon': Icons.print,
        'color': AppColors.secondaryPurple,
        'route': RouteConstants.print,
      },
      {
        'title': 'Campus Events',
        'subtitle': 'Discover activities & clubs',
        'icon': Icons.event,
        'color': AppColors.info,
        'route': RouteConstants.events,
      },
      {
        'title': 'A/C Management',
        'subtitle': 'Monitor & top up A/C credit',
        'icon': Icons.ac_unit,
        'color': AppColors.primary,
        'route': RouteConstants.acManagement,
      },
      {
        'title': 'Visitor Registration',
        'subtitle': 'Register guests with NFC',
        'icon': Icons.person_add,
        'color': AppColors.secondaryOrange,
        'route': RouteConstants.visitorRegistration,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Enhanced Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150, // Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newFeatures.length,
            padding: const EdgeInsets.only(left: 4, right: 4), // Add padding to prevent clipping
            itemBuilder: (context, index) {
              final feature = newFeatures[index];
              return Container(
                width: 160, // Optimized width for better fit
                margin: EdgeInsets.only(right: index == newFeatures.length - 1 ? 0 : 12),
                child: Card(
                  elevation: 6, // Increased elevation for better contrast
                  shadowColor: Colors.black.withOpacity(0.3),
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: (feature['color'] as Color).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => context.go(feature['route'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (feature['color'] as Color).withOpacity(0.15),
                                  (feature['color'] as Color).withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (feature['color'] as Color).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              feature['icon'] as IconData,
                              color: feature['color'] as Color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  feature['title'] as String,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  feature['subtitle'] as String,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 11,
                                    height: 1.15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GridSection extends StatelessWidget {
  const _GridSection();

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      // New enhanced features
      {
        'title': 'Room Booking',
        'icon': Icons.event_available,
        'route': RouteConstants.booking,
      },
      {
        'title': 'Laundry Status',
        'icon': Icons.local_laundry_service,
        'route': RouteConstants.laundry,
      },
      {
        'title': 'Print Documents',
        'icon': Icons.print,
        'route': RouteConstants.print,
      },
      {
        'title': 'Campus Events',
        'icon': Icons.event,
        'route': RouteConstants.events,
      },
      // Existing features
      {
        'title': 'Student Life',
        'icon': Icons.groups,
        'route': RouteConstants.studentLife,
      },
      {
        'title': 'Campus',
        'icon': Icons.location_city,
        'route': RouteConstants.campus,
      },
      {
        'title': 'Grade Report',
        'icon': Icons.assessment,
        'route': RouteConstants.gradeReport,
      },
      {
        'title': 'Important Contacts',
        'icon': Icons.contacts,
        'route': RouteConstants.contacts,
      },
      {
        'title': 'News',
        'icon': Icons.newspaper,
        'route': RouteConstants.news,
      },
      {
        'title': 'CityU CAP',
        'icon': Icons.school,
        'route': RouteConstants.cap,
      },
      {
        'title': 'CityUTube',
        'icon': Icons.play_circle,
        'route': RouteConstants.cityuTube,
      },
      {
        'title': 'Room Availability',
        'icon': Icons.meeting_room,
        'route': RouteConstants.roomAvailability,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid based on screen width
            final screenWidth = constraints.maxWidth;
            final crossAxisCount = screenWidth > 600 ? 3 : 2;
            final childAspectRatio = screenWidth > 600 ? 1.5 : 1.4;
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
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
                // Navigate to respective page
                final route = item['route'] as String;
                context.go(route);
              },
            );
          },
            );
          },
        ),
      ],
    );
  }
}

class _FeedsSection extends StatefulWidget {
  const _FeedsSection();

  @override
  State<_FeedsSection> createState() => _FeedsSectionState();
}

class _FeedsSectionState extends State<_FeedsSection> {
  int _newsCount = 5;
  int _capCount = 5;
  int _videoCount = 5;
  bool _isLoading = false;

  Future<void> _loadMore(String section) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      switch (section) {
        case 'news':
          _newsCount = (_newsCount + 5).clamp(0, MockJsonData.newsFeed.length);
          break;
        case 'cap':
          _capCount = (_capCount + 5).clamp(0, MockJsonData.capActivities.length);
          break;
        case 'video':
          _videoCount = (_videoCount + 5).clamp(0, MockJsonData.cityuTubeVideos.length);
          break;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Updates',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildNewsFeedSection(context),
        const SizedBox(height: 24),
        _buildCapFeedSection(context),
        const SizedBox(height: 24),
        _buildCityUTubeFeedSection(context),
      ],
    );
  }

  Widget _buildFooterButton({required bool canLoadMore, required VoidCallback onLoadMore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: canLoadMore ? onLoadMore : null,
                child: const Text('Load More'),
              ),
            ),
    );
  }

  Widget _buildNewsFeedSection(BuildContext context) {
    final total = MockJsonData.newsFeed.length;
    final newsItems = MockJsonData.newsFeed.take(_newsCount).toList();
    final canLoadMore = _newsCount < total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.newspaper, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'News',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(RouteConstants.news),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...newsItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              title: Text(
                item['title'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                item['category'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go(RouteConstants.news),
            ),
          ),
        )),
        _buildFooterButton(
          canLoadMore: canLoadMore,
          onLoadMore: () => _loadMore('news'),
        ),
      ],
    );
  }

  Widget _buildCapFeedSection(BuildContext context) {
    final total = MockJsonData.capActivities.length;
    final capItems = MockJsonData.capActivities.take(_capCount).toList();
    final canLoadMore = _capCount < total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.school, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'CAP Activities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(RouteConstants.cap),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...capItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              title: Text(
                item['title'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                '${item['category']} • Spots: ${item['spotsAvailable']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryOrange,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go(RouteConstants.cap),
            ),
          ),
        )),
        _buildFooterButton(
          canLoadMore: canLoadMore,
          onLoadMore: () => _loadMore('cap'),
        ),
      ],
    );
  }

  Widget _buildCityUTubeFeedSection(BuildContext context) {
    final total = MockJsonData.cityuTubeVideos.length;
    final videoItems = MockJsonData.cityuTubeVideos.take(_videoCount).toList();
    final canLoadMore = _videoCount < total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.play_circle, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'CityUTube',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(RouteConstants.cityuTube),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...videoItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.play_arrow, color: AppColors.primary),
              ),
              title: Text(
                item['title'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                '${item['duration']} • ${item['views']} views',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go(RouteConstants.cityuTube),
            ),
          ),
        )),
        _buildFooterButton(
          canLoadMore: canLoadMore,
          onLoadMore: () => _loadMore('video'),
        ),
      ],
    );
  }
}

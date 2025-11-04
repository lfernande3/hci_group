import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../widgets/next_event_widget.dart';
import '../widgets/grid_item_widget.dart';
import '../widgets/loading_widget.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/route_constants.dart';
import '../../data/mocks/mock_json_data.dart';

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

class _GridSection extends StatelessWidget {
  const _GridSection();

  @override
  Widget build(BuildContext context) {
    final gridItems = [
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

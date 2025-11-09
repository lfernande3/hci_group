import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Core imports
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/data/mocks/mock_json_data.dart';
import '../../../../core/presentation/widgets/next_event_widget.dart';
import '../../../../core/presentation/widgets/grid_item_widget.dart';
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
              final isLoggedIn = userProvider.isLoggedIn;
              final buttonText = isLoggedIn 
                  ? (userProvider.user?.fullName ?? 'User')
                  : 'Login';
              final buttonColor = isLoggedIn 
                  ? AppColors.primary // Burgundy when logged in
                  : AppColors.secondaryOrange; // Orange when not logged in
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => context.go(RouteConstants.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
            
            // Quick Access Buttons (WeChat-style)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _QuickAccessButtons(),
            ),
            
            // Student Life Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _StudentLifeSection(),
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
}

class _QuickAccessButtons extends StatelessWidget {
  const _QuickAccessButtons();

  @override
  Widget build(BuildContext context) {
    // Row 1: Booking, Print, Laundry, A/C
    final row1Buttons = [
      {
        'title': 'Booking',
        'icon': Icons.event_available,
        'color': AppColors.primary,
        'route': RouteConstants.booking,
      },
      {
        'title': 'Print',
        'icon': Icons.print,
        'color': AppColors.secondaryPurple,
        'route': RouteConstants.print,
      },
      {
        'title': 'Laundry',
        'icon': Icons.local_laundry_service,
        'color': AppColors.secondaryOrange,
        'route': RouteConstants.laundry,
      },
      {
        'title': 'A/C',
        'icon': Icons.ac_unit,
        'color': AppColors.primary,
        'route': RouteConstants.acManagement,
      },
    ];

    // Row 2: Events, Visitor Registration, Grade Report, Campus Map
    final row2Buttons = [
      {
        'title': 'Events',
        'icon': Icons.event,
        'color': AppColors.info,
        'route': RouteConstants.events,
      },
      {
        'title': 'Visitor Registration',
        'icon': Icons.person_add,
        'color': AppColors.secondaryOrange,
        'route': RouteConstants.visitorRegistration,
      },
      {
        'title': 'Grade Report',
        'icon': Icons.assessment,
        'color': AppColors.primary,
        'route': RouteConstants.gradeReport,
      },
      {
        'title': 'Campus Map',
        'icon': Icons.map,
        'color': AppColors.info,
        'route': RouteConstants.campusMap,
      },
    ];

    return Column(
      children: [
        // Row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row1Buttons.map((button) {
            return Expanded(
              child: _buildButton(
                context,
                title: button['title'] as String,
                icon: button['icon'] as IconData,
                color: button['color'] as Color,
                route: button['route'] as String,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row2Buttons.map((button) {
            return Expanded(
              child: _buildButton(
                context,
                title: button['title'] as String,
                icon: button['icon'] as IconData,
                color: button['color'] as Color,
                route: button['route'] as String,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular icon container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          // Title text
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StudentLifeSection extends StatelessWidget {
  const _StudentLifeSection();

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {
        'title': 'Emergency Support',
        'icon': Icons.emergency,
        'color': AppColors.error,
        'route': RouteConstants.emergency,
      },
      {
        'title': 'CRESDA',
        'icon': Icons.business_center,
        'color': AppColors.primary,
        'route': RouteConstants.cresda,
      },
      {
        'title': 'Student Services',
        'icon': Icons.school,
        'color': AppColors.info,
        'route': RouteConstants.studentServices,
      },
      {
        'title': 'Student Feedback',
        'icon': Icons.feedback,
        'color': AppColors.secondaryOrange,
        'route': RouteConstants.studentFeedback,
      },
      {
        'title': 'Counselling Services',
        'icon': Icons.psychology,
        'color': AppColors.secondaryPurple,
        'route': RouteConstants.counsellingServices,
      },
      {
        'title': 'My Privileges',
        'icon': Icons.card_membership,
        'color': AppColors.primary,
        'route': RouteConstants.myPrivileges,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Life',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Arrange buttons in rows of 2
        ...List.generate(
          (buttons.length / 2).ceil(),
          (rowIndex) {
            final startIndex = rowIndex * 2;
            final endIndex = (startIndex + 2).clamp(0, buttons.length);
            final rowButtons = buttons.sublist(startIndex, endIndex);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      context,
                      title: rowButtons[0]['title'] as String,
                      icon: rowButtons[0]['icon'] as IconData,
                      color: rowButtons[0]['color'] as Color,
                      route: rowButtons[0]['route'] as String,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (rowButtons.length > 1)
                    Expanded(
                      child: _buildButton(
                        context,
                        title: rowButtons[1]['title'] as String,
                        icon: rowButtons[1]['icon'] as IconData,
                        color: rowButtons[1]['color'] as Color,
                        route: rowButtons[1]['route'] as String,
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Circular icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Title text
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
      // Existing features (duplicates removed - now in Quick Access Buttons above)
      {
        'title': 'Campus',
        'icon': Icons.location_city,
        'route': RouteConstants.campus,
      },
      {
        'title': 'Contacts',
        'icon': Icons.contacts,
        'route': RouteConstants.contacts,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
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

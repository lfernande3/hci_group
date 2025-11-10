import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../utils/date_utils.dart';
import '../../../features/events/domain/entities/event.dart';

/// Next event widget for homepage
class NextEventWidget extends StatelessWidget {
  final Event? nextEvent;
  final int? weekNumber;
  final VoidCallback? onTap;

  const NextEventWidget({
    super.key,
    this.nextEvent,
    this.weekNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
        child: Container(
        height: _getResponsiveHeight(context), // Responsive height
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // CityU gradient background - orange to burgundy
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.0, 0.6], // Later gradient point
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
        child: Stack(
          children: [
            // Week number in top right - more compact
            if (weekNumber != null)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'W$weekNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: nextEvent != null 
                  ? _buildEventContent(context, nextEvent!)
                  : _buildPlaceholderContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventContent(BuildContext context, Event event) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Event type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.secondaryOrange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            event.type.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Event title
        Text(
          event.title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Course code if available - inline with title
        if (event.courseCode != null) ...[
          const SizedBox(height: 3),
          Text(
            event.courseCode!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
        ],
        
        const Spacer(),
        
        // Time and location info - more compact
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${AppDateUtils.getRelativeDateString(event.startTime)} at ${AppDateUtils.formatTime(event.startTime)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 3),
        
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                event.room != null 
                    ? '${event.location}, ${event.room}'
                    : event.location,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 2),
        
        // Tap hint - smaller and more subtle
        Text(
          'Tap to view timetable',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
            fontSize: 9,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.event_available,
          size: 40,
          color: Colors.white.withOpacity(0.6),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Welcome back to CityUHK Mobile',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'No upcoming events found.\nYour next class or event will appear here.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        
        const Spacer(),
        
        Text(
          'Tap to view full timetable',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  /// Get responsive height based on screen size
  double _getResponsiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adjust height based on screen size and orientation - further reduced for more compact layout
    if (screenWidth > 600) {
      // Tablet or larger screens
      return screenHeight * 0.20;
    } else if (screenHeight < 700) {
      // Smaller phone screens
      return screenHeight * 0.20;
    } else {
      // Default phone screens - reduced from 0.28 to 0.22
      return screenHeight * 0.22;
    }
  }
}

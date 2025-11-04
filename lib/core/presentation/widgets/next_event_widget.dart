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
        margin: const EdgeInsets.all(16),
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
            // Week number in top right
            if (weekNumber != null)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'W$weekNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(24),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondaryOrange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.type.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.secondaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Event title
        Text(
          event.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Course code if available
        if (event.courseCode != null)
          Text(
            event.courseCode!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        
        const Spacer(),
        
        // Time and location info
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 20,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${AppDateUtils.getRelativeDateString(event.startTime)} at ${AppDateUtils.formatTime(event.startTime)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 20,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.room != null 
                    ? '${event.location}, ${event.room}'
                    : event.location,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Tap hint
        Text(
          'Tap to view timetable',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
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
          size: 48,
          color: Colors.white.withOpacity(0.6),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Welcome back to CityUHK Mobile',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
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
    
    // Adjust height based on screen size and orientation
    if (screenWidth > 600) {
      // Tablet or larger screens
      return screenHeight * 0.35;
    } else if (screenHeight < 700) {
      // Smaller phone screens
      return screenHeight * 0.35;
    } else {
      // Default phone screens
      return screenHeight * 0.4;
    }
  }
}

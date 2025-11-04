import 'package:flutter/material.dart';
import '../../../../data/demo/events_data.dart';

/// Event Detail View page showing full event information
class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        // AppTheme automatically applied
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Header Card
            _EventHeaderCard(
              event: event,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),

            // Event Information Card
            _EventInfoCard(
              event: event,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),

            // Description Card (if available)
            if (event.description != null) ...[
              _DescriptionCard(
                description: event.description!,
                theme: theme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            _ActionButtonsSection(
              event: event,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Event Header Card
class _EventHeaderCard extends StatelessWidget {
  final Event event;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _EventHeaderCard({
    required this.event,
    required this.theme,
    required this.colorScheme,
  });

  String _getCategoryLabel(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return 'Academic';
      case EventCategory.sports:
        return 'Sports';
      case EventCategory.cultural:
        return 'Cultural';
    }
  }

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return colorScheme.primary;
      case EventCategory.sports:
        return Colors.orange;
      case EventCategory.cultural:
        return Colors.purple;
    }
  }

  String _getRegistrationStatusLabel(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.open:
        return 'Open';
      case RegistrationStatus.closed:
        return 'Closed';
      case RegistrationStatus.waitlist:
        return 'Waitlist';
    }
  }

  Color _getRegistrationStatusColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.open:
        return Colors.green;
      case RegistrationStatus.closed:
        return Colors.grey;
      case RegistrationStatus.waitlist:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              event.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Organizer
            Row(
              children: [
                Icon(
                  Icons.group,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  event.organizer,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(event.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryLabel(event.category),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _getCategoryColor(event.category),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Registration status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getRegistrationStatusColor(event.registrationStatus)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getRegistrationStatusLabel(event.registrationStatus),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _getRegistrationStatusColor(event.registrationStatus),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Language badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.language == EventLanguage.en ? 'EN' : 'ZH',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                // Source badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.source,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Event Information Card
class _EventInfoCard extends StatelessWidget {
  final Event event;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _EventInfoCard({
    required this.event,
    required this.theme,
    required this.colorScheme,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (eventDate == today) {
      return 'Today, ${_formatTime(dateTime)}';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatTime(dateTime)}';
    } else {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final weekday = weekdays[dateTime.weekday - 1];
      return '$weekday, ${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Start Time
            _InfoRow(
              icon: Icons.access_time,
              label: 'Start Time',
              value: _formatDateTime(event.startTime),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            
            // End Time
            _InfoRow(
              icon: Icons.access_time_filled,
              label: 'End Time',
              value: _formatDateTime(event.endTime),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            
            // Duration
            _InfoRow(
              icon: Icons.schedule,
              label: 'Duration',
              value: _formatDuration(event.startTime, event.endTime),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            
            // Venue
            _InfoRow(
              icon: Icons.location_on,
              label: 'Venue',
              value: event.venue,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Info Row
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget for Description Card
class _DescriptionCard extends StatelessWidget {
  final String description;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _DescriptionCard({
    required this.description,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Action Buttons Section
class _ActionButtonsSection extends StatelessWidget {
  final Event event;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _ActionButtonsSection({
    required this.event,
    required this.theme,
    required this.colorScheme,
  });

  void _handleRegister(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Successfully registered for "${event.title}" (demo)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleAddToCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added "${event.title}" to calendar (demo)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canRegister = event.registrationStatus == RegistrationStatus.open ||
        event.registrationStatus == RegistrationStatus.waitlist;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Register Button
        if (canRegister)
          ElevatedButton.icon(
            onPressed: () => _handleRegister(context),
            icon: const Icon(Icons.how_to_reg),
            label: Text(
              event.registrationStatus == RegistrationStatus.waitlist
                  ? 'Join Waitlist'
                  : 'Register',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.how_to_reg),
            label: const Text('Registration Closed'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        const SizedBox(height: 12),
        
        // Add to Calendar Button
        OutlinedButton.icon(
          onPressed: () => _handleAddToCalendar(context),
          icon: const Icon(Icons.calendar_today),
          label: const Text('Add to Calendar'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import '../../data/datasources/booking_storage_service.dart';
import '../../data/models/saved_booking_model.dart';

/// My Bookings page - displays all saved bookings
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final BookingStorageService _storage = BookingStorageService();
  List<SavedBookingModel> _bookings = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'upcoming', 'past'

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final bookings = await _storage.getAllBookings();
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bookings: $e')),
        );
      }
    }
  }

  List<SavedBookingModel> get _filteredBookings {
    switch (_filter) {
      case 'upcoming':
        return _bookings.where((b) => b.isUpcoming).toList();
      case 'past':
        return _bookings.where((b) => b.isPast).toList();
      default:
        return _bookings;
    }
  }

  Future<void> _deleteBooking(SavedBookingModel booking) async {
    try {
      await _storage.deleteBooking(booking.id);
      await _loadBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete booking: $e')),
        );
      }
    }
  }

  void _confirmDelete(SavedBookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text('Are you sure you want to delete the booking for ${booking.roomName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBooking(booking);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          if (_bookings.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Bookings'),
                    content: const Text('Are you sure you want to delete all bookings?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _storage.clearAllBookings();
                          _loadBookings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Upcoming',
                  isSelected: _filter == 'upcoming',
                  onTap: () => setState(() => _filter = 'upcoming'),
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Past',
                  isSelected: _filter == 'past',
                  onTap: () => setState(() => _filter = 'past'),
                  theme: theme,
                ),
              ],
            ),
          ),
          // Bookings list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBookings.isEmpty
                    ? _buildEmptyState(context, theme, colorScheme)
                    : RefreshIndicator(
                        onRefresh: _loadBookings,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = _filteredBookings[index];
                            return _BookingCard(
                              booking: booking,
                              onDelete: () => _confirmDelete(booking),
                              theme: theme,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final String message;
    final IconData icon;

    switch (_filter) {
      case 'upcoming':
        message = 'No upcoming bookings';
        icon = Icons.event_available;
        break;
      case 'past':
        message = 'No past bookings';
        icon = Icons.history;
        break;
      default:
        message = 'No bookings yet';
        icon = Icons.event_note;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a room to see it here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Booking card widget
class _BookingCard extends StatelessWidget {
  final SavedBookingModel booking;
  final VoidCallback onDelete;
  final ThemeData theme;

  const _BookingCard({
    required this.booking,
    required this.onDelete,
    required this.theme,
  });

  IconData _getRoomIcon(String roomType) {
    switch (roomType) {
      case 'study':
        return Icons.library_books;
      case 'classroom':
        return Icons.school;
      case 'sports':
        return Icons.sports_soccer;
      case 'music':
        return Icons.music_note;
      default:
        return Icons.meeting_room;
    }
  }

  Color _getStatusColor(SavedBookingModel booking, ColorScheme colorScheme) {
    if (booking.isActive) {
      return Colors.green;
    } else if (booking.isUpcoming) {
      return colorScheme.primary;
    } else {
      return colorScheme.onSurface.withOpacity(0.3);
    }
  }

  String _getStatusText(SavedBookingModel booking) {
    if (booking.isActive) {
      return 'Active Now';
    } else if (booking.isUpcoming) {
      return 'Upcoming';
    } else {
      return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(booking, colorScheme);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Room name and delete button
            Row(
              children: [
                Icon(
                  _getRoomIcon(booking.roomType),
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.roomName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.roomLocation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.red,
                  tooltip: 'Delete booking',
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Divider(color: colorScheme.outline.withOpacity(0.2)),
            const SizedBox(height: 12),
            // Booking details
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.calendar_today,
                    label: booking.formattedDate,
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.access_time,
                    label: booking.formattedTimeRange,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    booking.isActive
                        ? Icons.play_circle_filled
                        : booking.isUpcoming
                            ? Icons.schedule
                            : Icons.check_circle,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getStatusText(booking),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Detail item widget (used for date and time)
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


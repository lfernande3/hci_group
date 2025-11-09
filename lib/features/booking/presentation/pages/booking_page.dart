import 'package:flutter/material.dart';
import '../../../../data/demo/booking_data.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../data/datasources/booking_storage_service.dart';
import '../../data/datasources/favorites_storage_service.dart';
import '../../data/models/saved_booking_model.dart';
import 'my_bookings_page.dart';

/// Booking Services page with TabBar for different room types
class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              // TabBar with 4 tabs
              TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.library_books),
                  text: 'Study Rooms',
                ),
                Tab(
                  icon: Icon(Icons.school),
                  text: 'Classrooms',
                ),
                Tab(
                  icon: Icon(Icons.sports_soccer),
                  text: 'Sports Facilities',
                ),
                Tab(
                  icon: Icon(Icons.music_note),
                  text: 'Music Rooms',
                ),
              ],
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
            ),
            // TabBarView content
            Expanded(
              child: TabBarView(
                children: [
                  _RoomTypeTabView(roomType: RoomType.study),
                  _RoomTypeTabView(roomType: RoomType.classroom),
                  _RoomTypeTabView(roomType: RoomType.sports),
                  _RoomTypeTabView(roomType: RoomType.music),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyBookingsPage()),
          );
        },
        tooltip: 'My Bookings',
        child: const Icon(Icons.event_note),
      ),
    );
  }
}

/// Tab view for a specific room type
/// Shows timetable grid with room availability
class _RoomTypeTabView extends StatefulWidget {
  final RoomType roomType;

  const _RoomTypeTabView({required this.roomType});

  @override
  State<_RoomTypeTabView> createState() => _RoomTypeTabViewState();
}

class _RoomTypeTabViewState extends State<_RoomTypeTabView> {
  String? _selectedSlotKey; // Format: "roomId-startTime"
  bool _showFavoritesOnly = false;
  Set<String> _favoriteRoomIds = {};
  final _favoritesService = FavoritesStorageService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteRoomIds = favorites.toSet();
        });
      }
    } catch (e) {
      // Silently fail for demo
    }
  }

  Future<void> _toggleFavorite(String roomId) async {
    try {
      final newStatus = await _favoritesService.toggleFavorite(roomId);
      if (mounted) {
        setState(() {
          if (newStatus) {
            _favoriteRoomIds.add(roomId);
          } else {
            _favoriteRoomIds.remove(roomId);
          }
        });
      }
    } catch (e) {
      // Silently fail for demo
      debugPrint('Failed to toggle favorite: $e');
    }
  }

  List<Room> get _allRooms {
    switch (widget.roomType) {
      case RoomType.study:
        return studyRooms;
      case RoomType.classroom:
        return classroomRooms;
      case RoomType.sports:
        return sportsRooms;
      case RoomType.music:
        return musicRooms;
    }
  }

  List<Room> get _rooms {
    if (_showFavoritesOnly) {
      return _allRooms.where((room) => _favoriteRoomIds.contains(room.id)).toList();
    }
    return _allRooms;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDate = DateTime.now(); // Use today for demo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend with favorites switch inline
        _buildLegend(context, theme, colorScheme),
        // Timetable Grid
        Expanded(
          child: _rooms.isEmpty && _showFavoritesOnly
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorite rooms',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the star icon on a room to add it to favorites',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : _TimetableGrid(
                  rooms: _rooms,
                  selectedDate: selectedDate,
                  selectedSlotKey: _selectedSlotKey,
                  favoriteRoomIds: _favoriteRoomIds,
                  onSlotTap: (slotKey) {
                    _showBookingConfirmation(context, slotKey, selectedDate);
                  },
                  onFavoriteToggle: _toggleFavorite,
                ),
        ),
      ],
    );
  }


  Widget _buildLegend(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _LegendItem(
                    icon: Icons.add_circle_outline,
                    iconColor: Colors.green.shade700,
                    backgroundColor: Colors.green.withOpacity(0.3),
                    label: 'Available',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _LegendItem(
                    icon: Icons.block,
                    iconColor: colorScheme.onSurface.withOpacity(0.3),
                    backgroundColor: colorScheme.surfaceVariant,
                    label: 'Booked',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _LegendItem(
                    icon: Icons.check_circle,
                    iconColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                    label: 'Selected',
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
          // Favorites filter toggle inline with legend
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: _showFavoritesOnly 
                    ? Colors.amber 
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Switch(
                value: _showFavoritesOnly,
                onChanged: (value) {
                  setState(() {
                    _showFavoritesOnly = value;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(
    BuildContext context,
    String slotKey,
    DateTime selectedDate,
  ) {
    // Parse slot key: "roomId___startTime" (using ___ as delimiter to avoid conflicts with room IDs containing hyphens)
    final parts = slotKey.split('___');
    if (parts.length != 2) return;

    final roomId = parts[0];
    final startTimeMs = int.tryParse(parts[1]);
    if (startTimeMs == null) return;

    final startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMs);
    final endTime = startTime.add(const Duration(minutes: 30));

    // Find room
    final room = _rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => _rooms.first,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.event_seat, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Confirm Booking'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room details
            _BookingDetailRow(
              icon: Icons.meeting_room,
              label: 'Room',
              value: room.name,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _BookingDetailRow(
              icon: Icons.location_on,
              label: 'Location',
              value: room.location,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _BookingDetailRow(
              icon: Icons.people,
              label: 'Capacity',
              value: '${room.capacity} people',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _BookingDetailRow(
              icon: Icons.access_time,
              label: 'Time Slot',
              value: DateTimeFormatter.formatTimeRange(startTime, endTime),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _BookingDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateTimeFormatter.formatDate(selectedDate),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a demo booking. No actual reservation will be made.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selectedSlotKey = slotKey;
              });
              _saveBooking(context, room, startTime, endTime, selectedDate);
              _showBookingSuccess(context, room.name, startTime, endTime);
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBooking(
    BuildContext context,
    Room room,
    DateTime startTime,
    DateTime endTime,
    DateTime selectedDate,
  ) async {
    try {
      final bookingId = '${room.id}_${startTime.millisecondsSinceEpoch}';
      final booking = SavedBookingModel(
        id: bookingId,
        roomId: room.id,
        roomName: room.name,
        roomLocation: room.location,
        roomCapacity: room.capacity,
        roomType: room.type.name,
        bookingDate: selectedDate,
        startTime: startTime,
        endTime: endTime,
        createdAt: DateTime.now(),
      );

      final storage = BookingStorageService();
      await storage.saveBooking(booking);
    } catch (e) {
      // Silently fail for demo purposes
      debugPrint('Failed to save booking: $e');
    }
  }

  void _showBookingSuccess(
    BuildContext context,
    String roomName,
    DateTime startTime,
    DateTime endTime,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).clearSnackBars(); // Clear any existing snackbars
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Confirmed!',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$roomName • ${DateTimeFormatter.formatTimeRange(startTime, endTime)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
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

}

/// Widget for displaying booking detail rows in confirmation modal
class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

/// Widget for displaying legend items
class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String label;
  final ThemeData theme;

  const _LegendItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: iconColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 12,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Timetable Grid Widget
/// Shows rooms as rows and time slots as columns
class _TimetableGrid extends StatelessWidget {
  final List<Room> rooms;
  final DateTime selectedDate;
  final String? selectedSlotKey;
  final Function(String) onSlotTap;
  final Set<String> favoriteRoomIds;
  final Function(String) onFavoriteToggle;

  const _TimetableGrid({
    required this.rooms,
    required this.selectedDate,
    this.selectedSlotKey,
    required this.onSlotTap,
    required this.favoriteRoomIds,
    required this.onFavoriteToggle,
  });

  // Generate time slots: 9:00 AM to 6:00 PM (30-min increments)
  List<String> get _timeSlots {
    final slots = <String>[];
    for (int hour = 9; hour < 18; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}:00');
      slots.add('${hour.toString().padLeft(2, '0')}:30');
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with time slots
            _buildHeaderRow(context, theme.textTheme, colorScheme),
            // Room rows
            ...rooms.map((room) => _buildRoomRow(
                  context,
                  theme.textTheme,
                  colorScheme,
                  room,
                  selectedDate,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          // Room name column header
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                'Room',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
          // Time slot headers
          ..._timeSlots.map((time) => Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Center(
                  child: Text(
                    time.substring(0, 5), // Show "09:00" format
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRoomRow(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    Room room,
    DateTime date,
  ) {
    final slots = getSlotsForRoomOn(date, room.id);
    final slotMap = {for (var slot in slots) _slotKey(room.id, slot.start): slot};

    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Room name and location with favorite button
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                right: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Favorite button
                    GestureDetector(
                      onTap: () => onFavoriteToggle(room.id),
                      child: Icon(
                        favoriteRoomIds.contains(room.id)
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: favoriteRoomIds.contains(room.id)
                            ? Colors.amber
                            : colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    room.location,
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Time slot cells
          ..._timeSlots.map((time) {
            final slotStart = _parseTimeSlot(date, time);
            final slotKey = _slotKey(room.id, slotStart);
            final slot = slotMap[slotKey];
            final isBooked = slot?.isBooked ?? false;
            final isSelected = selectedSlotKey == slotKey;

            return _buildSlotCell(
              context,
              textTheme,
              colorScheme,
              isBooked: isBooked,
              isSelected: isSelected,
              onTap: () => onSlotTap(slotKey),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSlotCell(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme, {
    required bool isBooked,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color borderColor;
    Widget? icon;

    if (isSelected) {
      backgroundColor = colorScheme.primary;
      borderColor = colorScheme.primary;
      icon = Icon(
        Icons.check_circle,
        size: 20,
        color: colorScheme.onPrimary,
      );
    } else if (isBooked) {
      backgroundColor = colorScheme.surfaceVariant;
      borderColor = colorScheme.outline.withOpacity(0.2);
      icon = Icon(
        Icons.block,
        size: 16,
        color: colorScheme.onSurface.withOpacity(0.5),
      );
    } else {
      backgroundColor = Colors.green.withOpacity(0.3);
      borderColor = Colors.green.withOpacity(0.4);
      icon = Icon(
        Icons.add_circle_outline,
        size: 16,
        color: Colors.green.shade700,
      );
    }

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          color: backgroundColor,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }

  DateTime _parseTimeSlot(DateTime date, String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String _slotKey(String roomId, DateTime start) {
    return '${roomId}___${start.millisecondsSinceEpoch}';
  }
}


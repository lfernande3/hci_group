import 'package:flutter/material.dart';
import '../../../../data/demo/booking_data.dart';

/// Booking Services page with TabBar for different room types
class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Services'),
        // AppTheme automatically applied
      ),
      body: DefaultTabController(
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

  String get _roomTypeLabel {
    switch (widget.roomType) {
      case RoomType.study:
        return 'Study Rooms';
      case RoomType.classroom:
        return 'Classrooms';
      case RoomType.sports:
        return 'Sports Facilities';
      case RoomType.music:
        return 'Music Rooms';
    }
  }

  List<Room> get _rooms {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDate = DateTime.now(); // Use today for demo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: colorScheme.surfaceVariant,
          child: Row(
            children: [
              Text(
                _roomTypeLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(selectedDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        // Timetable Grid
        Expanded(
          child: _TimetableGrid(
            rooms: _rooms,
            selectedDate: selectedDate,
            selectedSlotKey: _selectedSlotKey,
            onSlotTap: (slotKey) {
              _showBookingConfirmation(context, slotKey, selectedDate);
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month}';
  }

  void _showBookingConfirmation(
    BuildContext context,
    String slotKey,
    DateTime selectedDate,
  ) {
    // Parse slot key: "roomId-startTime"
    final parts = slotKey.split('-');
    if (parts.length < 2) return;

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
              value: '${_formatTime(startTime)} - ${_formatTime(endTime)}',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _BookingDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: _formatDate(selectedDate),
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
              _showBookingSuccess(context, room.name, startTime, endTime);
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess(
    BuildContext context,
    String roomName,
    DateTime startTime,
    DateTime endTime,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    '$roomName • ${_formatTime(startTime)} - ${_formatTime(endTime)}',
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

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
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

/// Timetable Grid Widget
/// Shows rooms as rows and time slots as columns
class _TimetableGrid extends StatelessWidget {
  final List<Room> rooms;
  final DateTime selectedDate;
  final String? selectedSlotKey;
  final Function(String) onSlotTap;

  const _TimetableGrid({
    required this.rooms,
    required this.selectedDate,
    this.selectedSlotKey,
    required this.onSlotTap,
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
                      fontSize: 10,
                      color: colorScheme.onSurface.withOpacity(0.6),
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
          // Room name and location
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
                Text(
                  room.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                      fontSize: 9,
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

    if (isSelected) {
      backgroundColor = colorScheme.primary;
      borderColor = colorScheme.primary;
    } else if (isBooked) {
      backgroundColor = colorScheme.surfaceVariant;
      borderColor = colorScheme.outline.withOpacity(0.2);
    } else {
      backgroundColor = Colors.green.withOpacity(0.2);
      borderColor = Colors.green.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                size: 16,
                color: colorScheme.onPrimary,
              )
            : null,
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
    return '$roomId-${start.millisecondsSinceEpoch}';
  }
}


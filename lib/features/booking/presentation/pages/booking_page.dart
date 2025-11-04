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
/// Shows placeholder content until timetable grid is implemented (T-202)
class _RoomTypeTabView extends StatelessWidget {
  final RoomType roomType;

  const _RoomTypeTabView({required this.roomType});

  String get _roomTypeLabel {
    switch (roomType) {
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
    switch (roomType) {
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

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _roomTypeLabel,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_rooms.length} rooms available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder for timetable grid (T-202)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_view_week,
                    size: 64,
                    color: colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Timetable Grid Coming Soon',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will show room availability in a grid format',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


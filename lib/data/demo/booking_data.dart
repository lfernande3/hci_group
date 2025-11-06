// Demo data for Booking Services (UI-only)

enum RoomType { study, classroom, sports, music }

class Room {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final List<String> tags;
  final RoomType type;

  const Room({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.tags,
    required this.type,
  });
}

class BookingSlot {
  final String roomId;
  final DateTime start;
  final DateTime end;
  final bool isBooked;

  const BookingSlot({
    required this.roomId,
    required this.start,
    required this.end,
    required this.isBooked,
  });
}

// --- Rooms (3+ per category) -------------------------------------------------

const List<Room> studyRooms = [
  Room(
    id: 'SR-LIB-101',
    name: 'Study Room 101',
    location: 'Library 1/F',
    capacity: 4,
    tags: ['Whiteboard', 'Quiet'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-102',
    name: 'Study Room 102',
    location: 'Library 1/F',
    capacity: 6,
    tags: ['Display', 'HDMI'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-103',
    name: 'Study Room 103',
    location: 'Library 1/F',
    capacity: 4,
    tags: ['Whiteboard', 'Quiet'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-201',
    name: 'Study Room 201',
    location: 'Library 2/F',
    capacity: 8,
    tags: ['Group', 'Power'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-202',
    name: 'Study Room 202',
    location: 'Library 2/F',
    capacity: 6,
    tags: ['Display', 'HDMI', 'Whiteboard'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-203',
    name: 'Study Room 203',
    location: 'Library 2/F',
    capacity: 4,
    tags: ['Quiet', 'Power'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-301',
    name: 'Study Room 301',
    location: 'Library 3/F',
    capacity: 10,
    tags: ['Group', 'Display', 'HDMI', 'Whiteboard'],
    type: RoomType.study,
  ),
  Room(
    id: 'SR-LIB-302',
    name: 'Study Room 302',
    location: 'Library 3/F',
    capacity: 6,
    tags: ['Quiet', 'Power'],
    type: RoomType.study,
  ),
];

const List<Room> classroomRooms = [
  Room(
    id: 'CR-AC2-210',
    name: 'AC2-210',
    location: 'AC2 2/F',
    capacity: 24,
    tags: ['Projector', 'Whiteboard'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-AC2-211',
    name: 'AC2-211',
    location: 'AC2 2/F',
    capacity: 20,
    tags: ['Projector', 'Whiteboard', 'AV'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-AC2-311',
    name: 'AC2-311',
    location: 'AC2 3/F',
    capacity: 32,
    tags: ['AV', 'HDMI'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-AC2-312',
    name: 'AC2-312',
    location: 'AC2 3/F',
    capacity: 28,
    tags: ['Projector', 'Whiteboard', 'Mic'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-YEUNG-201',
    name: 'YEUNG-201',
    location: 'Yeung 2/F',
    capacity: 40,
    tags: ['Lecture', 'Mic'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-YEUNG-202',
    name: 'YEUNG-202',
    location: 'Yeung 2/F',
    capacity: 35,
    tags: ['Projector', 'Whiteboard', 'AV'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-AC1-101',
    name: 'AC1-101',
    location: 'AC1 1/F',
    capacity: 50,
    tags: ['Lecture', 'Mic', 'Projector'],
    type: RoomType.classroom,
  ),
  Room(
    id: 'CR-AC3-205',
    name: 'AC3-205',
    location: 'AC3 2/F',
    capacity: 30,
    tags: ['AV', 'HDMI', 'Whiteboard'],
    type: RoomType.classroom,
  ),
];

const List<Room> sportsRooms = [
  Room(
    id: 'SP-GYM-A',
    name: 'Gym Court A',
    location: 'Sports Hall',
    capacity: 10,
    tags: ['Basketball'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-GYM-B',
    name: 'Gym Court B',
    location: 'Sports Hall',
    capacity: 10,
    tags: ['Basketball'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-POOL-L1',
    name: 'Pool Lane 1',
    location: 'Swimming Pool',
    capacity: 1,
    tags: ['Swimming'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-POOL-L2',
    name: 'Pool Lane 2',
    location: 'Swimming Pool',
    capacity: 1,
    tags: ['Swimming'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-POOL-L3',
    name: 'Pool Lane 3',
    location: 'Swimming Pool',
    capacity: 1,
    tags: ['Swimming'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-BADM-1',
    name: 'Badminton Court 1',
    location: 'Sports Hall',
    capacity: 4,
    tags: ['Badminton'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-BADM-2',
    name: 'Badminton Court 2',
    location: 'Sports Hall',
    capacity: 4,
    tags: ['Badminton'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-BADM-3',
    name: 'Badminton Court 3',
    location: 'Sports Hall',
    capacity: 4,
    tags: ['Badminton'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-TT-1',
    name: 'Table Tennis Table 1',
    location: 'Sports Hall',
    capacity: 2,
    tags: ['Table Tennis'],
    type: RoomType.sports,
  ),
  Room(
    id: 'SP-TT-2',
    name: 'Table Tennis Table 2',
    location: 'Sports Hall',
    capacity: 2,
    tags: ['Table Tennis'],
    type: RoomType.sports,
  ),
];

const List<Room> musicRooms = [
  Room(
    id: 'MU-RM-A',
    name: 'Music Room A',
    location: 'Creative Media Centre',
    capacity: 2,
    tags: ['Acoustic'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-RM-B',
    name: 'Music Room B',
    location: 'Creative Media Centre',
    capacity: 2,
    tags: ['Acoustic', 'Guitar'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-PIANO-1',
    name: 'Piano Room 1',
    location: 'Cultural Centre',
    capacity: 1,
    tags: ['Piano'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-PIANO-2',
    name: 'Piano Room 2',
    location: 'Cultural Centre',
    capacity: 1,
    tags: ['Piano'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-PRAC-A',
    name: 'Practice Room A',
    location: 'Creative Media Centre',
    capacity: 1,
    tags: ['Soundproof'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-PRAC-B',
    name: 'Practice Room B',
    location: 'Creative Media Centre',
    capacity: 1,
    tags: ['Soundproof'],
    type: RoomType.music,
  ),
  Room(
    id: 'MU-PRAC-C',
    name: 'Practice Room C',
    location: 'Creative Media Centre',
    capacity: 1,
    tags: ['Soundproof', 'Drum Kit'],
    type: RoomType.music,
  ),
];

final List<Room> allRooms = [
  ...studyRooms,
  ...classroomRooms,
  ...sportsRooms,
  ...musicRooms,
];

// --- Availability Matrix ------------------------------------------------------

/// Generates 30-min slots between [startHour] and [endHour) for a specific day.
List<BookingSlot> _generateSlotsForRoom({
  required DateTime day,
  required String roomId,
  int startHour = 9,
  int endHour = 18,
  Set<int> bookedIndices = const {},
}) {
  final List<BookingSlot> slots = [];
  final DateTime base = DateTime(day.year, day.month, day.day);
  int index = 0;
  for (int hour = startHour; hour < endHour; hour++) {
    for (int minute in [0, 30]) {
      final DateTime start = base.add(Duration(hours: hour, minutes: minute));
      final DateTime end = start.add(const Duration(minutes: 30));
      slots.add(BookingSlot(
        roomId: roomId,
        start: start,
        end: end,
        isBooked: bookedIndices.contains(index),
      ));
      index++;
    }
  }
  return slots;
}

/// A simple availability matrix for today and tomorrow across all rooms.
/// Key = day (DateTime at 00:00), Value = list of all slots for all rooms.
final Map<DateTime, List<BookingSlot>> availabilityMatrix = (() {
  final DateTime today = DateTime.now();
  final DateTime day0 = DateTime(today.year, today.month, today.day);
  final DateTime day1 = day0.add(const Duration(days: 1));

  List<BookingSlot> buildForDay(DateTime day) {
    final List<BookingSlot> result = [];
    for (final room in allRooms) {
      // Vary booked pattern per room type for visual variety
      // More realistic booking patterns with more slots booked
      final Set<int> booked = switch (room.type) {
        RoomType.study => {3, 4, 5, 10, 11, 12, 15, 16, 18, 19}, // midday and afternoon busy
        RoomType.classroom => {0, 1, 2, 12, 13, 14, 15, 20, 21, 22}, // morning and afternoon classes
        RoomType.sports => {6, 7, 8, 9, 10, 17, 18, 19, 22, 23}, // early morning and evening
        RoomType.music => {2, 5, 9, 10, 11, 14, 15, 17, 18, 21, 22}, // scattered throughout day
      };
      result.addAll(_generateSlotsForRoom(
        day: day,
        roomId: room.id,
        bookedIndices: booked,
      ));
    }
    return result;
  }

  return {
    day0: buildForDay(day0),
    day1: buildForDay(day1),
  };
})();

/// Convenience helper to get slots for a specific room on a given day.
List<BookingSlot> getSlotsForRoomOn(DateTime day, String roomId) {
  final DateTime key = DateTime(day.year, day.month, day.day);
  final List<BookingSlot> all = availabilityMatrix[key] ?? const [];
  return all.where((s) => s.roomId == roomId).toList(growable: false);
}



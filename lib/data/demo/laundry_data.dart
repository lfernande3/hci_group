// Demo data for Laundry Management (UI-only)

enum MachineType { washer, dryer }

enum MachineStatus { free, inUse, finishingSoon }

class LaundryRoom {
  final String id;
  final String name;
  final String location;

  const LaundryRoom({
    required this.id,
    required this.name,
    required this.location,
  });
}

class MachineStack {
  final String id;
  final String roomId;
  final String label; // e.g., "Stack A"
  final MachineStatus washerStatus;
  final MachineStatus dryerStatus;
  final int? washerEtaMinutes; // null if free
  final int? dryerEtaMinutes; // null if free

  const MachineStack({
    required this.id,
    required this.roomId,
    required this.label,
    required this.washerStatus,
    required this.dryerStatus,
    this.washerEtaMinutes,
    this.dryerEtaMinutes,
  });
}

// --- Rooms (6+ dorm floors) ----------------------------------------------------

const List<LaundryRoom> halls = [
  LaundryRoom(
    id: 'HALL-8',
    name: 'Hall 8',
    location: 'Student Residence – Tower 8',
  ),
  LaundryRoom(
    id: 'HALL-10',
    name: 'Hall 10',
    location: 'Student Residence – Tower 10',
  ),
  LaundryRoom(
    id: 'HALL-11',
    name: 'Hall 11',
    location: 'Student Residence – Tower 11',
  ),
];

// --- Machine stacks (20+), each with a washer + dryer status -------------------

const List<MachineStack> machines = [
  // Hall 8
  MachineStack(
    id: 'H8-A',
    roomId: 'HALL-8',
    label: 'Stack A',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 12,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-B',
    roomId: 'HALL-8',
    label: 'Stack B',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 3,
    dryerEtaMinutes: 8,
  ),
  MachineStack(
    id: 'H8-C',
    roomId: 'HALL-8',
    label: 'Stack C',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-D',
    roomId: 'HALL-8',
    label: 'Stack D',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 25,
    dryerEtaMinutes: 5,
  ),
  MachineStack(
    id: 'H8-E',
    roomId: 'HALL-8',
    label: 'Stack E',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: null,
    dryerEtaMinutes: 18,
  ),
  MachineStack(
    id: 'H8-F',
    roomId: 'HALL-8',
    label: 'Stack F',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 1,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-G',
    roomId: 'HALL-8',
    label: 'Stack G',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 15,
    dryerEtaMinutes: 22,
  ),
  MachineStack(
    id: 'H8-H',
    roomId: 'HALL-8',
    label: 'Stack H',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-I',
    roomId: 'HALL-8',
    label: 'Stack I',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 8,
    dryerEtaMinutes: 2,
  ),
  MachineStack(
    id: 'H8-J',
    roomId: 'HALL-8',
    label: 'Stack J',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-K',
    roomId: 'HALL-8',
    label: 'Stack K',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 4,
    dryerEtaMinutes: 11,
  ),
  // Hall 10
  MachineStack(
    id: 'H10-A',
    roomId: 'HALL-10',
    label: 'Stack A',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 20,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H10-B',
    roomId: 'HALL-10',
    label: 'Stack B',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: null,
    dryerEtaMinutes: 9,
  ),
  MachineStack(
    id: 'H10-C',
    roomId: 'HALL-10',
    label: 'Stack C',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 6,
    dryerEtaMinutes: 3,
  ),
  MachineStack(
    id: 'H10-D',
    roomId: 'HALL-10',
    label: 'Stack D',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H10-E',
    roomId: 'HALL-10',
    label: 'Stack E',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 17,
    dryerEtaMinutes: 4,
  ),
  MachineStack(
    id: 'H10-F',
    roomId: 'HALL-10',
    label: 'Stack F',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: null,
    dryerEtaMinutes: 14,
  ),
  MachineStack(
    id: 'H10-G',
    roomId: 'HALL-10',
    label: 'Stack G',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 2,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H10-H',
    roomId: 'HALL-10',
    label: 'Stack H',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 30,
    dryerEtaMinutes: 35,
  ),
  MachineStack(
    id: 'H10-I',
    roomId: 'HALL-10',
    label: 'Stack I',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H10-J',
    roomId: 'HALL-10',
    label: 'Stack J',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 13,
    dryerEtaMinutes: 7,
  ),
  MachineStack(
    id: 'H10-K',
    roomId: 'HALL-10',
    label: 'Stack K',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: null,
    dryerEtaMinutes: 16,
  ),
  // Hall 11
  MachineStack(
    id: 'H11-A',
    roomId: 'HALL-11',
    label: 'Stack A',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 5,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H11-B',
    roomId: 'HALL-11',
    label: 'Stack B',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H11-C',
    roomId: 'HALL-11',
    label: 'Stack C',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 19,
    dryerEtaMinutes: 28,
  ),
  MachineStack(
    id: 'H11-D',
    roomId: 'HALL-11',
    label: 'Stack D',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: null,
    dryerEtaMinutes: 1,
  ),
  MachineStack(
    id: 'H11-E',
    roomId: 'HALL-11',
    label: 'Stack E',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 24,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H11-F',
    roomId: 'HALL-11',
    label: 'Stack F',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
];

/// Convenience helpers ---------------------------------------------------------

List<MachineStack> getMachinesForRoom(String roomId) {
  return machines.where((m) => m.roomId == roomId).toList(growable: false);
}

List<MachineStack> filterByStatus(MachineStatus status) {
  return machines.where((m) => m.washerStatus == status || m.dryerStatus == status).toList(growable: false);
}

/// Hall helpers
List<String> getAvailableHalls() {
  return halls.map((hall) => hall.name).toList()..sort();
}

LaundryRoom? getHallByName(String hallName) {
  return halls.firstWhere(
    (hall) => hall.name == hallName,
    orElse: () => halls.first,
  );
}



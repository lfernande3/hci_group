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

// --- Rooms (2 dorm floors) ----------------------------------------------------

const List<LaundryRoom> halls = [
  LaundryRoom(
    id: 'HALL-8-F2',
    name: 'Hall 8 – Floor 2',
    location: 'Student Residence – Tower 8',
  ),
  LaundryRoom(
    id: 'HALL-10-F3',
    name: 'Hall 10 – Floor 3',
    location: 'Student Residence – Tower 10',
  ),
];

// --- Machine stacks (6+), each with a washer + dryer status -------------------

const List<MachineStack> machines = [
  MachineStack(
    id: 'H8-A',
    roomId: 'HALL-8-F2',
    label: 'Stack A',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 12,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H8-B',
    roomId: 'HALL-8-F2',
    label: 'Stack B',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: 3,
    dryerEtaMinutes: 8,
  ),
  MachineStack(
    id: 'H8-C',
    roomId: 'HALL-8-F2',
    label: 'Stack C',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: null,
    dryerEtaMinutes: null,
  ),
  MachineStack(
    id: 'H10-A',
    roomId: 'HALL-10-F3',
    label: 'Stack A',
    washerStatus: MachineStatus.inUse,
    dryerStatus: MachineStatus.finishingSoon,
    washerEtaMinutes: 17,
    dryerEtaMinutes: 4,
  ),
  MachineStack(
    id: 'H10-B',
    roomId: 'HALL-10-F3',
    label: 'Stack B',
    washerStatus: MachineStatus.free,
    dryerStatus: MachineStatus.inUse,
    washerEtaMinutes: null,
    dryerEtaMinutes: 14,
  ),
  MachineStack(
    id: 'H10-C',
    roomId: 'HALL-10-F3',
    label: 'Stack C',
    washerStatus: MachineStatus.finishingSoon,
    dryerStatus: MachineStatus.free,
    washerEtaMinutes: 2,
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



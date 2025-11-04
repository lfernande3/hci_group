// Demo data for In-App Print Submission (UI-only)

enum PrintType { freeBW, chargedBW, chargedColor }

class BuildingQueue {
  final String buildingId;
  final String buildingName;
  final int waitingJobs;
  final bool isOnline;

  const BuildingQueue({
    required this.buildingId,
    required this.buildingName,
    required this.waitingJobs,
    required this.isOnline,
  });
}

class ReleaseInstruction {
  final String buildingId;
  final PrintType type;
  final List<String> steps;

  const ReleaseInstruction({
    required this.buildingId,
    required this.type,
    required this.steps,
  });
}

// --- Queues per building ------------------------------------------------------

final Map<String, BuildingQueue> queues = {
  'AC2': const BuildingQueue(
    buildingId: 'AC2',
    buildingName: 'Academic 2 (AC2)',
    waitingJobs: 4,
    isOnline: true,
  ),
  'CMC': const BuildingQueue(
    buildingId: 'CMC',
    buildingName: 'Creative Media Centre (CMC)',
    waitingJobs: 2,
    isOnline: true,
  ),
  'LIB': const BuildingQueue(
    buildingId: 'LIB',
    buildingName: 'Library',
    waitingJobs: 7,
    isOnline: false, // offline to demo Wi‑Fi banner
  ),
};

// --- Release instructions per building and print type -------------------------

const List<ReleaseInstruction> instructionsPerBuilding = [
  ReleaseInstruction(
    buildingId: 'AC2',
    type: PrintType.freeBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Go to AC2 printer cluster (2/F)',
      'Tap Free Print terminal',
      'Enter Job ID and CityU number',
      'Collect pages from Tray A',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'AC2',
    type: PrintType.chargedBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Go to AC2 printer cluster (2/F)',
      'Select Charged B/W on terminal',
      'Confirm Octopus payment',
      'Release job and collect pages',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'AC2',
    type: PrintType.chargedColor,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Go to Color printer (label C1)',
      'Select Charged Color on terminal',
      'Confirm payment and finish release',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'CMC',
    type: PrintType.freeBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Proceed to CMC G/F printers',
      'Tap Free Print terminal',
      'Enter Job ID → print',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'CMC',
    type: PrintType.chargedBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'CMC G/F printers → Charged B/W',
      'Confirm payment at terminal',
      'Release job',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'CMC',
    type: PrintType.chargedColor,
    steps: [
      'Connect to CityU Wi‑Fi',
      'CMC Color printer (room 101)',
      'Select Color → confirm payment',
      'Collect prints',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'LIB',
    type: PrintType.freeBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Library 1/F printer area',
      'Free Print terminal → Enter Job ID',
      'Collect output',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'LIB',
    type: PrintType.chargedBW,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Library printers → Charged B/W',
      'Confirm payment',
      'Release and collect',
    ],
  ),
  ReleaseInstruction(
    buildingId: 'LIB',
    type: PrintType.chargedColor,
    steps: [
      'Connect to CityU Wi‑Fi',
      'Library Color printer',
      'Select Color → confirm payment',
      'Collect pages',
    ],
  ),
];

// --- Helpers ------------------------------------------------------------------

ReleaseInstruction? getInstruction(String buildingId, PrintType type) {
  for (final i in instructionsPerBuilding) {
    if (i.buildingId == buildingId && i.type == type) return i;
  }
  return null;
}

List<ReleaseInstruction> getInstructionsForBuilding(String buildingId) {
  return instructionsPerBuilding
      .where((i) => i.buildingId == buildingId)
      .toList(growable: false);
}



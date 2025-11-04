// Demo data for Events Dashboard (UI-only)

enum EventCategory { academic, sports, cultural }

enum EventLanguage { en, zh }

enum RegistrationStatus { open, closed, waitlist }

class Event {
  final String id;
  final String title;
  final String organizer;
  final DateTime startTime;
  final DateTime endTime;
  final String venue;
  final EventCategory category;
  final EventLanguage language;
  final RegistrationStatus registrationStatus;
  final String source; // "CRESDA", "Club", "Curated"
  final String? description;

  const Event({
    required this.id,
    required this.title,
    required this.organizer,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.category,
    required this.language,
    required this.registrationStatus,
    required this.source,
    this.description,
  });
}

// --- Events (10+ from CRESDA, clubs, curated) --------------------------------

final List<Event> allEvents = [
  Event(
    id: 'EVT-001',
    title: 'CRESDA Career Fair 2025',
    organizer: 'CRESDA',
    startTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
    endTime: DateTime.now().add(const Duration(days: 5, hours: 16)),
    venue: 'AC1 Concourse',
    category: EventCategory.academic,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'CRESDA',
    description: 'Meet employers from tech, finance, and consulting sectors.',
  ),
  Event(
    id: 'EVT-002',
    title: 'Basketball Tournament Finals',
    organizer: 'Sports Club',
    startTime: DateTime.now().add(const Duration(days: 3, hours: 14)),
    endTime: DateTime.now().add(const Duration(days: 3, hours: 17)),
    venue: 'Sports Hall',
    category: EventCategory.sports,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
    description: 'Championship match for inter-hall competition.',
  ),
  Event(
    id: 'EVT-003',
    title: 'Mid-Autumn Festival Celebration',
    organizer: 'Cultural Society',
    startTime: DateTime.now().add(const Duration(days: 7, hours: 18)),
    endTime: DateTime.now().add(const Duration(days: 7, hours: 21)),
    venue: 'Cultural Centre',
    category: EventCategory.cultural,
    language: EventLanguage.zh,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
    description: 'Traditional music, mooncakes, and lantern making.',
  ),
  Event(
    id: 'EVT-004',
    title: 'AI & Machine Learning Workshop',
    organizer: 'CS Department',
    startTime: DateTime.now().add(const Duration(days: 2, hours: 14)),
    endTime: DateTime.now().add(const Duration(days: 2, hours: 16)),
    venue: 'AC2-210',
    category: EventCategory.academic,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.waitlist,
    source: 'Curated',
    description: 'Hands-on session on neural networks and TensorFlow.',
  ),
  Event(
    id: 'EVT-005',
    title: 'Badminton Championship',
    organizer: 'Hall 8 Sports Committee',
    startTime: DateTime.now().add(const Duration(days: 4, hours: 10)),
    endTime: DateTime.now().add(const Duration(days: 4, hours: 13)),
    venue: 'Sports Hall',
    category: EventCategory.sports,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.closed,
    source: 'Club',
  ),
  Event(
    id: 'EVT-006',
    title: 'CRESDA Industry Talk: FinTech',
    organizer: 'CRESDA',
    startTime: DateTime.now().add(const Duration(days: 6, hours: 15)),
    endTime: DateTime.now().add(const Duration(days: 6, hours: 17)),
    venue: 'CMC Auditorium',
    category: EventCategory.academic,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'CRESDA',
    description: 'Guest speaker from major investment bank.',
  ),
  Event(
    id: 'EVT-007',
    title: 'Calligraphy Workshop (書法工作坊)',
    organizer: 'Chinese Culture Club',
    startTime: DateTime.now().add(const Duration(days: 8, hours: 14)),
    endTime: DateTime.now().add(const Duration(days: 8, hours: 16)),
    venue: 'Library Study Room 201',
    category: EventCategory.cultural,
    language: EventLanguage.zh,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
    description: 'Learn traditional Chinese calligraphy techniques.',
  ),
  Event(
    id: 'EVT-008',
    title: 'Hackathon 2025',
    organizer: 'CS Student Society',
    startTime: DateTime.now().add(const Duration(days: 10, hours: 9)),
    endTime: DateTime.now().add(const Duration(days: 11, hours: 18)),
    venue: 'CMC Labs',
    category: EventCategory.academic,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'Curated',
    description: '48-hour coding competition with prizes.',
  ),
  Event(
    id: 'EVT-009',
    title: 'Swimming Meet',
    organizer: 'Aquatics Club',
    startTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
    endTime: DateTime.now().add(const Duration(days: 1, hours: 12)),
    venue: 'Swimming Pool',
    category: EventCategory.sports,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
  ),
  Event(
    id: 'EVT-010',
    title: 'Film Screening: "The Social Network"',
    organizer: 'Film Society',
    startTime: DateTime.now().add(const Duration(days: 9, hours: 19)),
    endTime: DateTime.now().add(const Duration(days: 9, hours: 21, minutes: 30)),
    venue: 'CMC Screening Room',
    category: EventCategory.cultural,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
    description: 'Discussion panel after screening.',
  ),
  Event(
    id: 'EVT-011',
    title: 'CRESDA Resume Review Session',
    organizer: 'CRESDA',
    startTime: DateTime.now().add(const Duration(days: 12, hours: 14)),
    endTime: DateTime.now().add(const Duration(days: 12, hours: 16)),
    venue: 'CRESDA Office',
    category: EventCategory.academic,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'CRESDA',
    description: 'One-on-one feedback from career advisors.',
  ),
  Event(
    id: 'EVT-012',
    title: 'Table Tennis Tournament',
    organizer: 'Sports Club',
    startTime: DateTime.now().add(const Duration(days: 5, hours: 15)),
    endTime: DateTime.now().add(const Duration(days: 5, hours: 18)),
    venue: 'Sports Hall',
    category: EventCategory.sports,
    language: EventLanguage.en,
    registrationStatus: RegistrationStatus.open,
    source: 'Club',
  ),
];

// --- Helpers ------------------------------------------------------------------

List<Event> filterEventsByCategory(EventCategory category) {
  return allEvents.where((e) => e.category == category).toList(growable: false);
}

List<Event> filterEventsByLanguage(EventLanguage language) {
  return allEvents.where((e) => e.language == language).toList(growable: false);
}

List<Event> filterEventsByDateRange(DateTime start, DateTime end) {
  return allEvents
      .where((e) =>
          e.startTime.isAfter(start.subtract(const Duration(days: 1))) &&
          e.startTime.isBefore(end.add(const Duration(days: 1))))
      .toList(growable: false);
}

List<Event> searchEvents(String query) {
  final lowerQuery = query.toLowerCase();
  return allEvents
      .where((e) =>
          e.title.toLowerCase().contains(lowerQuery) ||
          e.organizer.toLowerCase().contains(lowerQuery) ||
          (e.description?.toLowerCase().contains(lowerQuery) ?? false))
      .toList(growable: false);
}


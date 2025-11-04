import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar configuration entity
class NavbarConfig extends Equatable {
  final List<NavbarItem> items;
  final int maxItems;

  const NavbarConfig({
    required this.items,
    this.maxItems = 5,
  });

  /// Default navbar configuration
  factory NavbarConfig.defaultConfig() {
    return NavbarConfig(
      items: [
        NavbarItem.homepage(),
        NavbarItem.timetable(),
        NavbarItem.qrCode(),
        NavbarItem.chatbot(),
        NavbarItem.settings(),
      ],
    );
  }

  /// Check if we can add more items
  bool get canAddMore => items.length < maxItems;

  /// Add item to navbar
  NavbarConfig addItem(NavbarItem item) {
    if (!canAddMore) return this;
    return copyWith(items: [...items, item]);
  }

  /// Remove item from navbar
  NavbarConfig removeItem(String itemId) {
    return copyWith(
      items: items.where((item) => item.id != itemId).toList(),
    );
  }

  /// Reorder items
  NavbarConfig reorderItems(List<NavbarItem> newOrder) {
    return copyWith(items: newOrder);
  }

  /// Copy with new values
  NavbarConfig copyWith({
    List<NavbarItem>? items,
    int? maxItems,
  }) {
    return NavbarConfig(
      items: items ?? this.items,
      maxItems: maxItems ?? this.maxItems,
    );
  }

  @override
  List<Object?> get props => [items, maxItems];
}

/// Individual navbar item
class NavbarItem extends Equatable {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final bool isEnabled;

  const NavbarItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.isEnabled = true,
  });

  // Factory constructors for default items
  factory NavbarItem.homepage() => const NavbarItem(
        id: 'homepage',
        label: 'Home',
        icon: Icons.home,
        route: '/',
      );

  factory NavbarItem.timetable() => const NavbarItem(
        id: 'timetable',
        label: 'Timetable',
        icon: Icons.calendar_view_week,
        route: '/timetable',
      );

  factory NavbarItem.chatbot() => const NavbarItem(
        id: 'chatbot',
        label: 'Chatbot',
        icon: Icons.smart_toy,
        route: '/chatbot',
      );

  factory NavbarItem.qrCode() => const NavbarItem(
        id: 'qr',
        label: 'CityU ID',
        icon: Icons.qr_code,
        route: '/qr',
      );

  factory NavbarItem.account() => const NavbarItem(
        id: 'account',
        label: 'Account',
        icon: Icons.account_circle,
        route: '/account',
      );

  factory NavbarItem.settings() => const NavbarItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings,
        route: '/settings',
      );

  factory NavbarItem.campusMap() => const NavbarItem(
        id: 'campus-map',
        label: 'Campus',
        icon: Icons.map,
        route: '/campus-map',
      );

  factory NavbarItem.roomAvailability() => const NavbarItem(
        id: 'room-availability',
        label: 'Rooms',
        icon: Icons.meeting_room,
        route: '/room-availability',
      );

  factory NavbarItem.academicCalendar() => const NavbarItem(
        id: 'academic-calendar',
        label: 'Calendar',
        icon: Icons.event,
        route: '/academic-calendar',
      );

  factory NavbarItem.authenticator() => const NavbarItem(
        id: 'authenticator',
        label: 'Auth',
        icon: Icons.security,
        route: '/authenticator',
      );

  factory NavbarItem.sportsFacilities() => const NavbarItem(
        id: 'sports-facilities',
        label: 'Sports',
        icon: Icons.sports,
        route: '/sports-facilities',
      );

  factory NavbarItem.contacts() => const NavbarItem(
        id: 'contacts',
        label: 'Contacts',
        icon: Icons.contacts,
        route: '/contacts',
      );

  factory NavbarItem.emergency() => const NavbarItem(
        id: 'emergency',
        label: 'Emergency',
        icon: Icons.emergency,
        route: '/emergency',
      );

  factory NavbarItem.news() => const NavbarItem(
        id: 'news',
        label: 'News',
        icon: Icons.newspaper,
        route: '/news',
      );

  factory NavbarItem.cap() => const NavbarItem(
        id: 'cap',
        label: 'CAP',
        icon: Icons.school,
        route: '/cap',
      );

  factory NavbarItem.booking() => const NavbarItem(
        id: 'booking',
        label: 'Booking',
        icon: Icons.event_seat,
        route: '/booking',
      );

  factory NavbarItem.laundry() => const NavbarItem(
        id: 'laundry',
        label: 'Laundry',
        icon: Icons.local_laundry_service,
        route: '/laundry',
      );

  factory NavbarItem.printSubmission() => const NavbarItem(
        id: 'print',
        label: 'Print',
        icon: Icons.print,
        route: '/print',
      );

  factory NavbarItem.events() => const NavbarItem(
        id: 'events',
        label: 'Events',
        icon: Icons.event_note,
        route: '/events',
      );

  /// Copy with new values
  NavbarItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? route,
    bool? isEnabled,
  }) {
    return NavbarItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [id, label, icon, route, isEnabled];
}

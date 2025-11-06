import 'package:flutter/material.dart';
import '../../../features/navigation/data/models/navbar_config_model.dart';

/// Mock data source specifically for navbar configuration
class MockNavbarDataSource {
  /// Default navbar configuration
  static final List<NavbarItemModel> defaultNavbarItems = [
    NavbarItemModel(
      id: 'timetable',
      label: 'Timetable',
      icon: Icons.calendar_today,
      route: '/',
      isEnabled: true,
    ),
    NavbarItemModel(
      id: 'chatbot',
      label: 'Chatbot',
      icon: Icons.chat_bubble,
      route: '/chatbot',
      isEnabled: true,
    ),
    NavbarItemModel(
      id: 'qr',
      label: 'CityU ID',
      icon: Icons.qr_code_2,
      route: '/qr',
      isEnabled: true,
    ),
    NavbarItemModel(
      id: 'account',
      label: 'Account',
      icon: Icons.account_circle,
      route: '/account',
      isEnabled: true,
    ),
    NavbarItemModel(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings,
      route: '/settings',
      isEnabled: true,
    ),
  ];

  /// Available navbar items that can be added
  static final List<NavbarItemModel> availableNavbarItems = [
    NavbarItemModel(
      id: 'timetable',
      label: 'Timetable',
      icon: Icons.calendar_today,
      route: '/',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'chatbot',
      label: 'Chatbot',
      icon: Icons.chat_bubble,
      route: '/chatbot',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'qr',
      label: 'CityU ID',
      icon: Icons.qr_code_2,
      route: '/qr',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'account',
      label: 'Account',
      icon: Icons.account_circle,
      route: '/account',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings,
      route: '/settings',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'campus_map',
      label: 'Campus Map',
      icon: Icons.map,
      route: '/campus-map',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'room_availability',
      label: 'Room Availability',
      icon: Icons.meeting_room,
      route: '/rooms',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'academic_calendar',
      label: 'Academic Calendar',
      icon: Icons.event,
      route: '/calendar',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'authenticator',
      label: 'Authenticator',
      icon: Icons.security,
      route: '/auth',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'sports_facilities',
      label: 'Sports Facilities',
      icon: Icons.sports_tennis,
      route: '/sports',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'contacts',
      label: 'Contacts',
      icon: Icons.contacts,
      route: '/contacts',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'emergency',
      label: 'Emergency',
      icon: Icons.emergency,
      route: '/emergency',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'news',
      label: 'News',
      icon: Icons.article,
      route: '/news',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'cap',
      label: 'CAP',
      icon: Icons.school,
      route: '/cap',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'booking',
      label: 'Booking',
      icon: Icons.event_seat,
      route: '/booking',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'laundry',
      label: 'Laundry',
      icon: Icons.local_laundry_service,
      route: '/laundry',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'print',
      label: 'Print',
      icon: Icons.print,
      route: '/print',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'events',
      label: 'Events',
      icon: Icons.event_note,
      route: '/events',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'ac_management',
      label: 'A/C Management',
      icon: Icons.ac_unit,
      route: '/ac-management',
      isEnabled: false,
    ),
    NavbarItemModel(
      id: 'visitor_registration',
      label: 'Visitor Registration',
      icon: Icons.person_add,
      route: '/visitor-registration',
      isEnabled: false,
    ),
  ];

  /// Get default navbar configuration
  Future<NavbarConfigModel> getDefaultNavbarConfig() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate loading delay
    
    return NavbarConfigModel(
      items: defaultNavbarItems,
      maxItems: 5,
    );
  }

  /// Get all available navbar items
  Future<List<NavbarItemModel>> getAvailableNavbarItems() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate loading delay
    return availableNavbarItems;
  }

  /// Save navbar configuration (mock implementation)
  Future<bool> saveNavbarConfig(NavbarConfigModel config) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate save delay
    // In a real implementation, this would save to a database or API
    return true;
  }

  /// Reset to default configuration
  Future<NavbarConfigModel> resetToDefault() async {
    await Future.delayed(const Duration(milliseconds: 150)); // Simulate reset delay
    return await getDefaultNavbarConfig();
  }
}
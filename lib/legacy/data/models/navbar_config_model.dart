import 'package:flutter/material.dart';
import '../../domain/entities/navbar_config.dart';

/// Navbar configuration data model for serialization/deserialization
class NavbarConfigModel extends NavbarConfig {
  const NavbarConfigModel({
    required super.items,
    super.maxItems = 5,
  });

  /// Create from domain entity
  factory NavbarConfigModel.fromEntity(NavbarConfig config) {
    return NavbarConfigModel(
      items: config.items.map((item) => NavbarItemModel.fromEntity(item)).toList(),
      maxItems: config.maxItems,
    );
  }

  /// Create from JSON
  factory NavbarConfigModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items = itemsJson
        .map((itemJson) => NavbarItemModel.fromJson(itemJson as Map<String, dynamic>))
        .toList();

    return NavbarConfigModel(
      items: items,
      maxItems: json['maxItems'] ?? 5,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => NavbarItemModel.fromEntity(item).toJson()).toList(),
      'maxItems': maxItems,
    };
  }

  /// Convert to domain entity
  NavbarConfig toEntity() {
    return NavbarConfig(
      items: items,
      maxItems: maxItems,
    );
  }

  /// Create default configuration
  factory NavbarConfigModel.defaultConfig() {
    return NavbarConfigModel(
      items: [
        NavbarItemModel(
          id: 'homepage',
          label: 'Home',
          icon: Icons.home,
          route: '/',
        ),
        NavbarItemModel(
          id: 'timetable',
          label: 'Timetable',
          icon: Icons.calendar_view_week,
          route: '/timetable',
        ),
        NavbarItemModel(
          id: 'qr',
          label: 'CityU ID',
          icon: Icons.qr_code,
          route: '/qr',
        ),
        NavbarItemModel(
          id: 'chatbot',
          label: 'Chatbot',
          icon: Icons.smart_toy,
          route: '/chatbot',
        ),
        NavbarItemModel(
          id: 'account',
          label: 'Account',
          icon: Icons.account_circle,
          route: '/account',
        ),
      ],
    );
  }

  /// Copy with new values
  @override
  NavbarConfigModel copyWith({
    List<NavbarItem>? items,
    int? maxItems,
  }) {
    return NavbarConfigModel(
      items: items ?? this.items,
      maxItems: maxItems ?? this.maxItems,
    );
  }
}

/// Navbar item data model
class NavbarItemModel extends NavbarItem {
  const NavbarItemModel({
    required super.id,
    required super.label,
    required super.icon,
    required super.route,
    super.isEnabled = true,
  });

  /// Create from domain entity
  factory NavbarItemModel.fromEntity(NavbarItem item) {
    return NavbarItemModel(
      id: item.id,
      label: item.label,
      icon: item.icon,
      route: item.route,
      isEnabled: item.isEnabled,
    );
  }

  /// Create from JSON
  factory NavbarItemModel.fromJson(Map<String, dynamic> json) {
    // Map icon names to actual icons
    final iconName = json['iconName'] ?? 'settings';
    final icon = _getIconFromName(iconName);
    
    return NavbarItemModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      icon: icon,
      route: json['route'] ?? '/',
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'iconName': _getIconName(icon),
      'route': route,
      'isEnabled': isEnabled,
    };
  }

  /// Convert to domain entity
  NavbarItem toEntity() {
    return NavbarItem(
      id: id,
      label: label,
      icon: icon,
      route: route,
      isEnabled: isEnabled,
    );
  }

  /// Copy with new values
  @override
  NavbarItemModel copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? route,
    bool? isEnabled,
  }) {
    return NavbarItemModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Helper method to get icon from name
  static IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'timetable':
        return Icons.calendar_view_week;
      case 'qr':
        return Icons.qr_code;
      case 'chatbot':
        return Icons.smart_toy;
      case 'account':
        return Icons.account_circle;
      case 'settings':
        return Icons.settings;
      case 'campus':
        return Icons.map;
      case 'rooms':
        return Icons.meeting_room;
      case 'calendar':
        return Icons.event;
      case 'auth':
        return Icons.security;
      case 'sports':
        return Icons.sports;
      case 'contacts':
        return Icons.contacts;
      case 'emergency':
        return Icons.emergency;
      case 'news':
        return Icons.newspaper;
      case 'school':
        return Icons.school;
      case 'booking':
        return Icons.event_seat;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'print':
        return Icons.print;
      case 'events':
        return Icons.event_note;
      default:
        return Icons.settings;
    }
  }

  /// Helper method to get icon name from IconData
  static String _getIconName(IconData icon) {
    if (icon == Icons.home) return 'home';
    if (icon == Icons.calendar_view_week) return 'timetable';
    if (icon == Icons.qr_code) return 'qr';
    if (icon == Icons.smart_toy) return 'chatbot';
    if (icon == Icons.account_circle) return 'account';
    if (icon == Icons.settings) return 'settings';
    if (icon == Icons.map) return 'campus';
    if (icon == Icons.meeting_room) return 'rooms';
    if (icon == Icons.event) return 'calendar';
    if (icon == Icons.security) return 'auth';
    if (icon == Icons.sports) return 'sports';
    if (icon == Icons.contacts) return 'contacts';
    if (icon == Icons.emergency) return 'emergency';
    if (icon == Icons.newspaper) return 'news';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.event_seat) return 'booking';
    if (icon == Icons.local_laundry_service) return 'laundry';
    if (icon == Icons.print) return 'print';
    if (icon == Icons.event_note) return 'events';
    return 'settings';
  }
}

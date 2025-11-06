// Demo data for Dorm Services (A/C Management & Visitor Registration)

import 'package:flutter/material.dart';

/// A/C Usage data for a single hour
class ACUsageHour {
  final DateTime hour;
  final double usageHours; // Hours of A/C usage in that hour

  const ACUsageHour({
    required this.hour,
    required this.usageHours,
  });
}

/// A/C Balance Status
enum ACBalanceStatus {
  sufficient, // Green - >20 hours remaining
  low,        // Yellow - 5-20 hours remaining
  critical,   // Red - <5 hours remaining
}

/// A/C Details for a student's room
class ACDetails {
  final String roomNumber;
  final double balanceHours; // Remaining A/C hours
  final ACBalanceStatus status;
  final DateTime lastUpdated;
  final List<ACUsageHour> usageHistory; // Last 24 hours

  const ACDetails({
    required this.roomNumber,
    required this.balanceHours,
    required this.status,
    required this.lastUpdated,
    required this.usageHistory,
  });
}

/// Get A/C details for demo (mock data)
ACDetails getACDetails() {
  // Generate usage history for last 24 hours
  final now = DateTime.now();
  final usageHistory = <ACUsageHour>[];
  
  // Generate realistic usage pattern (more usage during day, less at night)
  for (int i = 23; i >= 0; i--) {
    final hour = now.subtract(Duration(hours: i));
    final hourOfDay = hour.hour;
    
    // More usage during day (8 AM - 10 PM), less at night
    double usage;
    if (hourOfDay >= 8 && hourOfDay < 22) {
      // Daytime: 0.3-0.8 hours per hour
      usage = 0.3 + (hourOfDay % 3) * 0.15;
    } else {
      // Nighttime: 0.0-0.2 hours per hour
      usage = (hourOfDay % 2) * 0.1;
    }
    
    usageHistory.add(ACUsageHour(
      hour: hour,
      usageHours: usage,
    ));
  }
  
  // Calculate current balance (demo: 15.5 hours remaining)
  const balanceHours = 15.5;
  final status = balanceHours >= 20
      ? ACBalanceStatus.sufficient
      : balanceHours >= 5
          ? ACBalanceStatus.low
          : ACBalanceStatus.critical;
  
  return ACDetails(
    roomNumber: 'Hall 8 - Room 1205',
    balanceHours: balanceHours,
    status: status,
    lastUpdated: now,
    usageHistory: usageHistory,
  );
}

/// Get color for A/C balance status
Color getACStatusColor(ACBalanceStatus status) {
  switch (status) {
    case ACBalanceStatus.sufficient:
      return const Color(0xFF4CAF50); // Green
    case ACBalanceStatus.low:
      return const Color(0xFFFF9800); // Yellow/Orange
    case ACBalanceStatus.critical:
      return const Color(0xFFE53935); // Red
  }
}

/// Mock NFC validation for visitor registration
bool mockNfcValidation(String studentId) {
  // Mock validation - in real app, this would check against dorm server
  // For demo, accept any student ID that starts with valid format
  return studentId.isNotEmpty && studentId.length >= 8;
}

/// Get formatted balance text
String formatBalanceHours(double hours) {
  if (hours >= 1) {
    return '${hours.toStringAsFixed(1)} hrs';
  } else {
    final minutes = (hours * 60).round();
    return '$minutes min';
  }
}


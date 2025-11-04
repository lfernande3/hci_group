import 'package:flutter/material.dart';

/// CityU brand colors and app color scheme
class AppColors {
  // CityU Brand Colors
  static const Color primary = Color(0xFFA50034); // Burgundy
  static const Color secondaryOrange = Color(0xFFF58220); // Orange
  static const Color secondaryPurple = Color(0xFF6A1B9A); // Purple
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey900 = Color(0xFF212121);
  
  // Transparent variants (for widget backgrounds as per PRD)
  static const Color transparentWhite = Color(0x80FFFFFF);
  static const Color transparentBlack = Color(0x80000000);
  static const Color primaryTransparent = Color(0x1AA50034); // 10% opacity
  static const Color primarySemiTransparent = Color(0x4DA50034); // 30% opacity
  
  // Widget-specific colors (for Next Event widget)
  static const Color widgetBackground = Color(0x00FFFFFF); // Fully transparent
  static const Color widgetAccent = primary; // Burgundy accents
  static const Color widgetShadow = Color(0x1A000000); // Subtle shadow
}

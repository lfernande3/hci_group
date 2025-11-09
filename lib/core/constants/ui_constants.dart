import 'package:flutter/material.dart';

/// Standardized UI constants for consistent button dimensions and spacing
/// Aligned with AppTheme button styles
class UIConstants {
  UIConstants._(); // Private constructor to prevent instantiation

  // Button padding constants (aligned with AppTheme)
  /// Standard elevated button padding
  static const EdgeInsets elevatedButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );

  /// Standard text button padding
  static const EdgeInsets textButtonPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  /// Standard outlined button padding
  static const EdgeInsets outlinedButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );

  /// Large button padding (for primary actions)
  static const EdgeInsets largeButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  /// Compact button padding (for icon buttons with text)
  static const EdgeInsets compactButtonPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  // Button border radius (aligned with AppTheme)
  /// Standard button border radius
  static const double buttonBorderRadius = 8.0;

  /// Card border radius
  static const double cardBorderRadius = 12.0;

  // Standard spacing
  /// Standard horizontal padding for content
  static const double contentHorizontalPadding = 16.0;

  /// Standard vertical padding for content
  static const double contentVerticalPadding = 16.0;

  /// Standard spacing between elements
  static const double standardSpacing = 16.0;

  /// Small spacing between elements
  static const double smallSpacing = 8.0;

  /// Large spacing between sections
  static const double largeSpacing = 24.0;

  /// Extra large spacing between major sections
  static const double extraLargeSpacing = 32.0;
}


import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'QuickNotes';
  static const String appVersion = '1.0.0';

  // Theme Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);

  // Note Colors
  static const List<Color> noteColors = [
    Color(0xFFFFFFFF), // White
    Color(0xFFFFEBEE), // Light Red
    Color(0xFFE8F5E8), // Light Green
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFFFF3E0), // Light Orange
    Color(0xFFF3E5F5), // Light Purple
    Color(0xFFE0F2F1), // Light Teal
    Color(0xFFFFF8E1), // Light Yellow
  ];

  // Categories
  static const List<String> categories = [
    'General',
    'Work',
    'Personal',
    'Ideas',
    'Shopping',
    'Travel',
    'Health',
    'Education',
  ];

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  // Messages
  static const String noNotesMessage =
      'No notes yet.\nTap + to create your first note!';
  static const String noSearchResultsMessage =
      'No notes found.\nTry a different search term.';
  static const String deleteConfirmMessage =
      'Are you sure you want to delete this note?';
  static const String emptyTitleError = 'Please enter a title';
  static const String emptyDescriptionError = 'Please enter a description';

  // Validation
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 5000;

  // Additional Messages
  static const String noteDeletedMessage = 'Note deleted';
  static const String undoMessage = 'UNDO';
  static const String notePinnedMessage = 'Note pinned';
  static const String noteUnpinnedMessage = 'Note unpinned';
}

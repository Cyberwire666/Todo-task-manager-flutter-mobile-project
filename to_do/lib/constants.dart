import 'package:flutter/material.dart';

class Constants {
  // App Title
  static const String appTitle = 'Task Management App';

  // Firestore Collections
  static const String userCollection = 'users';
  static const String taskCollection = 'tasks';

  // Color Palette
  static const Color primaryColor = Color(0xFF6200EE);  // Primary color (example)
  static const Color secondaryColor = Color(0xFF03DAC6);  // Secondary color
  static const Color errorColor = Color(0xFFB00020);  // Error color for buttons and warnings
  static const Color backgroundColor = Color(0xFFF5F5F5);  // Background color for the app
  static const Color textColor = Colors.black87;  // Text color, can be used in multiple parts of the app
  static const Color buttonTextColor = Colors.white;  // Text color for buttons

  // Button Styles
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,  // Background color of the button (changed from primary to backgroundColor)
    foregroundColor: buttonTextColor,  // Text color for the button
    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );

  static final ButtonStyle errorButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: errorColor,  // Background color of the button (changed from primary to backgroundColor)
    foregroundColor: buttonTextColor,  // Text color for the button
    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );

  // Text Styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    color: errorColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: buttonTextColor,  // Button text color (white)
  );
}

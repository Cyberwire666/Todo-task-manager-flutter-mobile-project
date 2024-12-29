import 'package:flutter/material.dart';

// Constants class to centralize app-wide configurations
class Constants {
  // App Title: This is the global title of the application.
  static const String appTitle = 'Task Management App';

  // Firestore Collections: Collection names used for Firestore database.
  static const String userCollection = 'users'; // Collection for user data
  static const String taskCollection = 'tasks'; // Collection for task data

  // Color Palette: Define colors to maintain consistent UI theming throughout the app.
  static const Color primaryColor = Color(0xFF6200EE); // Primary color used for app's key UI elements
  static const Color secondaryColor = Color(0xFF03DAC6); // Accent/Secondary color for highlighting elements
  static const Color errorColor = Color(0xFFB00020); // Error color for warnings and error states
  static const Color backgroundColor = Color(0xFFF5F5F5); // General background color for the app
  static const Color textColor = Colors.black87; // Default text color used across the app
  static const Color buttonTextColor = Colors.white; // Text color for buttons to ensure readability

  // Button Styles: Predefined button styles for consistency in UI.
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor, // Button's background color (primary theme color)
    foregroundColor: buttonTextColor, // Text color used in buttons
    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0), // Padding for the button
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Button with rounded corners
  );

  static final ButtonStyle errorButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: errorColor, // Button color for error states
    foregroundColor: buttonTextColor, // Text color for error buttons
    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0), // Padding for the button
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Rounded corner shape
  );

  // Text Styles: Predefined text styles for different purposes in the app.
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24, // Font size for titles
    fontWeight: FontWeight.bold, // Bold font for emphasis
    color: textColor, // Default text color for titles
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16, // Font size for regular body text
    color: textColor, // Default text color for body content
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14, // Font size for error messages
    color: errorColor, // Text color for errors
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16, // Font size for button text
    fontWeight: FontWeight.w600, // Semi-bold weight for emphasis
    color: buttonTextColor, // Text color for button text (white for contrast)
  );
}

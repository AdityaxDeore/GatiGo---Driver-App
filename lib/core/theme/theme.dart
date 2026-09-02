import 'package:flutter/material.dart';

class PinkAppTheme {
  // Theme Color Palette
  static const Color primaryPink = Color(0xFFFA4EAB); // Electric Rose
  static const Color secondaryPink = Color(0xFFFE83C6); // Soft Magenta
  static const Color accentPurple = Color(0xFF4B0082); // Indigo/Amethyst Purple
  static const Color backgroundLight = Color(0xFFFFF2F9); // Blush Mist
  static const Color backgroundWhite = Colors.white;
  
  static const Color textDark = Color(0xFF323232);
  static const Color textLight = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryPink,
      colorScheme: const ColorScheme.light(
        primary: primaryPink,
        secondary: secondaryPink,
        tertiary: accentPurple,
        surface: backgroundWhite,
        error: error,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Text styling
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: textDark,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: textLight,
          height: 1.4,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: textOnPrimary,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPurple,
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration (Text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.all(18.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: primaryPink, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textLight),
        hintStyle: const TextStyle(color: textLight),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Centralizes the visual styling properties for both light and dark display modes
class AppTheme {
  AppTheme._();

  // Defines global colors, light AppBar styles, and form field styling for Light Mode
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[50], 
      
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        shape: Border(
          bottom: BorderSide(
            color: const Color.fromARGB(44, 238, 238, 238)!, 
            width: 1.0,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Defines global colors, custom dark purple AppBar styles, and dark form field presets for Dark Mode
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212), 
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Color(0xFF1E1430), 
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF38255C), 
            width: 1.2,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}
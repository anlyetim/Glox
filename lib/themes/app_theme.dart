import 'package:flutter/material.dart';
import '../models/theme_config.dart';

/// App theme definitions
class AppTheme {
  /// Get theme data based on theme config and accent color
  static ThemeData getTheme(ThemeConfig config, Color accentColor) {
    final isDark = config.isDark;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accentColor,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accentColor.withValues(alpha: 0.8),
        onSecondary: isDark ? Colors.black : Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: config.backgroundColor,
        onSurface: config.textColor,
      ),

      // Scaffold
      scaffoldBackgroundColor: config.backgroundColor,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: config.backgroundColor,
        foregroundColor: config.textColor,
        elevation: 0,
        centerTitle: true,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: config.textColor,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: config.textColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: config.textColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: config.textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: config.textColor,
          fontSize: 14,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Icon button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: config.textColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
